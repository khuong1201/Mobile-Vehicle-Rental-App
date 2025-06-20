import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';

class RentalInformationScreen extends StatefulWidget {
  const RentalInformationScreen({super.key});
  @override
  State<RentalInformationScreen> createState() => _RentalInformationScreen();
}

class _RentalInformationScreen extends State<RentalInformationScreen> {
  int _selectedIndex = 0;
  final List<Map<String, String>> _navItems = [
    {'icon': '', 'label': ''},
    {'icon': '', 'label': ''},
    {'icon': '', 'label': ''},
    {'icon': '', 'label': ''},
  ];

  @override
  Widget build(BuildContext context) {
    final int itemCount = _navItems.length;
    return Scaffold(
      appBar: CustomAppbar(
        title: 'List Your Vehicle',
        textColor: Color(0xFFFFFFFF),
        height: 80,
        backgroundColor: Color(0xFF1976D2),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        height: double.infinity,
        width: double.infinity,
        color: Color(0xffFDFDFD),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: List.generate(itemCount, (index) {
                  final selected = _selectedIndex == index;
                  final item = _navItems[index];
                  return Container(
                    child: Column(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffD5D7DB), //?? Color(0xff1976D2),
                          ),
                          padding: EdgeInsets.all(3),
                          child: SvgPicture.asset(item['icon']!),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['titel']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.20,
                          ),
                        ),
                      ],
                    ),
                  );
                  // return Container(
                  //   padding: const EdgeInsets.symmetric(vertical: 8),
                  //   decoration: BoxDecoration(
                  //     border: Border(
                  //       bottom: BorderSide(
                  //         color:
                  //             selected
                  //                 ? const Color(0xFF1976D2)
                  //                 : const Color(0xFFD5D7DB),
                  //         width: 1,
                  //       ),
                  //     ),
                  //   ),
                  //   child: Text(
                  //     item['label']!,
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       color:
                  //           selected
                  //               ? const Color(0xff1976D2)
                  //               : const Color(0xff212121),
                  //       fontWeight:
                  //           selected ? FontWeight.bold : FontWeight.normal,
                  //       fontSize: 12,
                  //     ),
                  //   ),
                  // );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
