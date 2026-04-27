import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:rideiq/features/auth/view/screens/user_selection_screen.dart';
import 'package:rideiq/features/auth/view/widgets/auth_header.dart';
import 'package:rideiq/features/auth/view/widgets/labeled_input_field.dart';
import 'package:rideiq/features/auth/view/widgets/otp_input_field.dart';
import 'package:rideiq/shared/widgets/primary_button.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RegisterDetailsScreen extends ConsumerWidget {
  const RegisterDetailsScreen({super.key});

  String _formatTimer(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authViewModelProvider);
    final notifier = ref.read(authViewModelProvider.notifier);

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              // Only allow scrolling if the content exceeds the height (e.g. keyboard open)
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 30.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthHeader(title: "Create Account"),
                      SizedBox(height: 28.h),

                      Text(
                        "Enter OTP",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      OtpInputField(onCompleted: notifier.updateOtp, length: 6),

                      SizedBox(height: 16.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Resend OTP in ",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Text(
                                _formatTimer(state.resendTimer),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                          if (state.resendTimer == 0)
                            TextButton(
                              onPressed: notifier.sendOtp,
                              child: Text(
                                "Resend",
                                style: TextStyle(
                                  color: const Color(0xFF1E74E9),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 24.h),
                      const Divider(color: Color(0xFFF0F0F0), thickness: 1),
                      SizedBox(height: 24.h),

                      LabeledInputField(
                        label: "First name",
                        hint: "Placeholder...",
                        onChanged: notifier.updateFirstName,
                      ),
                      SizedBox(height: 12.h),

                      LabeledInputField(
                        label: "Last name",
                        hint: "Placeholder...",
                        onChanged: notifier.updateLastName,
                      ),
                      SizedBox(height: 12.h),

                      LabeledInputField(
                        label: "Email (Optional)",
                        hint: "Email (Optional)",
                        onChanged: notifier.updateEmail,
                        hasLabelOnBorder: false,
                      ),

                      SizedBox(height: 32.h),

                      PrimaryButton(
                        text: "Confirm",
                        isLoading: state.isLoading,
                        onPressed: state.otp.length == 6 ? () async {
                          await notifier.login();
                          await notifier.completeRegistration(); // Save step
                          if (context.mounted) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const UserSelectionScreen(),
                              ),
                            );
                          }
                        } : null,
                      ),

                      SizedBox(height: 20.h),

                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13.sp,
                              height: 1.5,
                              fontFamily: 'Figtree',
                            ),
                            children: const [
                              TextSpan(
                                text: "By Clicking Confirm, I agree to\n",
                              ),
                              TextSpan(
                                text: "Terms & Conditions",
                                style: TextStyle(
                                  color: Color(0xFF1E74E9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(text: " and "),
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(
                                  color: Color(0xFF1E74E9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
