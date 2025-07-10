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

  late List<Widget> _screens;
  final GlobalKey<ListVehicleState> reviewScreenKey = GlobalKey<ListVehicleState>();

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
      ListVehicle(key: reviewScreenKey,),
      ListVehicle(),
      ListVehicle(),
      ListVehicle(),
      ListVehicle(),
    ];
  }

  void _showSelectVehicleTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Select Vehicle Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3,
              children: navItems
                  .where((item) => item['label'] != 'All')
                  .map(
                    (item) => ListTile(
                      leading: item['icon'] != null
                          ? SizedBox(
                            width: 27,
                            height: 27,
                            child: SvgPicture.asset(
                                item['icon']!,
                                colorFilter: ColorFilter.mode(
                                  Color(0xff145EA8),
                                  BlendMode.srcIn,
                                ),
                              ),
                          )
                          : null,
                      title: Text(item['label']!),
                      onTap: () {
                        setState(() {
                          _selectedVehicleType = item['label']!.toLowerCase();
                        });
                        Navigator.pop(context);
                        _navigateToRentalInfo();
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
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
        child: RefreshIndicator(
          onRefresh: () async{
            await reviewScreenKey.currentState?.fetchData();
          },
          child: SingleChildScrollView(
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
                        child: 
                        
                        ListView.builder(
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
                Padding(
                  padding:EdgeInsets.symmetric(horizontal: 16),
                  child: IndexedStack(index: _selectedIndex, children: _screens),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
      margin: EdgeInsets.all(16),
      child: CustomButton(
        title: 'Register New Vehicle',
        width: double.infinity,
        onPressed: () {
          _showSelectVehicleTypeDialog();
        },
      ),
    ),
    );
  }
}
