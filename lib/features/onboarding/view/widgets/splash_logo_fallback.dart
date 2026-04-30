import 'package:flutter/material.dart';

/// If [SplashAssets.logo] fails to load, approximate the reference wordmark.
class SplashLogoFallback extends StatelessWidget {
  const SplashLogoFallback({super.key, required this.width});

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
