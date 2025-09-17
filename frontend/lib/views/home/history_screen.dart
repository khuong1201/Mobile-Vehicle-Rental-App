import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/booking/booking_viewmodel.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget{
  const HistoryScreen ({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreen();
}
class _HistoryScreen extends State<HistoryScreen>{
  @override
  Widget build(BuildContext context) {
     final bookingVM = Provider.of<BookingViewModel>(context);
    return Scaffold(
      appBar: CustomAppbar(
        leading: Container(),
        title: 'History',
        backgroundColor: Color(0xff1976D2),
        textColor: Colors.white,
        height: 80,
      ),
      body: bookingVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookingVM.errorMessage != null
              ? Center(child: Text(bookingVM.errorMessage!))
              : ListView.builder(
                  itemCount: bookingVM.bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookingVM.bookings[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text("Xe: ${booking.vehicleId}"),
                        subtitle: Text(
                          "Từ ${booking.pickupDate} ${booking.pickupTime} "
                          "→ ${booking.dropoffDate} ${booking.dropoffTime}\n"
                          "Tổng tiền: ${booking.totalPrice} VND",
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}