import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomBoxImage extends StatelessWidget {
  final String title;
  final String hintText;
  final XFile? image;
  final VoidCallback? onPickImage;
  final String? Function(XFile?)? validator;
  final String? imageUrl;

  const CustomBoxImage({
    super.key,
    required this.title,
    required this.hintText,
    required this.image,
    this.onPickImage,
    this.validator,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = validator?.call(image) != null;

    return GestureDetector(
      onTap: onPickImage,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffDDDFE2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasError ? Colors.red : Colors.transparent,
            width: 2,
          ),
        ),
        child: image != null
            ? FutureBuilder<bool>(
                future: File(image!.path).exists(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.data == true) {
                    return Image.file(
                      File(image!.path),
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.error, color: Colors.red),
                    );
                  }
                  return const Icon(Icons.error, color: Colors.red);
                },
              )
            : (imageUrl != null && imageUrl!.isNotEmpty)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.error, color: Colors.red),
                    ),
                )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_alt_outlined,
                          color: Color(0xFF555658), size: 24),
                    ],
                  ),
      ),
    );
  }
}
