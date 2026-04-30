import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/utils/size_config.dart';

class RecentLocationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const RecentLocationItem({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          // borderRadius: BorderRadius.circular(16.w),
          // border: Border.all(color: const Color(0xFFF2F2F2)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              // decoration: const BoxDecoration(
              //   color: Color(0xFFF0F7FF),
              //   shape: BoxShape.circle,
              // ),
              child: SvgPicture.asset(
                AppAssets.mapPinSvg,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF1D72DD),
                  BlendMode.srcIn,
                ),
                width: 20.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                      fontFamily: 'Figtree',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF999999),
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
