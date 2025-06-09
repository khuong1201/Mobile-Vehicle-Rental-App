import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/views/hosting/list_vehicle_screen.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';

class LessorHomeScreen extends StatefulWidget {
  const LessorHomeScreen({super.key});
  @override
  State<LessorHomeScreen> createState() => _LessorHomeScreen();
}

class _LessorHomeScreen extends State<LessorHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedIndex = 0;

  late List<Widget> _screens;

  final List<Map<String, String?>> navItems = [
    {'icon': null, 'label': 'All'},
    {'icon': 'assets/images/hosting/Lessor home/car.svg', 'label': 'Car'},
    {'icon': 'assets/images/hosting/Lessor home/coach.svg', 'label': 'Coach'},
    {'icon': 'assets/images/hosting/Lessor home/motor.svg', 'label': 'Motor'},
    {'icon': 'assets/images/hosting/Lessor home/bike.svg', 'label': 'Bike'},
  ];

  @override
  void initState() {
    super.initState();
    _screens = [
      ListVehicleScreen(),
      ListVehicleScreen(),
      ListVehicleScreen(),
      ListVehicleScreen(),
      ListVehicleScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color(0xffFDFDFD),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF1976D2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: CustomAppbar(title: 'List Your Vehicle'),
              ),
            ),

            const SizedBox(height: 14),
            Container(
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
                  Container(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: navItems.length,
                      itemBuilder: (context, index) {
                        final selected = _selectedIndex == index;
                        return InkWell(
                          onTap: () => setState(() => _selectedIndex = index),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: selected ? Color(0xff145EA8) : Colors.transparent,
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
                                if (index != 0 && navItems[index]['icon'] != null)
                                  Container(
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
                                const SizedBox(width: 4),
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
              child: IndexedStack(
                index: _selectedIndex,
                children: _screens,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
