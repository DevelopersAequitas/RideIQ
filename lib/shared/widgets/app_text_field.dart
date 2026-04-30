import 'package:flutter/material.dart';
import 'package:rideiq/core/utils/size_config.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.onChanged,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        fontFamily: 'Figtree',
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: const Color(0xFF9E9E9E),
          fontSize: 14.sp,
          fontFamily: 'Figtree',
        ),
        floatingLabelStyle: TextStyle(
          color: const Color(0xFF1A1A1A),
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          fontFamily: 'Figtree',
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: const Color(0xFF9E9E9E),
          fontSize: 14.sp,
        ),
        prefixIcon: prefix != null
            ? Padding(
                padding: EdgeInsets.only(left: 16.w, right: 12.w),
                child: prefix,
              )
            : null,
        suffixIcon: suffix != null
            ? Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: suffix,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.w),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.w),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.w),
          borderSide: const BorderSide(color: Color(0xFF1A6FD4), width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      ),
    );
  }
}
