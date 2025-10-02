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

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreen();
}

class _HistoryScreen extends State<HistoryScreen> {
  final List<String> _listButton = ['Pending', 'Complete', 'Cancel'];
  int _selectedIndex = 0;
  late PageController _pageController;
  late ScrollController _scrollController;

  int _currentPage = 1;
  final int _limit = 10;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookingVM = Provider.of<BookingViewModel>(context, listen: false);
      final vehicleVM = Provider.of<VehicleViewModel>(context, listen: false);
      final authService = AuthService(context);
      _fetchBookings(bookingVM, vehicleVM, authService, reset: true);
    });
  }

  void _onScroll() {
    final bookingVM = Provider.of<BookingViewModel>(context, listen: false);
    final vehicleVM = Provider.of<VehicleViewModel>(context, listen: false);
    final authService = AuthService(context);

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetchingMore &&
        !bookingVM.isLoading &&
        bookingVM.hasMore) {
      _isFetchingMore = true;
      _fetchBookings(bookingVM, vehicleVM, authService, reset: false)
          .then((_) => _isFetchingMore = false);
    }
  }

  Future<void> _fetchBookings(
    BookingViewModel bookingVM,
    VehicleViewModel vehicleVM,
    AuthService authService, {
    bool reset = false,
  }) async {
    if (reset) {
      _currentPage = 1;
      bookingVM.resetPagination();
    }

    await bookingVM.fetchUserBookings(
      context,
      authService,
      vehicleVM: vehicleVM,
      status: _listButton[_selectedIndex].toLowerCase(),
      page: _currentPage,
      limit: _limit,
      append: !reset,
    );

    _currentPage++;
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
      _currentPage = 1;
      _isFetchingMore = false;
    });

    final bookingVM = Provider.of<BookingViewModel>(context, listen: false);
    final vehicleVM = Provider.of<VehicleViewModel>(context, listen: false);
    final authService = AuthService(context);

    _fetchBookings(bookingVM, vehicleVM, authService, reset: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
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
            await _fetchBookings(bookingVM, vehicleVM, authService, reset: true);
          },
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                children: List.generate(_listButton.length, (index) {
                  final isSelected = _selectedIndex == index;
                  return Expanded(
                    child: InkWell(
                      onTap: () => _onTabChanged(index),
                      child: Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        margin: EdgeInsets.only(
                            right: index != _listButton.length - 1 ? 10 : 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            width: 0.8,
                            color: isSelected
                                ? const Color(0xFFD1E4F6)
                                : const Color(0xFF145EA8),
                          ),
                          color: isSelected ? const Color(0xFFD1E4F6) : null,
                        ),
                        child: CustomTextBodyMsb(
                          title: _listButton[index],
                          color: isSelected
                              ? Color(0xFF1976D2)
                              : Color(0xFF145EA8),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _listButton.length,
                  onPageChanged: (index) => _onTabChanged(index),
                  itemBuilder: (context, index) {
                    if (bookingVM.isLoading && bookingVM.bookings.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (bookingVM.errorMessage != null) {
                      return Center(child: Text(bookingVM.errorMessage!));
                    } else if (bookingVM.filteredBookings.isEmpty) {
                      return const Center(child: Text('No bookings found 😢'));
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: bookingVM.filteredBookings.length +
                          (_isFetchingMore ? 1 : 0),
                      itemBuilder: (context, bookingIndex) {
                        if (bookingIndex == bookingVM.filteredBookings.length) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final booking = bookingVM.filteredBookings[bookingIndex];
                        final vehicle = booking.vehicle;
                        final brands =
                            Provider.of<VehicleViewModel>(context).brands;

                        final Brand brand = vehicle != null
                            ? brands.firstWhere(
                                (b) => b.brandId == vehicle.brandId,
                                orElse: () => Brand(
                                  id: '',
                                  brandId: '',
                                  brandName: 'unknown',
                                  brandImage: null,
                                ),
                              )
                            : Brand(
                                id: '',
                                brandId: '',
                                brandName: 'unknown',
                                brandImage: null,
                              );

                        return GestureDetector(
                          onTap: () {
                            if (vehicle != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReceiptScreen(vehicle: vehicle),
                                ),
                              );
                            }
                          },
                          child: ListTile(
                            leading: Container(
                              width: 94,
                              height: 78,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Color(0xffE6E7E9)),
                              ),
                              child: Image.network(
                                vehicle != null && vehicle.images.isNotEmpty
                                    ? vehicle.images[0]
                                    : 'https://www.kia.com/content/dam/kwcms/gt/en/images/discover-kia/voice-search/parts-80-1.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: CustomTextBodyL(
                              title: vehicle?.vehicleName ?? 'Unknown',
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    if (brand.brandImage != null)
                                      SizedBox(
                                        width: 28,
                                        height: 28,
                                        child:
                                            Image.network(brand.brandImage!),
                                      ),
                                    const SizedBox(width: 4),
                                    Text(
                                      brand.brandName,
                                      style: const TextStyle(
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
                                  "${bookingVM.formattedPrice(booking.totalPrice)} / ${booking.totalRentalDays} day",
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
