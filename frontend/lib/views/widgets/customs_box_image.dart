import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomBoxImage extends FormField<XFile> {
  final String title;
  final String hintText;
  final VoidCallback? onPickImage;

  CustomBoxImage({
    super.key,
    required this.title,
    required this.hintText,
    XFile? image,
    this.onPickImage,
    String? Function(XFile?)? validator,
  }) : super(
          initialValue: image,
          validator: validator,
          builder: (FormFieldState<XFile> state) {
            return InkWell(
              onTap: onPickImage,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: BoxDecoration(
                  color: const Color(0xffDDDFE2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: state.hasError ? Colors.red : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: state.value == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt_outlined,
                            color: Color(0xFF555658),
                            size: 24,
                          ),
                        ],
                      )
                    : FutureBuilder<bool>(
                        future: File(state.value!.path).exists(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.data == true) {
                            return Image.file(
                              File(state.value!.path),
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error, color: Colors.red),
                            );
                          }
                          return const Icon(Icons.error, color: Colors.red);
                        },
                      ),
              ),
            );
          },
        );
}