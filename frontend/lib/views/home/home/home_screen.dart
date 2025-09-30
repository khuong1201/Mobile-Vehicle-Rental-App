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

    // Auto-scroll banners
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

    // Infinite scroll: load more when reaching bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        context.read<VehicleViewModel>().loadMoreVehicles(context);
      }
    });

    // Initial data load
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final vehicleVM = context.read<VehicleViewModel>();
      await vehicleVM.fetchBrands(context);
      await vehicleVM.fetchVehicles(context);
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _bannerTimer?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.read<AuthViewModel>();
    final gAuthVM = context.read<GAuthViewModel>();
    final userVM = context.watch<UserViewModel>();
    final user = userVM.user;

    return Scaffold(
      body: Container(
        color: const Color(0xffFDFDFD),
        child: RefreshIndicator(
          onRefresh: () async => context.read<VehicleViewModel>().refresh(context),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Header
                HeaderSection(
                  vehicleVM: context.read<VehicleViewModel>(),
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

                Consumer<VehicleViewModel>(
                  builder: (context, vm, _) {
                    
                    if (vm.isLoading && vm.vehicles.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (vm.errorMessage != null) {
                      return Center(
                        child: Text(
                          'Error: ${vm.errorMessage}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (vm.vehicles.isEmpty) {
                      return const Center(child: Text('No vehicles found 😢'));
                    }

                    return Column(
                      children: [
                        VehicleGrid(
                          vehicles: vm.vehicles,
                          hasMore: vm.hasMore,
                          brands: vm.brands,
                          scrollController: _scrollController,
                        ),
                        if (vm.isLoading && vm.vehicles.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
