import 'package:flutter/material.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/core/constants/app_assets.dart';

class PlatformLinkCard extends StatelessWidget {
  final String name;
  final bool isConnected;
  final VoidCallback onLinkTap;

  const PlatformLinkCard({
    super.key,
    required this.name,
    required this.isConnected,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUber = name == "Uber";

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.w),
        border: Border.all(color: const Color(0xFFF2F2F2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo Container
          ClipRRect(
            borderRadius: BorderRadius.circular(30.sp),
            child: Container(
              height: 54.w,
              width: 54.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
              ),
              child: Center(
                child: Image.asset(
                  isUber ? AppAssets.uberLogoPng : AppAssets.lyftLogoPng,

                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(width: 20.w),

          // Name & Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                    fontFamily: 'Figtree',
                  ),
                ),
                SizedBox(height: 4.h),
                if (isConnected)
                  Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: const Color(0xFF4CAF50),
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "Connected",
                        style: TextStyle(
                          color: const Color(0xFF4CAF50),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    "Not Linked",
                    style: TextStyle(
                      color: const Color(0xFF999999),
                      fontSize: 13.sp,
                      fontFamily: 'Figtree',
                    ),
                  ),
              ],
            ),
          ),

          // Link Button
          if (!isConnected)
            GestureDetector(
              onTap: onLinkTap,
              child: Text(
                "Link",
                style: TextStyle(
                  color: const Color(0xFF1D72DD),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Figtree',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
