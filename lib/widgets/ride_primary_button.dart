import 'package:flutter/material.dart';

import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/theme/ride_typography.dart';

/// Primary CTA — elevated, shadow, 16px radius, 1px border, 15px padding.
class RidePrimaryButton extends StatelessWidget {
  const RidePrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.borderRadius = 16,
  });

  final String label;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

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
          minimumSize: const Size.fromHeight(50),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: AppColors.primary3.withOpacity(enabled ? 0.55 : 0.35),
              width: 1,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: RideTypography.buttonLabel.copyWith(
            color: enabled
                ? RideTypography.buttonLabel.color
                : Colors.white.withOpacity(0.85),
          ),
        ),
      ),
    );
  }
}
