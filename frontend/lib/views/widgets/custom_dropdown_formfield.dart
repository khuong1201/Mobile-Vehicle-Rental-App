import 'package:flutter/material.dart';

class CustomDropdownButtonFormField extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;
  final List<String> items;
  final String? hintText; 

  const CustomDropdownButtonFormField({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
    required this.items,
    this.hintText
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        hintText: hintText ?? 'Choose',
        hintStyle: const TextStyle(
          color: Color(0xFFAAACAF),
          fontSize: 14,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.29,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Color(0xFF808183),
            width: 1,
          ),
        ),
        
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}