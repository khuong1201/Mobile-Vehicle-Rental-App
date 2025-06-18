import 'package:flutter/material.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';

class AddressScreen extends StatefulWidget {
  final String? name;

  const AddressScreen({super.key, this.name});

  @override
  State<AddressScreen> createState() => _AddressScreen();
}

class _AddressScreen extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                decoration: BoxDecoration(color: Color(0xFF1976D2)),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: CustomAppbar(
                    title: 'Address',
                    textColor: Color(0xffFFFFFF),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                
              )
            ],
          ),
        ),
      ),
    );
  }
}