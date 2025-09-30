import 'package:flutter/material.dart';
import 'package:frontend/models/vehicles/brand.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';
import 'package:frontend/viewmodels/booking/booking_viewmodel.dart';
import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
import 'package:frontend/views/booking/receipt_screen.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_text_body_l.dart';
import 'package:frontend/views/widgets/custom_text_body_m_sb.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget{
  const HistoryScreen ({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreen();
}
class _HistoryScreen extends State<HistoryScreen>{

  final List<String> _listButton = ['Pending','Complete','Cancel'];
  int _selectedIndex = 0;
  late PageController _pageController;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookingVM = Provider.of<BookingViewModel>(context, listen: false);
      final vehicleVM = Provider.of<VehicleViewModel>(context, listen: false);
      final authService = AuthService(context);
      bookingVM.fetchUserBookings(context, authService, vehicleVM: vehicleVM);
      bookingVM.filterBookingsByStatus(_listButton[_selectedIndex]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingVM = Provider.of<BookingViewModel>(context);
    final vehicleVM = Provider.of<VehicleViewModel>(context, listen: false);
    final authService = AuthService(context);
    return Scaffold(
      appBar: CustomAppbar(
        leading: Container(),
        title: 'History',
        backgroundColor: Color(0xff1976D2),
        textColor: Colors.white,
        height: 80,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: double.infinity,
        width: double.infinity,
        color: Color(0xffFDFDFD),
        child: RefreshIndicator(
          onRefresh: () async {
            final bookingVM = context.read<BookingViewModel>();
            bookingVM.fetchUserBookings(context, authService, vehicleVM: vehicleVM);
          },
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                children: [
                  ...List.generate(_listButton.length, (index) {
                    final isSelected = _selectedIndex == index;
                    return Expanded(
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              _selectedIndex = index;
                            });
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            margin: EdgeInsets.only(right: index != _listButton.length - 1 ? 10 : 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                width: 0.8,
                                color: isSelected
                                  ? const Color(0xFFD1E4F6)
                                  : const Color(0xFF145EA8),
                              ),
                              color: isSelected
                                ? const Color(0xFFD1E4F6)
                                : null
                            ),
                            child: CustomTextBodyMsb(
                              title: _listButton[index], 
                              color: isSelected
                                ? Color(0xFF1976D2)
                                : Color(0xFF145EA8),
                            )
                          ),
                        )
                      );
                    },
                  )
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _listButton.length,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                    bookingVM.filterBookingsByStatus(_listButton[index]);
                  },
                  itemBuilder:(context, index) {
                  return bookingVM.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : bookingVM.errorMessage != null
                      ? Center(child: Text(bookingVM.errorMessage!))
                      : bookingVM.bookings.isEmpty
                        ? Center(child: Text('No bookings found 😢'))
                        :ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: bookingVM.filteredBookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookingVM.filteredBookings[index];
                        final brands = Provider.of<VehicleViewModel>(context).brands;
                        final Brand brand = brands.firstWhere(
                          (b) => b.brandId == booking.vehicle!.brandId,
                          orElse: () => Brand(id: '', brandId: '', brandName: 'unknown', brandImage: null),
                        );
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ReceiptScreen(vehicle: booking.vehicle!))
                            );
                          },
                          child: ListTile(
                            leading: Container(
                              width: 94,
                              height: 78,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Color(0xffE6E7E9))
                              ),
                              child: Image.network(
                                booking.vehicle != null && booking.vehicle!.images.isNotEmpty
                                      ? booking.vehicle!.images[0]
                                      : 'https://www.kia.com/content/dam/kwcms/gt/en/images/discover-kia/voice-search/parts-80-1.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: CustomTextBodyL(title: booking.vehicle!.vehicleName,),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: Image.network(
                                        '${brand.brandImage}',
                                        
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      brand.brandName,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.33,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${bookingVM.formattedPrice(booking.totalPrice)} / ${booking.totalRentalDays} day"
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}