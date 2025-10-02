import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';
import 'package:frontend/viewmodels/user/personal_information_viewmodel.dart';
import 'package:frontend/viewmodels/user/user_provider_viewmodel.dart';
import 'package:frontend/views/widgets/custom_alert_dialog.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_dropdown_formfield.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';
import 'package:frontend/views/widgets/custom_text_body_m_sb.dart';
import 'package:provider/provider.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreen();
}

class _PersonalInfoScreen extends State<PersonalInfoScreen> {
  late TextEditingController _nameController;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  final List<String> _genderItems = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final personalInfoVM = Provider.of<PersonalInfoViewModel>(
        context,
        listen: false,
      );
      final authService = Provider.of<AuthService>(context, listen: false);

      await personalInfoVM.loadFromStorage();

      if (personalInfoVM.name == null ||
          personalInfoVM.dateOfBirth == null ||
          personalInfoVM.phoneNumber == null) {
        await personalInfoVM.loadFromBackend(authService);
      }

      if (!mounted) return;

      setState(() {
        _nameController.text = personalInfoVM.name ?? '';
        _dateController.text = personalInfoVM.dateOfBirth ?? '';
        _phoneController.text = personalInfoVM.phoneNumber ?? '';
        _idsController.text = personalInfoVM.nationalIdNumber?.join(', ') ?? '';
        _selectedGender = personalInfoVM.gender;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userVM = Provider.of<UserViewModel>(context);
    final user = userVM.user;
    if (_nameController.text.isEmpty && user != null) {
      _nameController.text = user.fullName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final personalInfoVM = Provider.of<PersonalInfoViewModel>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: CustomAppbar(
        backgroundColor: const Color(0xff1976D2),
        title: 'Personal Information',
        textColor: Colors.white,
        height: 80,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter your name'
                              : null,
                ),
                const SizedBox(height: 24),
                CustomTextBodyMsb(title: 'Date of Birth'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _dateController,
                  keyboardType: TextInputType.datetime,
                  hintText: 'Exp: 01/01/2000',
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter your date of birth';
                    if (!isValidDate(value)) return 'Format: dd/MM/yyyy';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomTextBodyMsb(title: 'Phone Number'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  hintText: 'Enter your phone number',
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter your phone number';
                    if (!isValidPhone(value))
                      return 'Phone must be 10-11 digits';
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
                          CustomTextBodyMsb(title: 'Gender'),
                          const SizedBox(height: 8),
                          CustomDropdownButtonFormField(
                            value: _selectedGender,
                            onChanged:
                                (value) =>
                                    setState(() => _selectedGender = value),
                            items: _genderItems,
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? 'Please select'
                                        : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextBodyMsb(title: 'IDs'),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: _idsController,
                            hintText: 'Enter your IDs (comma separated)',
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? 'Please enter your IDs'
                                        : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: CustomButton(
          title: 'Save',
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              await personalInfoVM.setInformation(
                name: _nameController.text,
                dateOfBirth: _dateController.text,
                phoneNumber: _phoneController.text,
                gender: _selectedGender,
                nationalIdNumber:
                    _idsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList(),
              );

              final response = await personalInfoVM.updateToServer(authService);

              showDialog(
                context: context,
                builder:
                    (context) => CustomAlertDialog(
                      title: response.success ? 'Success' : 'Error',
                      content: response.message ?? '',
                      buttonText: 'OK',
                      onPressed: () => Navigator.pop(context),
                    ),
              );
            }
          },
        ),
      ),
    );
  }
}
