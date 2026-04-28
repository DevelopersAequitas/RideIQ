import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rideiq/core/constants/app_colors.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/onboarding/viewmodel/splash_viewmodel.dart';
import 'package:rideiq/features/onboarding/view/screens/welcome_screen.dart';
import 'package:rideiq/features/auth/view/screens/user_selection_screen.dart';
import 'package:rideiq/features/auth/view/screens/permission_screen.dart';
import 'package:rideiq/features/paywall/view/screens/paywall_screen.dart';
import 'package:rideiq/features/home/view/screens/main_dashboard_screen.dart';
import 'package:rideiq/core/services/local_service.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for completion in the ViewModel
    ref.listen(splashViewModelProvider, (previous, next) {
      if (next is AsyncData<String>) {
        final step = next.value;
        
        Widget nextScreen;
        switch (step) {
          case AuthSteps.userType:
            nextScreen = const UserSelectionScreen();
            break;
          case AuthSteps.permissions:
            nextScreen = const PermissionScreen();
            break;
          case AuthSteps.paywall:
            nextScreen = const PaywallScreen();
            break;
          case AuthSteps.home:
            nextScreen = const MainDashboardScreen();
            break;
          default:
            nextScreen = const WelcomeScreen();
        }

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => nextScreen),
        );
      }
    });

    final l10n = AppLocalizations.of(context)!;

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
            const Spacer(),
            // Version Info
            Padding(
              padding: EdgeInsets.only(bottom: 40.h),
              child: Text(
                l10n.version_info("0.0.01"),
                style: TextStyle(
                  color: Colors.white.withAlpha(204), // 0.8 * 255
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

