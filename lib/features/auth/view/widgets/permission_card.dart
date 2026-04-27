import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rideiq/core/utils/size_config.dart';

class PermissionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetPath;
  final bool isGranted;
  final VoidCallback onTap;

  const PermissionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.isGranted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFBFBFC),
            borderRadius: BorderRadius.circular(20.w),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                assetPath,
                width: 28.w,
                height: 28.h,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF1E74E9),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'Figtree',
                  ),
                ),
              ),
              CupertinoSwitch(
                value: isGranted,
                onChanged: (_) => onTap(),
                activeTrackColor: const Color(0xFF1E74E9),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black54,
              fontFamily: 'Figtree',
            ),
          ),
        ),
      ],
    );
  }
}
