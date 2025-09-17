import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/models/vehicles/brand.dart';
import 'package:frontend/views/empty_screen.dart';
import 'package:frontend/views/vehicle_detail/detail_screen.dart';

class VehicleGrid extends StatelessWidget {
  final List vehicles;
  final bool hasMore;
  final List<Brand> brands;
  final ScrollController scrollController;

  const VehicleGrid({
    super.key,
    required this.vehicles,
    required this.hasMore,
    required this.brands,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore Rental vehicles',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          vehicles.isEmpty
              ? SizedBox(child: Center(child: EmptyListScreen()))
              : MasonryGridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 16,
                  itemCount: vehicles.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= vehicles.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final vehicle = vehicles[index];
                    final brand = brands.firstWhere(
                      (b) => b.brandId == vehicle.brandId,
                      orElse: () => Brand(
                        id: '',
                        brandId: '',
                        brandName: 'Unknown',
                        brandImage: null,
                      ),
                    );

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VehicleDetailScreen(vehicle: vehicle),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 9, offset: Offset(0, 3))],
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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            SizedBox(height: 8),
                            VehicleInfo(vehicle: vehicle, brand: brand),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class VehicleInfo extends StatelessWidget {
  final dynamic vehicle;
  final Brand brand;

  const VehicleInfo({super.key, required this.vehicle, required this.brand});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 20, height: 20, child: Image.network('${brand.brandImage}')),
            SizedBox(width: 4),
            Flexible(
              child: Text(
                '${brand.brandName} ${vehicle.vehicleName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
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
                    ? (vehicle.location!.address.isNotEmpty
                        ? vehicle.location!.address
                        : (vehicle.location!.lat != 0 && vehicle.location!.lng != 0
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
                    vehicle.averageRating.toString(),
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
              '${vehicle.reviewCount.toString()} rentals',
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
    );
  }
}
