import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/core/theme/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;

  const AuthHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Updated for centering
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            title,
            // textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.28,
              letterSpacing: 0.0,
            ),
          ),
        ),
        SizedBox(height: 120.h),
        Center(
          child: Column(
            children: [SvgPicture.asset(AppAssets.logoSvg, width: 160.w)],
          ),
        ),
        SizedBox(height: 100.h),
      ],
    );
  }
}
