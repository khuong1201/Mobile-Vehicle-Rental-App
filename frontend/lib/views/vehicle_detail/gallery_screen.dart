import 'package:flutter/material.dart';
import 'package:frontend/models/vehicles/vehicle.dart';

class GalleryScreen extends StatelessWidget {
  final Vehicle vehicle;
  const GalleryScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 105,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      vehicle.images.isNotEmpty
                          ? vehicle.images[1]
                          : 'https://www.kia.com/content/dam/kwcms/gt/en/images/discover-kia/voice-search/parts-80-1.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Container(
                height: 105,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      vehicle.images.isNotEmpty
                          ? vehicle.images[2]
                          : 'https://www.kia.com/content/dam/kwcms/gt/en/images/discover-kia/voice-search/parts-80-1.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 105,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      vehicle.images.isNotEmpty
                          ? vehicle.images[3]
                          : 'https://www.kia.com/content/dam/kwcms/gt/en/images/discover-kia/voice-search/parts-80-1.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Container(
                height: 105,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      vehicle.images.isNotEmpty
                          ? vehicle.images[4]
                          : 'https://www.kia.com/content/dam/kwcms/gt/en/images/discover-kia/voice-search/parts-80-1.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
