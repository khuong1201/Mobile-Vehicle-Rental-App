  import 'package:flutter/material.dart';

    bool isValidDate(String value) {
      final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
      return regex.hasMatch(value);
    }

    bool isValidPhone(String value) {
      final regex = RegExp(r'^\d{10,11}$');
      return regex.hasMatch(value);
    }

  class CustomTextField extends StatefulWidget {
    final TextEditingController controller;
    final String? Function(String?)? validator;
    final String? hintText;
    final bool isPassword;
    final Widget? prefixIcon;
    final TextInputType? keyboardType;
    final ValueChanged<String>? onChanged;

    const CustomTextField({
      super.key,
      required this.controller,
      this.validator,
      this.hintText,
      this.isPassword = false,
      this.prefixIcon,
      this.keyboardType,
      this.onChanged,
      
    });

    @override
    State<CustomTextField> createState() => _CustomTextFieldState();
  }

  class _CustomTextFieldState extends State<CustomTextField> {
    bool _obscurePassword = true;

    @override
    Widget build(BuildContext context) {
      return TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        obscureText: widget.isPassword ? _obscurePassword : false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFAAACAF),
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 1.29,
          ),
          prefixIcon: widget.prefixIcon,
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
          suffixIcon: widget.isPassword
          ? IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Color(0xFF808183),
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            )
          : null,
        ),
        validator: widget.validator,
        onChanged: widget.onChanged,
      );
    }
  }