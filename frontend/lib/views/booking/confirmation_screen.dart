import 'package:flutter/material.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/views/booking/receipt_screen.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';

class Confirmationscreen extends StatelessWidget {
  final Vehicle vehicle;
  const Confirmationscreen ({super.key, required this.vehicle});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xffFCFCFC),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/booking/confirmation.png',
              width: 180,
              height: 190,
            ),
            const SizedBox(height: 16),
            Text(
              'Congratulations!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF1976D2),
                fontSize: 34,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                height: 1.12,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Your payment has been received and currently undergoing processing.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF555658),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Thank you!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF555658),
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                height: 1.22,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: CustomButton(
          title: 'Download',
          width: double.infinity,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReceiptScreen(vehicle: vehicle)),
            );
          },
        ),
      ),
    );
  }
}
