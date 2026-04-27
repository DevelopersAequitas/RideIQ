import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:rideiq/features/auth/view/widgets/auth_header.dart';
import 'package:rideiq/features/auth/view/widgets/phone_input_field.dart';
import 'package:rideiq/features/auth/view/widgets/otp_input_field.dart';
import 'package:rideiq/features/home/view/screens/main_dashboard_screen.dart';
import 'package:rideiq/shared/widgets/primary_button.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:elegant_notification/elegant_notification.dart';

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

    // Listen for authentication success
    ref.listen(authViewModelProvider.select((s) => s.isAuthenticated), (
      prev,
      next,
    ) {
      if (next) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainDashboardScreen()),
          (route) => false,
        );
      }
    });

    // Listen for errors
    ref.listen(authViewModelProvider.select((s) => s.errorMessage), (
      prev,
      next,
    ) {
      if (next != null) {
        ElegantNotification.error(
          width: 380.w,
          height: 100.h,
          title: const Text("Error"),
          description: Text(next),
          displayCloseButton: true,
        ).show(context);
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
              const AuthHeader(title: "Login"),

              const SizedBox(height: 100),
              PhoneInputField(
                countryCode: state.countryCode,
                onPhoneChanged: notifier.updatePhoneNumber,
                onCountryChanged: notifier.updateCountryCode,
              ),

              const SizedBox(height: 32),

              if (!state.isOtpSent)
                PrimaryButton(
                  text: "Send OTP",
                  isLoading: state.isLoading,
                  onPressed: notifier.sendOtp,
                )
              else ...[
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
                      "OTP Sent",
                      style: TextStyle(
                        color: const Color(0xFF1E74E9),
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),
                const Divider(color: Color(0xFFF0F0F0), thickness: 1),
                const SizedBox(height: 48),

                const Text(
                  "Enter OTP",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
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
                        const Text(
                          "Resend OTP in ",
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                        ),
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
                        onPressed: notifier.sendOtp,
                        child: const Text(
                          "Resend",
                          style: TextStyle(
                            color: Color(0xFF1E74E9),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 40),

                PrimaryButton(
                  text: "Login",
                  isLoading: state.isLoading,
                  onPressed: state.otp.length == 6 ? notifier.login : null,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
