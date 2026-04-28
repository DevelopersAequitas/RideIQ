import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:rideiq/features/auth/view/widgets/auth_header.dart';
import 'package:rideiq/features/auth/view/widgets/phone_input_field.dart';
import 'package:rideiq/features/auth/view/screens/register_details_screen.dart';
import 'package:rideiq/shared/widgets/primary_button.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class CreateAccountScreen extends ConsumerWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authViewModelProvider);
    final notifier = ref.read(authViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    // Listen for OTP sent state to navigate
    ref.listen(authViewModelProvider.select((s) => s.isOtpSent), (prev, next) {
      if (next && !(prev ?? false)) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const RegisterDetailsScreen()),
        );
      }
    });

    // Listen for errors
    ref.listen(authViewModelProvider.select((s) => s.errorMessage), (prev, next) {
      if (next != null) {
        ElegantNotification.error(
          width: MediaQuery.of(context).size.width * 0.9,
          background: const Color(0xFFFFFBFA), // Very light red/blush
          title: Text(
            l10n.error,
            style: TextStyle(
              color: const Color(0xFFC62828),
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
          ),
          description: Text(
            next,
            style: TextStyle(
              color: const Color(0xFFC62828),
              fontSize: 13.sp,
            ),
          ),
          displayCloseButton: true,
          icon: Icon(
            Icons.error_outline,
            color: const Color(0xFFC62828),
            size: 24.sp,
          ),
        ).show(context);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthHeader(title: l10n.create_account),
              SizedBox(height: 120.h),
              
              PhoneInputField(
                countryCode: state.countryCode,
                onPhoneChanged: notifier.updatePhoneNumber,
                onCountryChanged: notifier.updateCountryCode,
              ),
              
              SizedBox(height: 32.h),
              
              if (!state.isOtpSent)
                PrimaryButton(
                  text: l10n.send_otp,
                  isLoading: state.isLoading,
                  onPressed: notifier.sendOtp,
                )
              else
                // OTP Sent Status Button
                Container(
                  width: double.infinity,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF2FF),
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  child: Center(
                    child: Text(
                      l10n.otp_sent,
                      style: TextStyle(
                        color: const Color(0xFF1E74E9),
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              
              SizedBox(height: 48.h),
              
              Center(
                child: Text(
                  l10n.verification_code_msg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14.sp,
                    fontFamily: 'Figtree',
                  ),
                ),
              ),
            ],
          ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),
        ),
      ),
    );
  }
}

