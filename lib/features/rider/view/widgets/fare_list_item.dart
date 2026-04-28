import 'package:flutter/material.dart'; 
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/rider/model/fare_result.dart';
import 'package:rideiq/features/rider_redirect/view/platform_redirect_screen.dart';

class FareListItem extends StatelessWidget {
  final FareResult fare;

  const FareListItem({super.key, required this.fare});

  @override
  Widget build(BuildContext context) {
    final isUber = fare.platform == "Uber" || fare.platform == "Ayro"; // Fallback Ayro to Uber logo for now
    final logoAsset = isUber ? AppAssets.uberLogoPng : AppAssets.lyftLogoPng;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlatformRedirectScreen(
              platformName: fare.platform,
              logoAsset: logoAsset,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.w),
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
            // Logo
            ClipRRect(
              borderRadius: BorderRadius.circular(30.sp),
              child: Container(
                height: 48.w,
                width: 48.w,
                color: isUber ? Colors.black : const Color(0xFFFF00BF),
                padding: EdgeInsets.all(12.w),
                child: Image.asset(
                  logoAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Text(
                    fare.platform.substring(0, 1),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fare.platform,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF999999),
                      fontFamily: 'Figtree',
                    ),
                  ),
                  Text(
                    fare.rideType,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
              ),
            ),

            // Price & ETA
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "\$${fare.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    fontFamily: 'Figtree',
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.access_time, color: const Color(0xFF999999), size: 14.sp),
                    SizedBox(width: 4.w),
                    Text(
                      "${fare.etaMinutes} min",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF999999),
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
