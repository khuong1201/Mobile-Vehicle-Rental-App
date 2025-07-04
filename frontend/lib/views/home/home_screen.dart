import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/models/vehicles/brand.dart';
import 'package:frontend/viewmodels/auth/auth_viewmodel.dart';
import 'package:frontend/viewmodels/auth/google_auth_viewmodel.dart';
import 'package:frontend/viewmodels/user/user_provider_viewmodel.dart';
import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
import 'package:frontend/views/empty_screen.dart';
import 'package:frontend/views/vehicle_detail/detail_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_Svg_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> banners = [
    'assets/images/banners/banner1.png',
    'assets/images/banners/banner2.png',
    'assets/images/banners/banner3.png',
    'assets/images/banners/banner4.png',
    'assets/images/banners/banner5.png',
  ];

  late final PageController _bannerController;
  int _currentBanner = 0;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_bannerController.hasClients) {
        int nextPage = (_currentBanner + 1) % banners.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        // Gần cuối -> load thêm
        final vehicleVM = Provider.of<VehicleViewModel>(context, listen: false);
        vehicleVM.loadMoreVehicles(context);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final vehicleVM = Provider.of<VehicleViewModel>(context, listen: false);
        vehicleVM.fetchBrands(context).then((_) {
          vehicleVM.fetchVehicles(context);
        });
      }
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _bannerTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewmodel = Provider.of<AuthViewModel>(context);
    final gAuthViewmodel = Provider.of<GAuthViewModel>(context);
    final vehicleVM = Provider.of<VehicleViewModel>(context);
    final userVM = Provider.of<UserViewModel>(context);
    final user = userVM.user;
    final rentalvehicles = vehicleVM.vehicles;
    final brands = Provider.of<VehicleViewModel>(context).brands;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color(0xffFDFDFD),
        child: RefreshIndicator(
          onRefresh: () async {
            final vehicleVM = context.read<VehicleViewModel>();
            vehicleVM.refresh(context);
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // header
                Container(
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
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                authViewmodel.user?.imageAvatarUrl ??
                                    gAuthViewmodel.user?.imageAvatarUrl ??
                                    '',
                                width: 50,
                                height: 50,
                                fit: BoxFit.contain,
                                errorBuilder:
                                    (context, error, stackTrace) => Image.asset(
                                      'assets/images/error/avatar.png',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.contain,
                                    ),
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
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6),
                                //dropdown
                              ],
                            ),
                            Spacer(),
                            IconButton(
                              icon: SvgPicture.asset(
                                'assets/images/homePage/notification.svg',
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xffFFFFFF),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 20,
                              offset: Offset(0, 3),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: CustomTextField(
                                controller: _searchController,
                                hintText: "Search",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    'assets/images/homePage/home/search.svg',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 36),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgIconTextButton(
                                    assetPath:
                                        'assets/images/homePage/home/car.svg',
                                    width: 32,
                                    height: 32,
                                    label: 'car',
                                    onPressed: () {},
                                  ),
                                  SvgIconTextButton(
                                    assetPath:
                                        'assets/images/homePage/home/coach.svg',
                                    width: 32,
                                    height: 32,
                                    label: 'Coach',
                                    onPressed: () {},
                                  ),
                                  SvgIconTextButton(
                                    assetPath:
                                        'assets/images/homePage/home/motorbike.svg',
                                    width: 32,
                                    height: 32,
                                    label: 'Motorbike',
                                    onPressed: () {},
                                  ),
                                  SvgIconTextButton(
                                    assetPath:
                                        'assets/images/homePage/home/bike.svg',
                                    width: 32,
                                    height: 32,
                                    label: 'Bike',
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //banner
                Container(
                  margin: EdgeInsets.symmetric(vertical: 29),
                  height: 220,
                  child: PageView.builder(
                    controller: _bannerController,
                    itemCount: banners.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentBanner = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(banners[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                //view
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore Rental vehicles',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      rentalvehicles.isEmpty
                          ? SizedBox(child: Center(child: EmptyListScreen()))
                          : MasonryGridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            // gridDelegate:
                            //     SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 16,
                            //childAspectRatio: 0.6,
                            //),
                            itemCount:
                                rentalvehicles.length +
                                (vehicleVM.hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= rentalvehicles.length) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final vehicle = rentalvehicles[index];
                              final brand = brands.firstWhere(
                                (b) => b.id == vehicle.brand,
                                orElse:
                                    () => Brand(
                                      id: '',
                                      brandId: '',
                                      brandName: 'Unknown',
                                      brandImage: null,
                                    ),
                              );
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => VehicleDetailScreen(
                                            vehicle: vehicle,
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x33000000),
                                        blurRadius: 9,
                                        offset: Offset(0, 3),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 172,
                                        height: 172,
                                        decoration: ShapeDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              vehicle.images.isNotEmpty
                                                  ? vehicle.images[0]
                                                  : 'https://www.kia.com/content/dam/kwcms/gt/en/images/discover-kia/voice-search/parts-80-1.jpg',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: SvgPicture.network(
                                                    '${brand.brandImage}',
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Flexible(
                                                  child: Text(
                                                    '${brand.brandName} ${vehicle.vehicleName}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: SvgPicture.asset(
                                                    'assets/images/homePage/home/address.svg',
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Flexible(
                                                  child: Text(
                                                    vehicle.location != null
                                                        ? (vehicle
                                                                .location!
                                                                .address
                                                                .isNotEmpty
                                                            ? vehicle
                                                                .location!
                                                                .address
                                                            : (vehicle.location!.lat !=
                                                                        0 &&
                                                                    vehicle
                                                                            .location!
                                                                            .lng !=
                                                                        0
                                                                ? '(${vehicle.location!.lat}, ${vehicle.location!.lng})'
                                                                : 'none information'))
                                                        : 'none information',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: const Color(
                                                        0xFFAAACAF,
                                                      ),
                                                      fontSize: 12,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      EdgeInsetsDirectional.all(
                                                        2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffFFF5E0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          2,
                                                        ),
                                                    border: Border.all(
                                                      color: Color(0xFFFFC107),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 12,
                                                        height: 12,
                                                        child: SvgPicture.asset(
                                                          'assets/images/homePage/home/star.svg',
                                                        ),
                                                      ),
                                                      SizedBox(width: 3),
                                                      Text(
                                                        vehicle.rate.toString(),
                                                        style: TextStyle(
                                                          color: const Color(
                                                            0xFF2B2B2C,
                                                          ),
                                                          fontSize: 10,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 1.20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Container(
                                                  width: 1,
                                                  height: 16,
                                                  color: Color(0xFF555658),
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  '${vehicle.rentals.toString()} rentals',
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFF555658,
                                                    ),
                                                    fontSize: 10,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Text.rich(
                                              TextSpan(
                                                text:
                                                    vehicle.formattedPrice
                                                        .toString(),
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFF1976D2,
                                                  ),
                                                  fontSize: 16,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.25,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: '/ day',
                                                    style: TextStyle(
                                                      color: const Color(
                                                        0xFF808183,
                                                      ),
                                                      fontSize: 16,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 1.20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
