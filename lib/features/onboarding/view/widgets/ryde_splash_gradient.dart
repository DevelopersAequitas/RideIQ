import 'package:flutter/material.dart';
import 'package:rideiq/core/theme/app_colors.dart';

/// Vertical green → blue base, then bottom band blends blue (left) → teal (right).
class RydeSplashGradient extends StatelessWidget {
  const RydeSplashGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.splashGreen,
                AppColors.splashGreen,
                AppColors.splashBlue,
              ],
              stops: [0.0, 0.36, 1.0],
            ),
          ),
        ),
        ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.white,
              ],
              stops: [0.0, 0.38, 1.0],
            ).createShader(bounds);
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.splashBlue,
                  AppColors.splashTeal,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
