import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rideiq/core/utils/size_config.dart';

class StatCard extends StatelessWidget {
  final String assetPath;
  final String label;
  final String value;

  const StatCard({
    super.key,
    required this.assetPath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label on top
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF999999),
              fontSize: 12.sp,
              fontFamily: 'Figtree',
            ),
          ),
          SizedBox(height: 10.h), // Reduced gap to fix overflow
          // Icon and Value row
          Row(
            children: [
              assetPath.endsWith('.svg')
                  ? SvgPicture.asset(
                    assetPath,
                    width: 20.w,
                    height: 20.w,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF1D72DD),
                      BlendMode.srcIn,
                    ),
                  )
                  : Image.asset(assetPath, width: 20.w, height: 20.w),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp, // Slightly reduced to ensure fit
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A1A1A),
                    fontFamily: 'Figtree',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
