import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/views/booking/booking_screen.dart';
import 'package:frontend/views/vehicle_detail/about_screen.dart';
import 'package:frontend/views/vehicle_detail/gallery_screen.dart';
import 'package:frontend/views/vehicle_detail/review_screen.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_text_body_L.dart';

class VehicleDetailScreen extends StatefulWidget {
  final Vehicle vehicle;
  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  _VehicleDetailScreenState createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  final List<Map<String, String>> _navItems = [
    {'label': 'About'},
    {'label': 'Gallery'},
    {'label': 'Review'},
  ];

  @override
  void initState() {
    super.initState();
    _screens = [AboutScreen(), GalleryScreen(vehicle: widget.vehicle), ReviewScreen()];
  }

  @override
  Widget build(BuildContext context) {
    final int itemCount = _navItems.length;
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppbar(title: 'Details'),
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
                                title:
                                    '${widget.vehicle.brand.brandName} ${widget.vehicle.vehicleName}',
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
                                  '${widget.vehicle.brand.brandImage}',
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.vehicle.brand.brandName,
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
                            children: [
                              _buildContainer(
                                'Transmission',
                                'Automatic',
                                'assets/images/vehicle_detail/Vector (8).svg',
                              ),
                    
                              _buildContainer(
                                'Seats',
                                '4 seats',
                                'assets/images/vehicle_detail/Vector (9).svg',
                              ),
                    
                              _buildContainer(
                                'Fuel',
                                'Petrol',
                                'assets/images/vehicle_detail/Vector (10).svg',
                              ),
                    
                              _buildContainer(
                                'Model',
                                '${widget.vehicle.yearOfManufacture.toString}',
                                'assets/images/vehicle_detail/Vector (11).svg',
                              ),
                            ],
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
                                          color:
                                              selected
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
                                        color:
                                            selected
                                                ? const Color(0xff1976D2)
                                                : const Color(0xff212121),
                                        fontWeight:
                                            selected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
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
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border:Border(
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
