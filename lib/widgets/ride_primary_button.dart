import 'package:flutter/material.dart';

import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/theme/ride_typography.dart';
import 'package:rideiq/core/ui/ride_responsive.dart';

/// Primary CTA — elevated, shadow, 16px radius, 1px border, 15px padding.
class RidePrimaryButton extends StatelessWidget {
  const RidePrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    this.minimumHeight = 50,
    this.showBorder = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double minimumHeight;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final r = context.r;

    final scaledMinHeight = r.s(minimumHeight).clamp(44.0, 72.0);
    final scaledPadding = switch (padding) {
      final EdgeInsets p => EdgeInsets.fromLTRB(
          r.s(p.left),
          r.s(p.top),
          r.s(p.right),
          r.s(p.bottom),
        ),
      _ => padding,
    };

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: enabled ? 4 : 0,
          shadowColor: AppColors.ctaBlue.withOpacity(0.45),
          surfaceTintColor: Colors.transparent,
          backgroundColor: enabled ? AppColors.ctaBlue : AppColors.ctaBlue.withOpacity(0.45),
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white.withOpacity(0.85),
          disabledBackgroundColor: AppColors.ctaBlue.withOpacity(0.35),
          minimumSize: Size.fromHeight(scaledMinHeight),
          padding: scaledPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(r.s(borderRadius)),
            side: showBorder
                ? BorderSide(
                    color: AppColors.primary3.withOpacity(enabled ? 0.55 : 0.35),
                    width: 1,
                  )
                : BorderSide.none,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: RideTypography.buttonLabel.copyWith(
            color: enabled
                ? RideTypography.buttonLabel.color
                : Colors.white.withOpacity(0.85),
            fontSize: (RideTypography.buttonLabel.fontSize ?? 16) * r.scale,
          ),
        ),
      ),
    );
  }
}
