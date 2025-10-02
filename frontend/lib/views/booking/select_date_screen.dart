import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class CalendarDatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final void Function(DateTime)? onDateSelected;

  const CalendarDatePickerField({
    super.key,
    required this.controller,
    this.labelText = 'Chọn ngày',
    this.onDateSelected,
  });

  @override
  State<CalendarDatePickerField> createState() => _CalendarDatePickerFieldState();
}

class _CalendarDatePickerFieldState extends State<CalendarDatePickerField> {
  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      widget.controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      widget.onDateSelected?.call(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      readOnly: true,
      onTap: _pickDate,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
    );
  }
}
