import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/user/user_license_viewmodel.dart';
import 'package:frontend/viewmodels/user/user_provider_viewmodel.dart';
import 'package:frontend/views/home/profile_screen.dart';
import 'package:frontend/views/widgets/custom_alert_dialog.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_dropdown_formfield.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';
import 'package:frontend/views/widgets/custom_text_body_M_sb.dart';
import 'package:frontend/views/widgets/customs_box_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DriverLicenseScreen extends StatefulWidget {
  final String? name;

  const DriverLicenseScreen({super.key, this.name});

  @override
  State<DriverLicenseScreen> createState() => _DriverLicenseScreen();
}

class _DriverLicenseScreen extends State<DriverLicenseScreen> {
  late TextEditingController _nameController = TextEditingController();
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
        switch (type) {
          case 'front':
            _frontViewPicture = image;
            break;
          case 'back':
            _backViewPicture = image;
            break;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userVM = Provider.of<UserViewModel>(context);
    final user = userVM.user;
    _nameController.text =
        user?.fullName.isNotEmpty == true ? user!.fullName : 'Bro';
  }

  @override
  Widget build(BuildContext context) {
    final userLincenseVM = Provider.of<UserLicenseViewModel>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: CustomAppbar(
        backgroundColor: Color(0xff1976D2),
        title: "Driver' s License",
        textColor: Color(0xffFFFFFF),
        height: 80,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color(0xffFCFCFC),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextBodyMsb(title: 'Name'),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _nameController,
                        hintText: _nameController.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      CustomTextBodyMsb(title: "Type of Driver's License"),
                      const SizedBox(height: 8),
                      CustomDropdownButtonFormField(
                        value: _slectedTypeDriver,
                        onChanged: (value) {
                          setState(() {
                            _slectedTypeDriver = value;
                          });
                        },
                        items: _typeDriver,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Please select'
                                    : null,
                      ),
                      const SizedBox(height: 24),
                      CustomTextBodyMsb(title: "License Number"),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _licenseNumberController,
                        hintText: 'Exp: 123456789',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your License Number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      CustomTextBodyMsb(title: 'Class'),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _classController,
                        hintText: 'Exp: A1',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Class';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      CustomTextBodyMsb(title: 'Images'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomBoxImage(
                              title: 'Right view picture',
                              hintText: 'Take a photo',
                              image: _frontViewPicture,
                              onPickImage: () => _pickImage('front'),
                              validator:
                                  (image) =>
                                      image == null
                                          ? 'Image is required'
                                          : null,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: CustomBoxImage(
                              title: 'Right view picture',
                              hintText: 'Take a photo',
                              image: _backViewPicture,
                              onPickImage: () => _pickImage('back'),
                              validator:
                                  (image) =>
                                      image == null
                                          ? 'Image is required'
                                          : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: CustomButton(
          title: 'Save',
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) { 
               if (_frontViewPicture != null && _backViewPicture != null) {
                File frontFile = File(_frontViewPicture!.path);
                File backFile = File(_backViewPicture!.path);

                final result = await userLincenseVM.updateDriverLicense(
                  typeOfDriverLicense: _slectedTypeDriver!,
                  classLicense: _classController.text,
                  licenseNumber: _licenseNumberController.text,
                  frontImage: frontFile,
                  backImage: backFile,
                );
                if (result) {
                  await showDialog(
                    context: context,
                    builder: (context) => CustomAlertDialog(
                      title: 'Error',
                      content: "Driver's license update successful",
                      buttonText: 'OK',
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileScreen()),
                        );
                      },
                    ),

                  );
                } else {
                  await showDialog(
                    context: context,
                    builder: (context) => CustomAlertDialog(
                      title: 'Error',
                      content: "Driver's license update faile",
                      buttonText: 'OK',
                    ),

                  );
                }
              }        
            } else {
              showDialog(
                context: context,
                builder:
                    (context) => CustomAlertDialog(
                      title: 'Error',
                      content: 'Please select both front and back images.',
                      buttonText: 'OK',
                    ),
              );
            }
          },
        ),
      ),
    );
  }
}
