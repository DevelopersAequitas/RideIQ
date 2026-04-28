import 'package:flutter/material.dart';
import 'package:rideiq/core/utils/size_config.dart';

class LabeledInputField extends StatelessWidget {
  final String label;
  final String? hint;
  final ValueChanged<String> onChanged;
  final bool hasLabelOnBorder;
  final bool isEmail;

  const LabeledInputField({
    super.key,
    required this.label,
    this.hint,
    required this.onChanged,
    this.hasLabelOnBorder = true,
    this.isEmail = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF1A1A1A),
        fontFamily: 'Figtree',
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
          color: const Color(0xFF999999),
          fontSize: 14.sp,
          fontFamily: 'Figtree',
        ),
        floatingLabelStyle: TextStyle(
          color: const Color(0xFF1E74E9),
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Figtree',
        ),
        hintStyle: TextStyle(
          color: const Color(0xFFE0E0E0),
          fontSize: 14.sp,
          fontFamily: 'Figtree',
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.w),
          borderSide: const BorderSide(color: Color(0xFFF2F2F2), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.w),
          borderSide: const BorderSide(color: Color(0xFF1E74E9), width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
