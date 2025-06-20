import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/views/hosting/rentalInfomation/image_upload_screen.dart';
import 'package:frontend/views/hosting/rentalInfomation/rental_price_screen.dart';
import 'package:frontend/views/hosting/rentalInfomation/vehicle_documnet_screen.dart';
import 'package:frontend/views/hosting/rentalInfomation/vehicle_infomation.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';

class RentalInformationScreen extends StatefulWidget {
  const RentalInformationScreen({super.key});
  @override
  State<RentalInformationScreen> createState() => _RentalInformationScreen();
}

class _RentalInformationScreen extends State<RentalInformationScreen> {
  final PageController _controller = PageController();
  int _selectedIndex = 0;
  int _pageIndex = 0;
  final List<Map<String, String>> _navItems = [
    {'icon': 'assets/images/hosting/information/info.svg', 'label': 'Vehicle Information'},
    {'icon': 'assets/images/hosting/information/image.svg', 'label': 'Image'},
    {'icon': 'assets/images/hosting/information/document.svg', 'label': 'Vehicle Document'},
    {'icon': 'assets/images/hosting/information/price.svg', 'label': 'Rental Price'},
  ];

  void _onPageChanged(int index) {
  setState(() {
    _pageIndex = index;
    _selectedIndex = index;
  });
}

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
        child:  Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(itemCount * 2 - 1, (index) {
                if (index.isEven) {
                  final stepIndex = index ~/ 2;
                  final selected = _selectedIndex == stepIndex;
                  final item = _navItems[stepIndex];
                  return Container(
                    width: 60,
                    height: 72,
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected ? Color(0xff1976D2) : Color(0xffD5D7DB),
                          ),
                          padding: EdgeInsets.all(8),
                          child: SvgPicture.asset(
                            item['icon']!,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['label']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Expanded(
                    child: Container(
                      height: 0.2,
                      color: Colors.grey[400],
                    ),
                  );
                }
              }),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: _onPageChanged,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  VehicleInfomationScreen(),
                  ImageUploadScreen(),
                  VehicleDocumentScreen(),
                  RentalPriceScreen(),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: _pageIndex < 1
        ? Container(
        margin: EdgeInsets.all(16),
        child: CustomButton(
          title: 'Continues',
          onPressed: (){
            _controller.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        )
      )
        : Container(
          margin: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  border:Border.all(width: 2, color: Color(0xff1976D2)),
                  borderRadius:BorderRadius.circular(8),                ),
                child: TextButton(
                  onPressed: (){
                    if (_pageIndex > 0) {
                      _controller.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    'Back',
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
              ),
              const SizedBox(width: 30,),
            Expanded(
              flex: 1,
              child: CustomButton(
                title: 'Continues',
                onPressed: (){
                  _controller.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            )
          ],
        ),
      )
    );
  }
}
