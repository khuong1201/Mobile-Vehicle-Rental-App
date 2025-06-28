import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/models/bank.dart';
import 'package:frontend/views/widgets/custom_dropdown_formfield.dart';
import 'package:frontend/views/widgets/custom_text_body_L.dart';
import 'package:frontend/views/widgets/custom_text_body_S_sb.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';

class RentalPriceScreen extends StatefulWidget {
  final String? vehicleType;
  final Function(Map<String, dynamic>) onDataChanged;
  final GlobalKey<FormState> formKey;

  const RentalPriceScreen({
    super.key,
    this.vehicleType,
    required this.onDataChanged,
    required this.formKey,
  });

  @override
  State<RentalPriceScreen> createState() => _RentalPriceScreenState();
}

class _RentalPriceScreenState extends State<RentalPriceScreen> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _accountHolderNameController = TextEditingController();

  String? _nameBank;

  void _saveData() {
  final price = double.tryParse(_priceController.text.trim()) ?? 0.0;

  final bankAccount = BankAccount(
    accountNumber: _accountNumberController.text.trim(),
    bankName: _nameBank ?? 'unknown',
    accountHolderName: _accountHolderNameController.text.trim(),
  );

  final data = {
    'price': price,
    'bankAccount': bankAccount.toJson(), 
    'vehicleType': widget.vehicleType,
  };

  widget.onDataChanged(data);
}


  @override
  void dispose() {
    _priceController.dispose();
    _accountNumberController.dispose();
    _accountHolderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/images/hosting/information/Group.svg'),
                const SizedBox(width: 4),
                const CustomTextBodyL(title: 'Rental Price'),
              ],
            ),
            const SizedBox(height: 8),
            const CustomTextBodySsb(title: 'Price'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _priceController,
              hintText: 'VND',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter rental price';
                }
                final price = double.tryParse(value);
                if (price == null || price <= 0) {
                  return 'Price must be a positive number';
                }
                return null;
              },
              onChanged: (_) => _saveData(),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFD5D7DB),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                          'assets/images/hosting/information/ion_card-outline.svg'),
                      const SizedBox(width: 4),
                      const CustomTextBodyL(title: 'Card Information'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const CustomTextBodySsb(title: 'Bank'),
                  const SizedBox(height: 8),
                  CustomDropdownButtonFormField(
                    value: _nameBank,
                    onChanged: (value) {
                      setState(() {
                        _nameBank = value;
                        _saveData();
                      });
                    },
                    hintText: 'Select your bank',
                    items: const ['MB Bank', 'VietinBank'],
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a bank';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const CustomTextBodySsb(title: 'Account Number'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _accountNumberController,
                    hintText: 'Bank account number',
                    keyboardType: const TextInputType.numberWithOptions(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter bank account number';
                      }
                      if (!RegExp(r'^\d+$').hasMatch(value)) {
                        return 'Account number must contain only digits';
                      }
                      if (value.length < 8) {
                        return 'Account number must be at least 8 digits';
                      }
                      return null;
                    },
                    onChanged: (_) => _saveData(),
                  ),
                  const SizedBox(height: 16),
                  const CustomTextBodySsb(title: 'Account Name'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _accountHolderNameController,
                    hintText: 'Account holder name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter account holder name';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                    onChanged: (_) => _saveData(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}