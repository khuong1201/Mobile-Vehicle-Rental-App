import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/models/location/location_for_vehicle.dart';
import 'package:frontend/viewmodels/location/location_viewmodel.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
  final ValueNotifier<int> _pageNotifier = ValueNotifier<int>(0);
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      _pageNotifier.value = _pageController.page?.round() ?? 0;
    });
    final vm = Provider.of<LocationViewModel>(context, listen: false);
    vm.fetchProvinces();
    _searchController.addListener(() {
      vm.searchProvinces(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_pageController.page! < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LocationViewModel>(context);

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Select location',
        textColor: Colors.white,
        height: 80,
        backgroundColor: const Color(0xFF1976D2),
        leading: ValueListenableBuilder<int>(
          valueListenable: _pageNotifier,
          builder: (context, pageIndex, _) {
            return IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: EdgeInsets.only(top: 24),
              onPressed: () {
                if(pageIndex <= 0) {
                  Navigator.pop(context);
                } else {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
                
              },
              icon: Container(
                decoration: BoxDecoration(
                  color: Color(0xffD1E4F6),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(4),
                child: Icon(Icons.arrow_back, color: Color(0xff1976D2)),
              ),
            );
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        height: double.infinity,
        width: double.infinity,
        color: Color(0xffFDFDFD),
        child: Column(
          children: [
            CustomTextField(
              controller: _searchController,
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          vm.searchProvinces('');
                        },
                      )
                      : null,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final locationVM = Provider.of<LocationViewModel>(
                  context,
                  listen: false,
                );
                try {
                  final position = await locationVM.getCurrentLocation();
                  final placemark = await locationVM.getAddressFromCoordinates(
                    position.latitude,
                    position.longitude,
                  );

                  if (placemark != null) {
                    await locationVM.autoSelectLocationFromCoordinates(
                      position.latitude,
                      position.longitude,
                    );

                    final locationForVehicle = LocationForVehicle(
                      address: locationVM.getFullLocation().toString(),
                      lat: position.latitude,
                      lng: position.longitude,
                    );
                    Navigator.pop(context, locationForVehicle);
                    setState(() {
                      _currentAddress = locationForVehicle.address;
                    });
                  } else {
                    throw Exception('Không tìm thấy địa chỉ từ tọa độ');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Không lấy được vị trí: $e')),
                  );
                }
              },

              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 8,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/hosting/information/location.svg',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _currentAddress ?? 'Use My Current Location',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.29,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildProvinceList(vm),

                  _buildDistrictList(vm),

                  _buildWardList(vm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProvinceList(LocationViewModel vm) {
    if (vm.isLoadingProvinces) {
      return const Center(child: CircularProgressIndicator());
    } else if (vm.errorMessage != null) {
      return Center(
        child: Text(
          vm.errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: vm.provinces.length,
        itemBuilder: (context, index) {
          final province = vm.provinces[index];
          return ListTile(
            title: Text(province.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await vm.selectProvince(province);
              _goToNextPage();
            },
          );
        },
      );
    }
  }

  Widget _buildDistrictList(LocationViewModel vm) {
    if (vm.isLoadingDistricts) {
      return const Center(child: CircularProgressIndicator());
    } else if (vm.districts.isEmpty) {
      return const Center(child: Text("Không có quận/huyện nào"));
    } else {
      return Column(
        children: [
          Text(
            'Quận/Huyện của: ${vm.selectedProvince?.name ?? ''}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: vm.districts.length,
              itemBuilder: (context, index) {
                final district = vm.districts[index];
                return ListTile(
                  title: Text(district.name),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await vm.selectDistrict(district);
                    _goToNextPage();
                  },
                );
              },
            ),
          ),
        ],
      );
    }
  }

  Widget _buildWardList(LocationViewModel vm) {
    if (vm.isLoadingWards) {
      return const Center(child: CircularProgressIndicator());
    } else if (vm.wards.isEmpty) {
      return const Center(child: Text("Không có phường/xã nào"));
    } else {
      return Column(
        children: [
          Text(
            'Phường/Xã của: ${vm.selectedDistrict?.name ?? ''}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: vm.wards.length,
              itemBuilder: (context, index) {
                final ward = vm.wards[index];
                return ListTile(
                  title: Text(ward.name),
                  onTap: () {
                    vm.selectWard(ward);
                    Navigator.pop(context, vm.getFullLocation());
                  },
                );
              },
            ),
          ),
        ],
      );
    }
  }
}
