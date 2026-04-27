import 'package:flutter/material.dart';
import 'package:rideiq/core/utils/size_config.dart';

class BenefitRow extends StatelessWidget {
  final String text;

  const BenefitRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1A1A1A), // Darker text from image
          fontFamily: 'Figtree',
        ),
      ),
    );
  }
}
