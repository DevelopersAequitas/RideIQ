import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rideiq/core/theme/ride_typography.dart';
import 'package:rideiq/views/auth/login_screen.dart';
import 'package:rideiq/views/auth/signup_screen.dart';
import 'package:rideiq/widgets/ride_primary_button.dart';

/// First screen after splash — layout and type matched to onboarding reference.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  /// Must match filename in `assets/images/` exactly (case-sensitive in builds).
  static const String _heroAsset = 'assets/images/First_Screen_image.jpg';

  static const String _tagline = 'Compare rides. Maximize earnings.';
  static const String _headlineLine1 = 'Turn every trip';
  static const String _headlineLine2 = 'into insight.';

  /// Horizontal inset — reference “generous” side margins (~20pt).
  static const double _hPad = 20;

  /// Image scale: 1.0 = exact device frame, >1.0 = very light zoom-in.
  /// Looser crop so more fingers + face are visible.
  static const double _heroZoom = 1.02;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final scrimHeight = size.height * 0.58;
    final heroW = size.width * _heroZoom;
    final heroH = size.height * _heroZoom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black,
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.center,
                    minWidth: heroW,
                    maxWidth: heroW,
                    minHeight: heroH,
                    maxHeight: heroH,
                    child: Image.asset(
                      _heroAsset,
                      width: heroW,
                      height: heroH,
                      fit: BoxFit.cover,
                      // Shift view further left so peace fingers + full face match reference.
                      alignment: const Alignment(-0.18, 0.02),
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true,
                      errorBuilder: (_, __, ___) => const ColoredBox(
                        color: Color(0xFF2A2A2A),
                        child: Center(
                          child: Icon(Icons.broken_image_outlined, color: Colors.white24, size: 48),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Bottom-only scrim (reference: subtle; top stays bright/clear).
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: scrimHeight,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.35, 0.72, 1.0],
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.28),
                        Colors.black.withOpacity(0.62),
                        Colors.black.withOpacity(0.88),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: _hPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(text: 'RYDE ', style: RideTypography.logoBold),
                          TextSpan(text: 'iQ', style: RideTypography.logoLight),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _tagline,
                      style: RideTypography.tagline.copyWith(
                        color: Colors.white.withOpacity(0.94),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _headlineLine1,
                      style: RideTypography.headline,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _headlineLine2,
                      style: RideTypography.headline,
                    ),
                    const SizedBox(height: 24),
                    RidePrimaryButton(
                      label: 'Log in',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          textStyle: RideTypography.textLink,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          minimumSize: const Size(0, 48),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Sign up'),
                      ),
                    ),
                    SizedBox(height: 20 + bottomInset),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
