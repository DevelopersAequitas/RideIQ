import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:rideiq/core/constants/splash_assets.dart';
import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/views/onboarding/welcome_screen.dart';

/// Brand splash: reference gradient + centered logo + version, then [WelcomeScreen].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const Duration _displayDuration = Duration(milliseconds: 3200);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runSplashFlow());
  }

  Future<void> _runSplashFlow() async {
    if (!mounted) return;
    final ctx = context;

    try {
      await precacheImage(AssetImage(SplashAssets.logo), ctx);
    } catch (_) {}

    if (!mounted) return;
    FlutterNativeSplash.remove();

    await Future<void>.delayed(SplashScreen._displayDuration);
    if (!mounted) return;

    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final width = MediaQuery.sizeOf(context).width;
    final logoWidth = math.min(340.0, width * 0.82);

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
            const _RydeSplashGradient(),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(),
                  Center(
                    child: Image.asset(
                      SplashAssets.logo,
                      width: logoWidth,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true,
                      errorBuilder: (_, __, ___) => _SplashLogoFallback(width: logoWidth),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10 + padding.bottom),
                    child: Text(
                      'Version 0.0.01',
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

/// Vertical green → blue base, then bottom band blends blue (left) → teal (right).
class _RydeSplashGradient extends StatelessWidget {
  const _RydeSplashGradient();

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
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.white,
              ],
              stops: const [0.0, 0.38, 1.0],
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

/// If [SplashAssets.logo] fails to load, approximate the reference wordmark.
class _SplashLogoFallback extends StatelessWidget {
  const _SplashLogoFallback({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                height: 1.1,
                letterSpacing: 0.5,
              ),
              children: [
                TextSpan(text: 'RYDE '),
                TextSpan(
                  text: 'iQ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Compare rides. Maximize earnings.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.35,
              letterSpacing: 0.15,
            ),
          ),
        ],
      ),
    );
  }
}
