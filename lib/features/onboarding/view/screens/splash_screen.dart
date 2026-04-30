import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/core/constants/splash_assets.dart';
import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/services/local_service.dart';
import 'package:rideiq/features/onboarding/viewmodel/splash_viewmodel.dart';
import 'package:rideiq/features/onboarding/view/widgets/ryde_splash_gradient.dart';
import 'package:rideiq/features/onboarding/view/screens/welcome_screen.dart';
import 'package:rideiq/features/auth/view/screens/user_selection_screen.dart';
import 'package:rideiq/features/auth/view/screens/permission_screen.dart';
import 'package:rideiq/features/paywall/view/screens/paywall_screen.dart';
import 'package:rideiq/features/home/view/screens/main_dashboard_screen.dart';
import 'package:rideiq/l10n/app_localizations.dart';

/// Brand splash: reference gradient + centered logo + version.
/// Design exact as provided, logic follows MVVM + Riverpod architecture.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Handle one-time side effects
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
      precacheImage(
        const AssetImage(SplashAssets.logo),
        context,
      ).catchError((_) => null);
    });

    // Listen for navigation state from ViewModel
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

        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute<void>(builder: (_) => nextScreen));
      }
    });

    final padding = MediaQuery.paddingOf(context);
    final width = MediaQuery.sizeOf(context).width;
    final logoWidth = math.min(241.0, width * 0.82);
    final logoHeight = math.min(60.0, width * 0.82);
    final l10n = AppLocalizations.of(context)!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.splashGreen,
        body: Stack(
          fit: StackFit.expand,
          children: [
            const RydeSplashGradient(),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(),
                  Center(
                    child: SvgPicture.asset(
                      AppAssets.whiteLogoSvg,
                      width: logoWidth,
                      height: logoHeight,
                      fit: BoxFit.contain,
                      // filterQuality: FilterQuality.high,
                      // gaplessPlayback: true,
                      // errorBuilder: (_, __, ___) =>
                      //     SplashLogoFallback(width: logoWidth),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10 + padding.bottom),
                    child: Text(
                      l10n.version_info('0.0.01'),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.2,
                        height: 1.2,
                      ),
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
