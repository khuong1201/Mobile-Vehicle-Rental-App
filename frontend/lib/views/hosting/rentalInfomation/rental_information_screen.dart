import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
import 'package:frontend/views/hosting/rentalInfomation/image_upload_screen.dart';
import 'package:frontend/views/hosting/rentalInfomation/rental_price_screen.dart';
import 'package:frontend/views/hosting/rentalInfomation/vehicle_documnet_screen.dart';
import 'package:frontend/views/hosting/rentalInfomation/vehicle_infomation.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RentalInformationScreen extends StatefulWidget {
  final String? vehicleType;
  final List<File>? imageFiles;
  const RentalInformationScreen({super.key, this.vehicleType, this.imageFiles});

  @override
  State<RentalInformationScreen> createState() => _RentalInformationScreen();
}

class _RentalInformationScreen extends State<RentalInformationScreen> {

  final PageController _controller = PageController();
  
  int _selectedIndex = 0;
  int _pageIndex = 0;

  List<Map<String, String>> get _navItems {
    String vehicleType = widget.vehicleType ?? 'Vehicle';
    String capitalizedType = vehicleType.isNotEmpty
        ? '${vehicleType[0].toUpperCase()}${vehicleType.substring(1)}'
        : 'Vehicle';

    return [
      {
        'icon': 'assets/images/hosting/information/info.svg',
        'label': '$capitalizedType Information'
      },
      {
        'icon': 'assets/images/hosting/information/image.svg',
        'label': 'Image'
      },
      {
        'icon': 'assets/images/hosting/information/document.svg',
        'label': '$capitalizedType Document'
      },
      {
        'icon': 'assets/images/hosting/information/price.svg',
        'label': 'Rental Price'
      },
    ];
  }

  void _onPageChanged(int index) {
    setState(() {
      _pageIndex = index;
      _selectedIndex = index;
    });
  }
  Map<String, dynamic> _collectedData = {};

  void _updateData(String page, Map<String, dynamic> data) {
    setState(() {
      _collectedData[page] = data;
    });
  }

  Future<void> _submitData() async {
    if (_pageIndex == _navItems.length - 1) { 
      final viewModel = Provider.of<VehicleViewModel>(context, listen: false);
      final Map<String, dynamic> data = {
        ...(_collectedData['VehicleInfomationScreen'] ?? {}),
        ...(_collectedData['ImageUploadScreen'] ?? {}),
        ...(_collectedData['VehicleDocumentScreen'] ?? {}),
        ...(_collectedData['RentalPriceScreen'] ?? {}),
        'type': widget.vehicleType ?? 'vehicle',
      };

      // Truy xuất 'images' và chuyển đổi XFile? thành List<File>
      final Map<String, dynamic>? imagesData = _collectedData['ImageUploadScreen']?['images'] as Map<String, dynamic>?;
      final List<File> imageFiles = imagesData != null
        ? imagesData.values.whereType<XFile>().map((xFile) => File(xFile.path)).toList()
        : (widget.imageFiles ?? []);

      await viewModel.createVehicle(context, data, imageFiles );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('Received vehicle type: ${widget.vehicleType}');
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
                  final isBeforeOrCurrent = stepIndex <= _selectedIndex;
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
                            color: isBeforeOrCurrent ? Color(0xff1976D2) : Color(0xffD5D7DB),
                          ),
                          padding: EdgeInsets.all(8),
                          child: SvgPicture.asset(
                            item['icon']!,
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
                  final stepIndex = index ~/ 2 + 1;
                  final isBeforeOrCurrent = stepIndex <= _selectedIndex;
                  return Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 1,
                          color: isBeforeOrCurrent ? Color(0xff1976D2) : Colors.grey[400],
                        ),
                        const SizedBox(height: 30,)
                      ],
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
                  VehicleInfomationScreen(
                    vehicleType: widget.vehicleType,
                    onDataChanged: (data) => _updateData('VehicleInfomationScreen', data),
                  ),
                  ImageUploadScreen(
                    vehicleType: widget.vehicleType,
                    onDataChanged: (data) => _updateData('ImageUploadScreen', data),
                  ),
                  DocumentScreen(
                    onDataChanged: (data) => _updateData('VehicleDocumentScreen', data),
                  ),
                  RentalPriceScreen(
                    onDataChanged: (data) => _updateData('RentalPriceScreen', data),
                  ),
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
                  if(_pageIndex < 3){
                     _controller.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _submitData();
                  }
                },
              ),
            )
          ],
        ),
      )
    );
  }
}
