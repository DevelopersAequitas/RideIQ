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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 64.h,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1.w),
            borderRadius: BorderRadius.circular(12.w),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              if (prefix != null) ...[
                prefix!,
                SizedBox(width: 12.w),
                Container(
                  height: 24.h,
                  width: 1.w,
                  color: const Color(0xFFE0E0E0),
                ),
                SizedBox(width: 12.w),
              ],
              Expanded(
                child: TextField(
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
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: const Color(0xFF9E9E9E),
                      fontSize: 16.sp,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (suffix != null) suffix!,
            ],
          ),
        ),
        Positioned(
          left: 12.w,
          top: -8.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            color: Colors.white,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                fontFamily: 'Figtree',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
