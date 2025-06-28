  import 'package:flutter/material.dart';
  import 'package:flutter_svg/svg.dart';
  import 'package:frontend/models/vehicles/brand.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';
  import 'package:frontend/viewmodels/user/user_provider_viewmodel.dart';
  import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
import 'package:frontend/views/widgets/custom_text_body_M_sb.dart';
  import 'package:provider/provider.dart';

  class ListVehicle extends StatefulWidget {
    const ListVehicle({super.key});

  @override
  State<ListVehicle> createState() => ListVehicleState();
}

class ListVehicleState extends State<ListVehicle> {
  String? userId;
  bool isLoading = true;

  Future<void> fetchData() async {
    final vehicleViewModel = context.read<VehicleViewModel>();
    await vehicleViewModel.fetchVehicles(
      context,
      page: 1,
      limit: 10,
      clearBefore: true,
    );
  }

  Future<void> fetchUserId() async {
    final authService = AuthService(context);
    final id = await authService.getUserId();
    setState(() {
      userId = id;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchUserId();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    print("user: ${userId}");
    final vehicleVM = Provider.of<VehicleViewModel>(context);
    final rentalvehicles = vehicleVM.vehicles.where((vh) => vh.ownerId == userId).toList();
    final brands = Provider.of<VehicleViewModel>(context).brands;
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: rentalvehicles.length,
      itemBuilder: (context, index) {
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
          child: Container(
            padding:EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            margin: EdgeInsets.only(bottom: 16),
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
            child: Row(
              children: [
                Container(
                  width: 190,
                  height: 125,
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
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextBodyMsb(title: '${brand.brandName} ${vehicle.vehicleName}' ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: ShapeDecoration(
                              color: vehicle.status.toLowerCase() == 'rented'
                              ? const Color(0xFF4CAF50)
                              : vehicle.status.toLowerCase() == 'pending'
                                  ? const Color(0xFFFFC107)
                                  : const Color(0xFF75ADE4),
                              shape: OvalBorder(),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                          vehicle.status,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.29,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
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
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight:
                                  FontWeight.w500,
                              height: 1.20,
                            ),
                          ),
                        ],
                      ),  
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16,
                            width: 16,
                            child: SvgPicture.asset('assets/images/hosting/Lessorhome/Vector (1).svg')
                          ),
                          const SizedBox(width: 4),
                          Text(
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
                          ),
                          SizedBox(width: 4),
                          Text(
                            '/ day',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(
                                0xFF808183,
                              ),
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.20,
                            ),
                          ),
                        ],
                      ),
                    ]
                  )
                )
              ],
            )
          )
        );
      },
    );
  }
}