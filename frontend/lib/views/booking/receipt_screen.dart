import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/models/vehicles/brand.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/viewmodels/booking/booking_viewmodel.dart';
import 'package:frontend/viewmodels/user/user_provider_viewmodel.dart';
import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_text_body_L.dart';
import 'package:frontend/views/widgets/custom_text_body_S_sb.dart';
import 'package:provider/provider.dart';

class ReceiptScreen extends StatelessWidget {
  final Vehicle vehicle;
  const ReceiptScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final bookingVM = Provider.of<BookingViewModel>(context);
    final userVM = Provider.of<UserViewModel>(context);
    final user = userVM.user;
    final brands = Provider.of<VehicleViewModel>(context).brands;
    final Brand brand = brands.firstWhere(
      (b) => b.id == vehicle.brand,
      orElse: () => Brand(id: '', brandId: '', brandName: 'unknown', brandImage: null),
    );
    return Scaffold(
      appBar: CustomAppbar(title: 'E - Receipt'),
      body: Container(
        color: const Color(0xffFCFCFC),
        child: Container(
          color: Color(0xffEEEFF1),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize:MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  alignment:Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/booking/Vector (1).svg'),
                      const SizedBox(width: 8,),
                      SvgPicture.asset('assets/images/booking/Vector (1).svg'),
                      const SizedBox(width: 8,),
                      SvgPicture.asset('assets/images/booking/Vector (1).svg'),
                      const SizedBox(width: 8,),
                      SvgPicture.asset('assets/images/booking/Vector (1).svg'),
                      const SizedBox(width: 8,),
                      SvgPicture.asset('assets/images/booking/Vector (1).svg'),
                      const SizedBox(width: 8,),
                      SvgPicture.asset('assets/images/booking/Vector (1).svg'),
                    ],
                  )
                ),
                const SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xffD5D7DB)),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        'Name',
                        user?.fullName.isNotEmpty == true
                            ? user!.fullName
                            : 'Bro',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        'Car',
                        '${brand.brandName} ${vehicle.vehicleName}',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('Seats', '07'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xffD5D7DB)),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Pick - Up Date', bookingVM.pickUpDate),
                      const SizedBox(height: 16),
                      _buildInfoRow('Pick - Up Time', bookingVM.pickUpTime),
                      const SizedBox(height: 16),
                      _buildInfoRow('Drop - Off Date', bookingVM.dropOffDate),
                      const SizedBox(height: 16),
                      _buildInfoRow('Drop - Off Time', bookingVM.dropOffTime),
                      const SizedBox(height: 16),
                      _buildInfoRow('Rent Type', 'Self Driver'),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        'Total Rental Days',
                        '',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xffD5D7DB)),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Additional Drive', '0 VNĐ'),
                      const SizedBox(height: 16),
                      _buildInfoRow('Subtotal', ''),
                      const SizedBox(height: 16),
                      _buildInfoRow('Tax', '0 VNĐ'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextBodyL(title: 'Total Rental Price'),
                    Text(
                      '',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFF1976D2),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.25,
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
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(title: 'Download', width: double.infinity,),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                border:Border.all(width: 2, color: Color(0xff1976D2)),
                borderRadius:BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: (){
                  Navigator.popUntil(context, ModalRoute.withName('/home'));
                },
                child: Text(
                  'Go to Home',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xff1976D2),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildInfoRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CustomTextBodySsb(title: label),
      Text(
        value,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: const Color(0xFF212121),
          fontSize: 18,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          height: 1.22,
        ),
      ),
    ],
  );
}
