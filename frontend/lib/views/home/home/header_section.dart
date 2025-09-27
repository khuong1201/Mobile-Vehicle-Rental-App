import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/viewmodels/auth/auth_viewmodel.dart';
import 'package:frontend/viewmodels/auth/google_auth_viewmodel.dart';
import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/custom_Svg_icon.dart';

class HeaderSection extends StatelessWidget {
  final AuthViewModel authVM;
  final GAuthViewModel gAuthVM;
  final dynamic user;
  final TextEditingController searchController;
  final VehicleViewModel vehicleVM;

  const HeaderSection({
    super.key,
    required this.authVM,
    required this.gAuthVM,
    required this.user,
    required this.searchController,
    required this.vehicleVM,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff1976D2), Color(0xffFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ClipOval(
                  child: Image.network(
                    authVM.user?.imageAvatarUrl ?? gAuthVM.user?.imageAvatarUrl ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/images/error/avatar.png', width: 50, height: 50),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    SizedBox(
                      width: 205,
                      child: Text(
                        'Welcome, ${user?.fullName.isNotEmpty == true ? user!.fullName : 'Bro'}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFFF7F7F8),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: SvgPicture.asset('assets/images/homePage/notification.svg'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Search + category buttons
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 20, offset: Offset(0, 3))],
            ),
            child: Column(
              children: [
                CustomTextField(
                  controller: searchController,
                  hintText: "Search",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset('assets/images/homePage/home/search.svg'),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgIconTextButton(
                      assetPath: 'assets/images/homePage/home/car.svg',
                      width: 32,
                      height: 32,
                      label: 'car',
                      onPressed: () => vehicleVM.changeType("Car", context),
                    ),
                    SvgIconTextButton(
                      assetPath: 'assets/images/homePage/home/coach.svg',
                      width: 32,
                      height: 32,
                      label: 'Coach',
                      onPressed: () => vehicleVM.changeType("Coach", context),
                    ),
                    SvgIconTextButton(
                      assetPath: 'assets/images/homePage/home/motorbike.svg',
                      width: 32,
                      height: 32,
                      label: 'Motorbike',
                      onPressed: () => vehicleVM.changeType("Motorbike", context),
                    ),
                    SvgIconTextButton(
                      assetPath: 'assets/images/homePage/home/bike.svg',
                      width: 32,
                      height: 32,
                      label: 'Bike',
                      onPressed: () => vehicleVM.changeType("Bike", context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
