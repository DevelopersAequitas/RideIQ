import 'package:flutter/material.dart';
import 'package:rideiq/core/utils/size_config.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64.h,
      child: ElevatedButton(
        onPressed: (isLoading || onPressed == null)
            ? null
            : () {
                FocusManager.instance.primaryFocus?.unfocus();
                onPressed?.call();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E74E9),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(
            0xFF1E74E9,
          ).withValues(alpha: 0.6),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.w),
            side: BorderSide(color: const Color(0xFF1E74E9), width: 1.w),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.34,
                  letterSpacing: 0.0,
                ),
              ),
      ),
    );
  }
}
