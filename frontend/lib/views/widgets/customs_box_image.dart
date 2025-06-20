  import 'dart:io';
  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart';

  class CustomBoxImage extends StatelessWidget {
    final String title;
    final String hintText;
    final XFile? image;
    final VoidCallback? onPickImage;

    const CustomBoxImage({
      super.key,
      required this.title,
      required this.hintText,
      required this.image,
      this.onPickImage,
    });

    @override
    Widget build(BuildContext context) {
      return InkWell(
        onTap: onPickImage,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            color: const Color(0xffDDDFE2),
            borderRadius: BorderRadius.circular(8),
          ),
          child:
              image == null
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              color: Color(0xFF555658),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              hintText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF555658),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Image.file(File(image!.path), height: 80, fit: BoxFit.cover),
        ),
      );
    }
  }
