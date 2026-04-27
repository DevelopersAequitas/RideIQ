import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rideiq/core/constants/app_colors.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/onboarding/viewmodel/splash_viewmodel.dart';
import 'package:rideiq/features/onboarding/view/screens/welcome_screen.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for completion in the ViewModel
    ref.listen(splashViewModelProvider, (previous, next) {
      if (next is AsyncData) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.splashTop, AppColors.splashBottom],
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            // Logo
            SvgPicture.asset(AppAssets.whiteLogoSvg, width: 220.w),
            SizedBox(height: 12.h),
            // Tagline
            // Text(
            //   "Compare rides. Maximize earnings.",
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 14.sp,
            //     fontWeight: FontWeight.w400,
            //     fontFamily: 'Figtree',
            //   ),
            // ),
            const Spacer(),
            // Version Info
            Padding(
              padding: EdgeInsets.only(bottom: 40.h),
              child: Text(
                "Version 0.0.01",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Figtree',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
