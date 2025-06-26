import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/user/personal_information_viewmodel.dart';
import 'package:frontend/viewmodels/user/user_provider_viewmodel.dart';
import 'package:frontend/views/address/address_screen.dart';
import 'package:frontend/views/widgets/custom_alert_dialog.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_dropdown_formfield.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';
import 'package:frontend/views/widgets/custom_text_body_M_sb.dart';
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
  final _formKey = GlobalKey<FormState>();
  String? _slectedTypeDriver;
  final List<String> _typeDriver = ['chuabiet'];

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
    _nameController.text = user?.fullName.isNotEmpty == true ? user!.fullName : 'Bro';
  }

  @override
  Widget build(BuildContext context) {
    final personalInfoVM = Provider.of<PersonalInfoViewModel>(
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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical:  12),
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
                            child: _buildImagePicker(
                              context,
                              'Front view picture',
                              'Take a photo',
                              isFront: true,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: _buildImagePicker(
                              context,
                              'Back view picture',
                              'Take a photo',
                              isFront: false,
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
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              if (personalInfoVM.frontImage == null ||
                  personalInfoVM.backImage == null) {
                showDialog(
                  context: context,
                  builder:
                      (context) => CustomAlertDialog(
                        title: 'Error',
                        content: 'Please select both front and back images.',
                        buttonText: 'OK',
                      ),
                );
                return;
              }
              personalInfoVM.setInformation(
                name: _nameController.text,
                typeDriverLicense: _slectedTypeDriver,
                className: _classController.text,
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddressScreen()),
              );
            } else {
              showDialog(
                context: context,
                builder:
                    (context) => CustomAlertDialog(
                      title: 'Error',
                      content: 'Please try again.',
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

Widget _buildImagePicker(
  BuildContext context,
  String title,
  String hintText, {
  required bool isFront,
}) {
  final personalInfoVM = Provider.of<PersonalInfoViewModel>(
    context,
    listen: false,
  );
  final image = isFront ? personalInfoVM.frontImage : personalInfoVM.backImage;

  return InkWell(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xfffd9d9d9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: image == null
      ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTextBodyMsb(title: title),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                color: const Color(0xFF555658),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Take a photo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF555658),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1.29,
                ),
              ),
            ],
          ),
        ],
      )
      : Image.file(File(image.path), height: 80, fit: BoxFit.cover),
    ),
    onTap:
        () =>
            isFront
                ? personalInfoVM.pickFrontImage()
                : personalInfoVM.pickBackImage(),
  );
}
