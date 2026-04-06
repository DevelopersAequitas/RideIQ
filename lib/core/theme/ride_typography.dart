import 'package:flutter/material.dart';

/// Typography matched to the first auth / onboarding reference screen.
abstract final class RideTypography {
  static const Color _onWhite = Color(0xFFFFFFFF);

  /// "RYDE" — bold wordmark (top-left).
  static const TextStyle logoBold = TextStyle(
    color: _onWhite,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.05,
    letterSpacing: 0.4,
  );

  /// "iQ" — regular weight, same optical size as [logoBold].
  static const TextStyle logoLight = TextStyle(
    color: _onWhite,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.05,
    letterSpacing: 0.25,
  );

  /// Tagline under wordmark — clearly subordinate to logo.
  static const TextStyle tagline = TextStyle(
    color: _onWhite,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.12,
  );

  /// "Turn every trip…" hero lines — large, tight leading.
  static const TextStyle headline = TextStyle(
    color: _onWhite,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.06,
    letterSpacing: -0.6,
  );

  /// Primary CTA label — same sans weight scale as headline, control size.
  static const TextStyle buttonLabel = TextStyle(
    color: _onWhite,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.15,
    letterSpacing: -0.2,
  );

  /// Secondary text action — matches button label weight (reference).
  static const TextStyle textLink = TextStyle(
    color: _onWhite,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.15,
    letterSpacing: -0.2,
  );
}
