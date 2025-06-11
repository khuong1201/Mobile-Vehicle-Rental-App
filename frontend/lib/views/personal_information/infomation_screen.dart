import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/personal_information_viewmodel.dart';
import 'package:frontend/views/personal_information/driver_license_screen.dart';
import 'package:frontend/views/widgets/custom_alert_dialog.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_dropdown_formfield.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';
import 'package:frontend/views/widgets/custom_title_textfield.dart';
import 'package:provider/provider.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreen();
}

class _PersonalInfoScreen extends State<PersonalInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ids = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  final List<String> _genderItems = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
  final personalInfoVM = Provider.of<PersonalInfoViewModel>(context, listen: false);

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF1976D2),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: CustomAppbar(title: 'Personal Information', textColor: Color(0xffFFFFFF),),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTitleTextField(title: 'Name'),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: _nameController,
                          hintText: 'Enter your name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        CustomTitleTextField(title: 'Date of Birth'),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: _dateController,
                          hintText: 'Exp: 01/ 01/ 2000',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your date of birth';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        CustomTitleTextField(title: 'Phone Number'),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: _phoneController,
                          hintText: 'Enter your phone number',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTitleTextField(title: 'Gender'),
                                  const SizedBox(height: 8),
                                  CustomDropdownButtonFormField(
                                    value: _selectedGender,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedGender = value;
                                      });
                                    },
                                    items: _genderItems,
                                    validator: (value) => value == null || value.isEmpty ? 'Please select' : null,
                                  )
                                ],
                              )
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTitleTextField(title: 'IDs'),
                                  const SizedBox(height: 8),
                                  CustomTextField(
                                    controller: _ids,
                                    hintText: 'Enter your IDs',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your IDs';
                                      }
                                      return null;
                                    },
                                  )
                                ],
                              )
                            )
                          ],
                        )
                      ],
                    )
                  )
                ),
              ],
            ),
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

              personalInfoVM.setInformation(
                name: _nameController.text,
                dateOfBirth: _dateController.text,
                phoneNumber: _phoneController.text,
                gender: _selectedGender,
                ids: _ids.text,
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DriverLicenseScreen(name: personalInfoVM.name,)),
              );
            } else {
              showDialog(
                context: context,
                builder: (context) => CustomAlertDialog(
                  title: 'Error',
                  content: 'Registration failed. Please try again.',
                  buttonText: 'OK',
                ),
              );
            }
          },
        )
      )
    );
  }
}
