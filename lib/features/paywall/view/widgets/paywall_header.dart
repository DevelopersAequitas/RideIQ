import 'package:flutter/material.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rideiq/core/constants/app_assets.dart';

class PaywallHeader extends StatelessWidget {
  const PaywallHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const double cardHeight = 100.0; // Fixed base height for calculation

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // 1. Header Section
        Container(
          height: 350.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF00C896), // Figma Green
                Color(0xFF1A6FD4), // Figma Blue
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                SvgPicture.asset(
                  AppAssets.whiteLogoSvg,
                  width: 140.w,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(height: 40.h),
                Text(
                  "Start saving more\non every ride",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                    fontFamily: 'Figtree',
                  ),
                ).animate().fade().scale(delay: 200.ms),
                SizedBox(height: 15.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.w),
                  child: Text(
                    "Compare fares and track earnings across platforms. all in one place.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      height: 1.4,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Wavy Edge
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            size: Size(double.infinity, 20.h),
            painter: WavePainter(),
          ),
        ),

        // 2. Floating Card (Positioned half-off)
        Positioned(
          bottom: -(cardHeight.h / 2),
          child: Container(
            height: cardHeight.h,
            width: 290.w, // Approx 85% of standard 390 width
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "7-Day Free Trial",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Figtree',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "No charges today. Cancel anytime.",
                  style: TextStyle(
                    color: const Color(0xFF1D72DD),
                    fontSize: 12.sp,
                    fontFamily: 'Figtree',
                  ),
                ),
              ],
            ),
          ).animate().shimmer(delay: 1.seconds, duration: 1.5.seconds),
        ),
      ],
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path = Path()..moveTo(0, size.height);
    double waveWidth = 12.w;
    double waveHeight = 6.h;

    for (double i = 0; i <= size.width; i += waveWidth) {
      path.quadraticBezierTo(
        i + (waveWidth / 2),
        size.height - waveHeight,
        i + waveWidth,
        size.height,
      );
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
