import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
import 'package:frontend/views/hosting/rentalInfomation/image_upload_screen.dart';
import 'package:frontend/views/hosting/rentalInfomation/rental_price_screen.dart';
import 'package:frontend/views/hosting/rentalInfomation/vehicle_documnet_screen.dart';
import 'package:frontend/views/hosting/rentalInfomation/vehicle_infomation.dart';
import 'package:frontend/views/widgets/custom_alert_dialog.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class RentalInformationScreen extends StatefulWidget {
  final String? vehicleType;
  final List<File>? imageFiles;

  const RentalInformationScreen({super.key, this.vehicleType, this.imageFiles});

  @override
  State<RentalInformationScreen> createState() => _RentalInformationScreen();
}

class _RentalInformationScreen extends State<RentalInformationScreen> {
  final PageController _controller = PageController();

  int _pageIndex = 0;

  final GlobalKey<FormState> _infoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _imageFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _docFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _priceFormKey = GlobalKey<FormState>();

  final Map<String, dynamic> _collectedData = {};

  List<Map<String, String>> get _navItems {
    String vehicleType = widget.vehicleType ?? 'Vehicle';
    String capitalizedType =
        vehicleType.isNotEmpty
            ? '${vehicleType[0].toUpperCase()}${vehicleType.substring(1)}'
            : 'Vehicle';

    return [
      {
        'icon': 'assets/images/hosting/information/info.svg',
        'label': '$capitalizedType Information',
      },
      {'icon': 'assets/images/hosting/information/image.svg', 'label': 'Image'},
      {
        'icon': 'assets/images/hosting/information/document.svg',
        'label': '$capitalizedType Document',
      },
      {
        'icon': 'assets/images/hosting/information/price.svg',
        'label': 'Rental Price',
      },
    ];
  }

  void _updateData(String page, Map<String, dynamic> data) {
    setState(() {
      _collectedData[page] = data;
    });
  }

  bool _validateCurrentPage() {
    switch (_pageIndex) {
      case 0:
        return _infoFormKey.currentState?.validate() ?? false;
        
      case 1:
        return _imageFormKey.currentState?.validate() ?? false;
        
      case 2:
        return _docFormKey.currentState?.validate() ?? false;
      case 3:
        return _priceFormKey.currentState?.validate() ?? false;
      default:
        return false;
    }
  }

  Future<void> _submitData() async {
    final viewModel = Provider.of<VehicleViewModel>(context, listen: false);

    final Map<String, dynamic> data = {
      ...(_collectedData['VehicleInformationScreen'] ?? {}),
      ...(_collectedData['ImageUploadScreen'] ?? {}),
      ...(_collectedData['DocumentScreen'] ?? {}),
      ...(_collectedData['RentalPriceScreen'] ?? {}),
      'type': widget.vehicleType ?? 'vehicle',
    };

    final Map<String, dynamic>? imagesData =
        _collectedData['ImageUploadScreen']?['images'] as Map<String, dynamic>?;

    final List<File> imageFiles =
        imagesData != null
            ? imagesData.values
                .whereType<XFile>()
                .map((xFile) => File(xFile.path))
                .where((file) => file.existsSync())
                .toList()
            : (widget.imageFiles ?? []);

    await viewModel.createVehicle(context, data, imageFiles);
    Navigator.pop(context);
  }

  void _onNext() {
    if (_validateCurrentPage()) {
      if (_pageIndex < _navItems.length - 1) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _submitData();
      }
    } else {
      showDialog(
        context: context,
        builder:
            (context) => CustomAlertDialog(
              title: 'Error',
              content:
                  'Please try again.',
              buttonText: 'OK',
            ),
      );
    }
  }

  void _onBack() {
    if (_pageIndex > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int itemCount = _navItems.length;
    return Scaffold(
      appBar: CustomAppbar(
        title: 'List Your Vehicle',
        textColor: Colors.white,
        height: 80,
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: const Color(0xffFDFDFD),
        child: Column(
          children: [
            // Step Indicator
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(itemCount * 2 - 1, (index) {
                if (index.isEven) {
                  final stepIndex = index ~/ 2;
                  final isBeforeOrCurrent = stepIndex <= _pageIndex;
                  final item = _navItems[stepIndex];
                  return SizedBox(
                    width: 60,
                    height: 72,
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isBeforeOrCurrent
                                    ? const Color(0xff1976D2)
                                    : const Color(0xffD5D7DB),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: SvgPicture.asset(item['icon']!),
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
                  final isBeforeOrCurrent = stepIndex <= _pageIndex;
                  return Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 1,
                          color:
                              isBeforeOrCurrent
                                  ? const Color(0xff1976D2)
                                  : Colors.grey[400],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                }
              }),
            ),
            const SizedBox(height: 20),

            // Pages
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) => setState(() => _pageIndex = index),
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  VehicleInfomationScreen(
                    vehicleType: widget.vehicleType,
                    formKey: _infoFormKey,
                    onDataChanged:
                        (data) => _updateData('VehicleInformationScreen', data),
                  ),
                  ImageUploadScreen(
                    vehicleType: widget.vehicleType,
                    formKey: _imageFormKey,
                    onDataChanged:
                        (data) => _updateData('ImageUploadScreen', data),
                  ),
                  DocumentScreen(
                    vehicleType: widget.vehicleType,
                    onDataChanged:
                        (data) => _updateData('DocumentScreen', data),
                    formKey: _docFormKey,
                  ),
                  RentalPriceScreen(
                    vehicleType: widget.vehicleType,
                    formKey: _priceFormKey,
                    onDataChanged:
                        (data) => _updateData('RentalPriceScreen', data),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_pageIndex > 0)
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    border: Border.all(width: 2, color: Color(0xff1976D2)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: _onBack,
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
            if (_pageIndex > 0) const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                title: _pageIndex == 3 ? 'Submit' : 'Continue',
                onPressed: _onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
