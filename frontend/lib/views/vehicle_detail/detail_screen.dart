import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/models/vehicles/brand.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/models/vehicles/car.dart';
import 'package:frontend/models/vehicles/motorbike.dart';
import 'package:frontend/models/vehicles/coach.dart';
import 'package:frontend/models/vehicles/bike.dart';
import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
import 'package:frontend/views/booking/booking_screen.dart';
import 'package:frontend/views/vehicle_detail/about_screen.dart';
import 'package:frontend/views/vehicle_detail/gallery_screen.dart';
import 'package:frontend/views/vehicle_detail/review_screen.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_text_body_l.dart';
import 'package:provider/provider.dart';

class VehicleDetailScreen extends StatefulWidget {
  final Vehicle vehicle;
  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  _VehicleDetailScreenState createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  final GlobalKey<ReviewScreenState> reviewScreenKey = GlobalKey<ReviewScreenState>();

  final List<Map<String, String>> _navItems = [
    {'label': 'About'},
    {'label': 'Gallery'},
    {'label': 'Review'},
  ];

  @override
  void initState() {
    super.initState();
    _screens = [
      AboutScreen(vehicle: widget.vehicle),
      GalleryScreen(vehicle: widget.vehicle),
      ReviewScreen(key: reviewScreenKey, vehicle: widget.vehicle),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final int itemCount = _navItems.length;
    final brands = Provider.of<VehicleViewModel>(context).brands;
    final Brand brand = brands.firstWhere(
      (b) => b.id == widget.vehicle.brand,
      orElse: () => Brand(id: '', brandId: '', brandName: 'unknown', brandImage: null),
    );
    return Scaffold(
      appBar: CustomAppbar(title: 'Detail'),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color(0xffFCFCFC),
        child: RefreshIndicator(
          onRefresh: () async {
            if (_selectedIndex == 2) {
              await reviewScreenKey.currentState?.fetchData();
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 28),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Container(
                        height: 213,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.vehicle.images.isNotEmpty
                                  ? widget.vehicle.images[0]
                                  : 'https://www.kia.com/content/dam/kwcms/gt/en/images/discover-kia/voice-search/parts-80-1.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CustomTextBodyL(
                                  title: '${brand.brandName} ${widget.vehicle.vehicleName}',
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Text(
                                      widget.vehicle.rate.toString(),
                                      style: TextStyle(
                                        color: const Color(0xFF2B2B2C),
                                        fontSize: 10,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        height: 1.20,
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: SvgPicture.asset(
                                        'assets/images/homePage/home/star.svg',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: SvgPicture.network(
                                    '${brand.brandImage}',
                                    placeholderBuilder: (context) => Icon(Icons.error),
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
                            const SizedBox(height: 28),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: _buildInfoContainers(),
                            ),
                            const SizedBox(height: 28),
                            Row(
                              children: List.generate(itemCount, (index) {
                                final selected = _selectedIndex == index;
                                final item = _navItems[index];
                                return Expanded(
                                  child: InkWell(
                                    onTap: () => setState(() => _selectedIndex = index),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: selected
                                                ? const Color(0xFF1976D2)
                                                : const Color(0xFFD5D7DB),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        item['label']!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: selected
                                              ? const Color(0xff1976D2)
                                              : const Color(0xff212121),
                                          fontWeight:
                                              selected ? FontWeight.bold : FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 28),
                            Container(
                              child: IndexedStack(
                                index: _selectedIndex,
                                children: _screens,
                              ),
                            ),
                            const SizedBox(height: 28),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: const Color(0xFFD5D7DB),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: TextStyle(
                    color: const Color(0xFF808183),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      widget.vehicle.formattedPrice.toString(),
                      style: TextStyle(
                        color: const Color(0xFF000000),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '/ day',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF808183),
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            CustomButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingScreen(vehicle: widget.vehicle),
                  ),
                );
              },
              title: 'Rent Now',
              width: 150,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInfoContainers() {
    final vehicle = widget.vehicle;
    List<Map<String, dynamic>> infoItems = [];

    if (vehicle is Car) {
      infoItems = [
        {
          'title': 'Transmission',
          'subtitle': vehicle.transmission, 
          'icon': 'assets/images/vehicle_detail/Vector (8).svg',
        },
        {
          'title': 'Seats',
          'subtitle': '${vehicle.numberOfSeats} seats',
          'icon': 'assets/images/vehicle_detail/Vector (9).svg',
        },
        {
          'title': 'Fuel',
          'subtitle': vehicle.fuelType,
          'icon': 'assets/images/vehicle_detail/Vector (10).svg',
        },
        {
          'title': 'Model',
          'subtitle': vehicle.yearOfManufacture,
          'icon': 'assets/images/vehicle_detail/Vector (11).svg',
        },
      ];
    } else if (vehicle is Motor) {
      infoItems = [
        {
          'title': 'Transmission',
          'subtitle': 'Manual', 
          'icon': 'assets/images/vehicle_detail/Vector (8).svg',
        },
        {
          'title': 'Seats',
          'subtitle': '2 seats', 
          'icon': 'assets/images/vehicle_detail/Vector (9).svg',
        },
        {
          'title': 'Fuel',
          'subtitle': vehicle.fuelType,
          'icon': 'assets/images/vehicle_detail/Vector (10).svg',
        },
        {
          'title': 'Model',
          'subtitle': vehicle.yearOfManufacture,
          'icon': 'assets/images/vehicle_detail/Vector (11).svg',
        },
      ];
    } else if (vehicle is Coach) {
      infoItems = [
        {
          'title': 'Transmission',
          'subtitle': vehicle.transmission, 
          'icon': 'assets/images/vehicle_detail/Vector (8).svg',
        },
        {
          'title': 'Seats',
          'subtitle': '${vehicle.numberOfSeats} seats',
          'icon': 'assets/images/vehicle_detail/Vector (9).svg',
        },
        {
          'title': 'Fuel',
          'subtitle': vehicle.fuelType,
          'icon': 'assets/images/vehicle_detail/Vector (10).svg',
        },
        {
          'title': 'Model',
          'subtitle': vehicle.yearOfManufacture,
          'icon': 'assets/images/vehicle_detail/Vector (11).svg',
        },
      ];
    } else if (vehicle is Bike) {
      infoItems = [
        { 
          'title': 'Transmission',
          'subtitle': 'None',
          'icon': 'assets/images/vehicle_detail/Vector (8).svg',
        },
        {
          'title': 'Seats',
          'subtitle': '1 seat',
          'icon': 'assets/images/vehicle_detail/Vector (9).svg',
        },
        {
          'title': 'Fuel',
          'subtitle': 'None', 
          'icon': 'assets/images/vehicle_detail/Vector (10).svg',
        },
        {
          'title': 'Model',
          'subtitle': vehicle.yearOfManufacture,
          'icon': 'assets/images/vehicle_detail/Vector (11).svg',
        },
      ];
    } else {
      infoItems = [
        {
          'title': 'Transmission',
          'subtitle': 'Unknown',
          'icon': 'assets/images/vehicle_detail/Vector (8).svg',
        },
        {
          'title': 'Seats',
          'subtitle': 'Unknown',
          'icon': 'assets/images/vehicle_detail/Vector (9).svg',
        },
        {
          'title': 'Fuel',
          'subtitle': 'Unknown',
          'icon': 'assets/images/vehicle_detail/Vector (10).svg',
        },
        {
          'title': 'Model',
          'subtitle': vehicle.yearOfManufacture,
          'icon': 'assets/images/vehicle_detail/Vector (11).svg',
        },
      ];
    }

    return infoItems
        .map((item) => _buildContainer(
              item['title'],
              item['subtitle'],
              item['icon'],
            ))
        .toList();
  }

  Widget _buildContainer(String title, String subtitle, String svgPath) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
      width: 83,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: const Color(0xFFD5D7DB), width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 24, height: 24, child: SvgPicture.asset(svgPath)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF808183),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.33,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.29,
            ),
          ),
        ],
      ),
    );
  }
}