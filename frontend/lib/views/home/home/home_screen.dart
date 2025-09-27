import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/auth/auth_viewmodel.dart';
import 'package:frontend/viewmodels/auth/google_auth_viewmodel.dart';
import 'package:frontend/viewmodels/user/user_provider_viewmodel.dart';
import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
import 'package:frontend/views/Home/home/banner_slider.dart';
import 'package:frontend/views/Home/home/header_section.dart';
import 'package:frontend/views/Home/home/vehicle_grid_item.dart';
import 'package:provider/provider.dart';

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
          _scrollController.position.maxScrollExtent - -100) {
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
    final authVM = Provider.of<AuthViewModel>(context);
    final gAuthVM = Provider.of<GAuthViewModel>(context);
    final vehicleVM = Provider.of<VehicleViewModel>(context);
    final userVM = Provider.of<UserViewModel>(context);
    final user = userVM.user;
    final rentalVehicles = vehicleVM.vehicles;
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
                
                HeaderSection(
                  vehicleVM: vehicleVM,
                  authVM: authVM,
                  gAuthVM: gAuthVM,
                  user: user,
                  searchController: _searchController,
                ),

                BannerSlider(
                  banners: banners,
                  controller: _bannerController,
                  currentIndex: _currentBanner,
                  onPageChanged: (index) => setState(() => _currentBanner = index),
                ),

                VehicleGrid(
                  vehicles: rentalVehicles,
                  hasMore: vehicleVM.hasMore,
                  brands: vehicleVM.brands,
                  scrollController: _scrollController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}