import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_text_heading4.dart';

class CustomDateFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDateFormField({
    super.key,
    required this.controller,
    this.validator,
    this.hintText = "Select Date",
    this.firstDate,
    this.lastDate,
  });

  @override
  State<CustomDateFormField> createState() => _CustomDateFormFieldState();
}

class _CustomDateFormFieldState extends State<CustomDateFormField> {
  Future<void> _selectDate() async {
    final selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (_) => CustomDatePickerDialog(
        initialDate: DateTime.now(),
        firstDate: widget.firstDate ?? DateTime(2000),
        lastDate: widget.lastDate ?? DateTime(2100),
      ),
    );

    if (selectedDate != null) {
      widget.controller.text =
          "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      readOnly: true,
      onTap: _selectDate,
      decoration: InputDecoration(
        hintText: widget.hintText,  
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
        suffixIcon: Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          child: SvgPicture.asset('assets/images/booking/calendar.svg',
          
          )
        )
      ),
    );
  }
}

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const CustomDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final dp.DatePickerRangeStyles singleStyles = dp.DatePickerRangeStyles(
      selectedSingleDateDecoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      selectedDateStyle: const TextStyle(color: Colors.white),
      currentDateStyle: const TextStyle(color: Colors.orange),
      disabledDateStyle: const TextStyle(color: Colors.grey),
      dayHeaderStyle: dp.DayHeaderStyle(
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextHeading4(title: "Select Date"),
            const SizedBox(height: 16),
            dp.DayPicker.single(
              selectedDate: _selectedDate,
              onChanged: (date) => setState(() => _selectedDate = date),
              firstDate: DateTime.now(),
              lastDate: widget.lastDate,
              datePickerStyles: singleStyles,
              datePickerLayoutSettings: const dp.DatePickerLayoutSettings(),
              selectableDayPredicate: (date) {
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final d = DateTime(date.year, date.month, date.day);
                return !d.isBefore(today);
              }
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              margin:EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: CustomButton(
                title:'Select',
                onPressed: () => Navigator.of(context).pop(_selectedDate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
