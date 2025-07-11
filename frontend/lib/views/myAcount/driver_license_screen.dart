import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/models/user/userLicense.dart';
import 'package:frontend/viewmodels/user/user_license_viewmodel.dart';
import 'package:frontend/viewmodels/user/user_provider_viewmodel.dart';
import 'package:frontend/views/widgets/custom_alert_dialog.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_dropdown_formfield.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';
import 'package:frontend/views/widgets/custom_text_body_m_sb.dart';
import 'package:frontend/views/widgets/customs_box_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DriverLicenseScreen extends StatefulWidget {
  final String? name;
  final UserLicense? license;

  const DriverLicenseScreen({super.key, this.name, this.license});

  @override
  State<DriverLicenseScreen> createState() => _DriverLicenseScreen();
}

class _DriverLicenseScreen extends State<DriverLicenseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _licenseNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _slectedTypeDriver;

  final List<String> _typeDriver = [
    'License (does not expire)',
    'License (expire)',
  ];

  final ImagePicker _picker = ImagePicker();
  XFile? _frontViewPicture;
  XFile? _backViewPicture;

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (type == 'front') {
          _frontViewPicture = image;
        } else {
          _backViewPicture = image;
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userVM = Provider.of<UserViewModel>(context);
    final user = userVM.user;
    _nameController.text = user?.fullName ?? 'Unknown';

    final license = widget.license;
    if (license != null) {
      _licenseNumberController.text = license.licenseNumber;
      _classController.text = license.classLicense;
      _slectedTypeDriver = license.typeDriverLicense;
      

    }
  }

  @override
  Widget build(BuildContext context) {
    final userLincenseVM = Provider.of<UserLicenseViewModel>(context, listen: false);
    final isEditMode = widget.license != null;

    return Scaffold(
      appBar: CustomAppbar(
        backgroundColor: const Color(0xff1976D2),
        title: isEditMode ? "Edit Driver's License" : "Add Driver's License",
        textColor: const Color(0xffFFFFFF),
        height: 80,
      ),
      body: Container(
        color: const Color(0xffFCFCFC),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextBodyMsb(title: 'Name'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Enter your name',
                  validator: (value) => (value == null || value.isEmpty) ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 24),
                CustomTextBodyMsb(title: "Type of Driver's License"),
                const SizedBox(height: 8),
                CustomDropdownButtonFormField(
                  value: _slectedTypeDriver,
                  onChanged: (value) => setState(() => _slectedTypeDriver = value),
                  items: _typeDriver,
                  validator: (value) => (value == null || value.isEmpty) ? 'Please select' : null,
                ),
                const SizedBox(height: 24),
                CustomTextBodyMsb(title: "License Number"),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _licenseNumberController,
                  hintText: 'Exp: 123456789',
                  validator: (value) => (value == null || value.isEmpty) ? 'Please enter your License Number' : null,
                ),
                const SizedBox(height: 24),
                CustomTextBodyMsb(title: 'Class'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _classController,
                  hintText: 'Exp: A1',
                  validator: (value) => (value == null || value.isEmpty) ? 'Please enter your Class' : null,
                ),
                const SizedBox(height: 24),
                CustomTextBodyMsb(title: 'Images'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 120,
                        child: CustomBoxImage(
                          title: 'Front',
                          hintText: 'Upload front',
                          image: _frontViewPicture,
                          imageUrl: widget.license?.frontImage,
                          onPickImage: () => _pickImage('front'),
                          validator: (image) => (!isEditMode && image == null) ? 'Image is required' : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 120,
                        child: CustomBoxImage(
                          title: 'Back',
                          hintText: 'Upload back',
                          image: _backViewPicture,
                          imageUrl: widget.license?.backImage,
                          onPickImage: () => _pickImage('back'),
                          validator: (image) => (!isEditMode && image == null) ? 'Image is required' : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: CustomButton(
          title: isEditMode ? 'Update' : 'Create',
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              final type =_slectedTypeDriver!;
              final classLicense = _classController.text;
              final licenseNumber = _licenseNumberController.text;

              // Nếu là tạo mới
              if (widget.license == null) {
                if (_frontViewPicture == null || _backViewPicture == null) {
                  await showDialog(
                    context: context,
                    builder: (context) => CustomAlertDialog(
                      title: 'Missing image',
                      content: 'Please upload both front and back images.',
                      buttonText: 'OK',
                    ),
                  );
                  return;
                }

                final result = await userLincenseVM.createDriverLicense(
                  typeOfDriverLicense: type,
                  classLicense: classLicense,
                  licenseNumber: licenseNumber,
                  frontImage: File(_frontViewPicture!.path),
                  backImage: File(_backViewPicture!.path),
                );

                if (result) {
                  await showDialog(
                    context: context,
                    builder: (context) => CustomAlertDialog(
                      title: 'Success',
                      content: "Driver's license created successfully.",
                      buttonText: 'OK',
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    ),
                  );
                } else {
                  await showDialog(
                    context: context,
                    builder: (context) => CustomAlertDialog(
                      title: 'Error',
                      content: "Failed to create driver's license.",
                      buttonText: 'OK',
                    ),
                  );
                }
              }
              // Nếu là cập nhật
              else {
                final result = await userLincenseVM.updateDriverLicense(
                  typeOfDriverLicense: type,
                  classLicense: classLicense,
                  licenseNumber: licenseNumber,
                  frontImage: _frontViewPicture != null ? File(_frontViewPicture!.path) : null,
                  backImage: _backViewPicture != null ? File(_backViewPicture!.path) : null,
                );

                if (result) {
                  await showDialog(
                    context: context,
                    builder: (context) => CustomAlertDialog(
                      title: 'Success',
                      content: "Driver's license updated successfully.",
                      buttonText: 'OK',
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    ),
                  );
                } else {
                  await showDialog(
                    context: context,
                    builder: (context) => CustomAlertDialog(
                      title: 'Error',
                      content: "Failed to update driver's license.",
                      buttonText: 'OK',
                    ),
                  );
                }
              }
            }
          }
        ),
      ),
    );
  }
}
