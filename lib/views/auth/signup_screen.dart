import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rideiq/core/constants/auth_assets.dart';
import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/views/auth/create_account_otp_screen.dart';
import 'package:rideiq/widgets/phone_outline_field.dart';
import 'package:rideiq/widgets/ride_primary_button.dart';

/// Sign up (create account) screen – matched to reference layout.
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  static const double _phoneFieldRadius = 12;
  static const double _bottomGap = 60;

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.paddingOf(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Create Account',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                const Spacer(flex: 2),
                Center(
                  child: Image.asset(
                    AuthAssets.logo,
                    height: 210,
                    fit: BoxFit.contain,
                  ),
                ),
                const Spacer(flex: 2),
                const PhoneOutlineField(
                  width: 342,
                  borderRadius: _phoneFieldRadius,
                ),
                const SizedBox(height: 14),
                Center(
                  child: SizedBox(
                    width: 342,
                    child: RidePrimaryButton(
                      label: 'Send OTP',
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const CreateAccountOtpScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: Text(
                    "We'll send a verification code to your number.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.85),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: _bottomGap + viewPadding.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
