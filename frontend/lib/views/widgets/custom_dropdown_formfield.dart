import 'package:flutter/material.dart';

class CustomDropdownButtonFormField<T> extends StatelessWidget {
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final List<T> items;
  final String? hintText;
  final Widget Function(T item)? itemBuilder;

  const CustomDropdownButtonFormField({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
    required this.items,
    this.hintText,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        hintText: hintText ?? 'Choose',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child: itemBuilder != null ? itemBuilder!(item) : Text(item.toString()),
              ))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
