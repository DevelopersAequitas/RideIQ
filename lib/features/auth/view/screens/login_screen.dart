import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:rideiq/features/auth/view/widgets/auth_header.dart';
import 'package:rideiq/features/auth/view/widgets/phone_input_field.dart';
import 'package:rideiq/features/auth/view/widgets/otp_input_field.dart';
import 'package:rideiq/shared/widgets/primary_button.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/core/utils/notification_utils.dart';
import 'package:rideiq/features/auth/view/screens/user_selection_screen.dart';
import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  String _formatTimer(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authViewModelProvider);
    final notifier = ref.read(authViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    // Listen for authentication success
    ref.listen(authViewModelProvider.select((s) => s.isAuthenticated), (
      prev,
      next,
    ) {
      if (next) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const UserSelectionScreen()),
          (route) => false,
        );
      }
    });

    // Listen for OTP Sent
    ref.listen(authViewModelProvider.select((s) => s.isOtpSent), (prev, next) {
      if (next && !(prev ?? false)) {
        RydeNotification.showSuccess(context, l10n.otp_sent);
      }
    });

    // Listen for errors
    ref.listen(authViewModelProvider.select((s) => s.errorMessage), (
      prev,
      next,
    ) {
      if (next != null) {
        RydeNotification.showError(context, next);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthHeader(title: l10n.login),

              const SizedBox(height: 40),
              PhoneInputField(
                countryCode: state.countryCode,
                onPhoneChanged: notifier.updatePhoneNumber,
                onCountryChanged: notifier.updateCountryCode,
              ),

              const SizedBox(height: 32),

              if (!state.isOtpSent)
                PrimaryButton(
                  text: l10n.send_otp,
                  isLoading: state.isOtpLoading,
                  onPressed: notifier.sendOtp,
                )
              else
                // OTP Sent Status Button
                Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF2FF),
                    borderRadius: BorderRadius.circular(12.w),
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

              const SizedBox(height: 24),
              const Divider(color: Color(0xFFF0F0F0), thickness: 1),
              const SizedBox(height: 24),

              Text(
                l10n.enter_otp,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),

              // OTP Boxes
              OtpInputField(onCompleted: notifier.updateOtp, length: 6),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.resend_otp_in,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTimer(state.resendTimer),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  if (state.resendTimer == 0)
                    TextButton(
                      onPressed: state.isOtpLoading ? null : notifier.sendOtp,
                      child: state.isOtpLoading
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF1E74E9),
                              ),
                            )
                          : Text(
                              l10n.resend,
                              style: const TextStyle(
                                color: Color(0xFF1E74E9),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              PrimaryButton(
                text: l10n.login,
                isLoading: state.isLoginLoading,
                onPressed: state.otp.length == 6 ? notifier.login : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
