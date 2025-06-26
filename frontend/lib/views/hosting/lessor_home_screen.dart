import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/views/hosting/list_vehicle.dart';
import 'package:frontend/views/hosting/rentalInfomation/rental_information_screen.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';

class LessorHomeScreen extends StatefulWidget {
  const LessorHomeScreen({super.key});
  @override
  State<LessorHomeScreen> createState() => _LessorHomeScreen();
}

class _LessorHomeScreen extends State<LessorHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedIndex = 0;
  String? _selectedVehicleType;
  bool _showDropdown = false;

  late List<Widget> _screens;

  final List<Map<String, String?>> navItems = [
    {'icon': null, 'label': 'All'},
    {'icon': 'assets/images/hosting/Lessorhome/car.svg', 'label': 'Car'},
    {'icon': 'assets/images/hosting/Lessorhome/coach.svg', 'label': 'Coach'},
    {'icon': 'assets/images/hosting/Lessorhome/motor.svg', 'label': 'Motor'},
    {'icon': 'assets/images/hosting/Lessorhome/bike.svg', 'label': 'Bike'},
  ];

  @override
  void initState() {
    super.initState();
    _screens = [
      ListVehicle(),
      ListVehicle(),
      ListVehicle(),
      ListVehicle(),
      ListVehicle(),
    ];
  }

  void _toggleDropdown() {
    setState(() {
      _showDropdown = !_showDropdown;
    });
  }

  void _navigateToRentalInfo() {
    if (_selectedVehicleType != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RentalInformationScreen(vehicleType: _selectedVehicleType),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a vehicle type')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'List Your Vehicle',
        textColor: Color(0xFFFFFFFF),
        height: 80,
        backgroundColor: Color(0xFF1976D2),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color(0xffFDFDFD),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _searchController,
                          hintText: 'Search',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SvgPicture.asset(
                              'assets/images/homePage/home/search.svg',
                            ),
                          ),
                        ),
                      ),
                      //dropmenu
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: navItems.length,
                      itemBuilder: (context, index) {
                        final selected = _selectedIndex == index;
                        return InkWell(
                          onTap: () => setState(() => _selectedIndex = index),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color:
                                  selected
                                      ? Color(0xff145EA8)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                width: 1,
                                color:
                                    selected
                                        ? Color(0xff145EA8)
                                        : Color(0xffAAACAF),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (index != 0 &&
                                    navItems[index]['icon'] != null)
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: SvgPicture.asset(
                                      navItems[index]['icon']!,
                                      colorFilter: ColorFilter.mode(
                                        selected
                                            ? const Color(0xffFFFFFF)
                                            : const Color(0xff555658),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 6),
                                Text(
                                  navItems[index]['label']!,
                                  style: TextStyle(
                                    color:
                                        selected
                                            ? const Color(0xffFFFFFF)
                                            : const Color(0xff555658),
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.29,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(index: _selectedIndex, children: _screens),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
      margin: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showDropdown)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedVehicleType,
                      hint: Text('Select Vehicle Type'),
                      items: navItems
                          .where((item) => item['label'] != 'All')
                          .map((item) => DropdownMenuItem<String>(
                                value: item['label']!.toLowerCase(),
                                child: Text(item['label']!),
                              ))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedVehicleType = newValue;
                          debugPrint('Selected vehicle type: $_selectedVehicleType');
                        });
                      },
                      isExpanded: true,
                      underline: SizedBox(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: _toggleDropdown,
                  ),
                ],
              ),
            ),
          CustomButton(
            title: 'Register New Vehicle',
            width: double.infinity,
            onPressed: () {
              if (!_showDropdown) {
                _toggleDropdown(); // Hiển thị dropdown khi nhấn nút
              } else if (_selectedVehicleType != null) {
                _navigateToRentalInfo(); // Điều hướng nếu đã chọn type
              }
            },
          ),
        ],
      ),
    ),
    );
  }
}
