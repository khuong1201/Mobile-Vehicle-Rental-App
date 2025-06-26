import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/views/widgets/custom_dropdown_formfield.dart';
import 'package:frontend/views/widgets/custom_text_body_L.dart';
import 'package:frontend/views/widgets/custom_text_body_S_sb.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';

class RentalPriceScreen extends StatefulWidget {
  final String? vehicleType;
  final Function(Map<String, dynamic>) onDataChanged;
  const RentalPriceScreen({super.key, this.vehicleType, required this.onDataChanged});

  @override
  State<RentalPriceScreen> createState() => _RentalPriceScreenState();
}

class _RentalPriceScreenState extends State<RentalPriceScreen> {

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();

  String? _nameBank;
  void _saveData() {
    final data = {
      'price': double.tryParse(_priceController.text.trim()),
      
      'type': widget.vehicleType,
    };
    debugPrint('vehicle type ${widget.vehicleType}');
    widget.onDataChanged(data); 
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/images/hosting/information/Group.svg'),
              const SizedBox(width: 4),
              CustomTextBodyL(title: 'Price Rental'),
            ],
          ),
          const SizedBox(height: 8),
          CustomTextBodySsb(title: 'price'),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _priceController,
            hintText: 'VND',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter rate';
              }
              return null;
            },
            onChanged: (_) => _saveData(),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border(
                top:BorderSide(
                  color: Color(0xFFD5D7DB),
                  width: 1
                )
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/images/hosting/information/ion_card-outline.svg'),
                    const SizedBox(width: 4),
                    CustomTextBodyL(title: 'Card Information'),
                  ],
                ),
                const SizedBox(height: 8),
                CustomTextBodySsb(title: 'Bank'),
                const SizedBox(height: 8),
                CustomDropdownButtonFormField(
                  value: _nameBank,
                  onChanged: (value) {
                    setState(() {
                      _nameBank == value;
                      _saveData();
                    });
                  },
                  hintText: 'Your Bank',
                  items: ['Mb bank','viettinbank'],
                ),
                const SizedBox(height: 16),
                CustomTextBodySsb(title: 'Account Number'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _accountNumberController,
                  hintText: 'Your Bank Account Number',
                  
                ),
                const SizedBox(height: 16),
                CustomTextBodySsb(title: 'Name'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _accountNameController,
                  hintText: 'Account Holder Name',           
                ),
              ],
            )
          )
        ],
      ),
    );
  }
}