import 'package:flutter/material.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_text_body_m_sb.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';

class AddressDetailScreen extends StatefulWidget {
  const AddressDetailScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddressDetailScreen();
}

class _AddressDetailScreen extends State<AddressDetailScreen> {
  final TextEditingController _address = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        backgroundColor: Color(0xff1976D2),
        title: 'Address',
        textColor: Color(0xffFFFFFF),
        height: 80,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color(0xffFCFCFC),
        padding: EdgeInsetsDirectional.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextBodyMsb(title: 'Name *'),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _address,
              ),
              const SizedBox(height: 20),
              CustomTextBodyMsb(title: 'Address *'),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _address,
              ),
              const SizedBox(height: 20),
              CustomTextBodyMsb(title: 'Floor / Apartment number'),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _address,
              ),
              const SizedBox(height: 20),
              CustomTextBodyMsb(title: 'Contact Name'),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _address,
              ),
              const SizedBox(height: 20),
              CustomTextBodyMsb(title: 'Phone Number'),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _address,
              )

            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin:EdgeInsets.all(16),
        child: CustomButton(
          title: 'Save',
          width: double.infinity
        )
      )
    );
  }
}
