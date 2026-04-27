import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/shared/widgets/primary_button.dart';
import 'package:rideiq/features/auth/view/widgets/otp_input_field.dart';
import 'package:rideiq/features/profile/view/screens/link_syncing_screen.dart';
import 'package:rideiq/features/profile/viewmodel/link_viewmodel.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LinkVerificationScreen extends ConsumerWidget {
  final String platformName;
  final String phoneNumber;
  final bool isDriverMode;

  const LinkVerificationScreen({
    super.key,
    required this.platformName,
    required this.phoneNumber,
    required this.isDriverMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(linkViewModelProvider);
    final notifier = ref.read(linkViewModelProvider.notifier);

    final isUber = platformName.toLowerCase() == "uber";
    final logoAsset = isUber ? AppAssets.uberLogoPng : AppAssets.lyftLogoPng;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Link Platform",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),

              // 1. Platform Branding
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.sp),
                    child: Container(
                      height: 54.w,
                      width: 54.w,
                      color: isUber ? Colors.black : const Color(0xFFFF00BF),
                      // padding: EdgeInsets.all(14.w),
                      child: Image.asset(logoAsset, fit: BoxFit.contain),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Text(
                    platformName,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
              ).animate().fade().slideX(begin: -0.1),

              SizedBox(height: 40.h),

              // 2. Simple Instruction
              Text(
                "Enter verification code",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF999999),
                  fontFamily: 'Figtree',
                ),
              ).animate().fade(delay: 100.ms),

              SizedBox(height: 16.h),

              // 3. OTP Input
              Center(
                child: OtpInputField(length: 6, onCompleted: notifier.updateOtp)
                    .animate()
                    .fade(delay: 200.ms)
                    .scale(begin: const Offset(0.95, 0.95)),
              ),

              SizedBox(height: 32.h),

              // 4. Action Button
              PrimaryButton(
                text: "Verify",
                isLoading: state.isLoading,
                onPressed: state.isOtpValid
                    ? () {
                        notifier.handleConfirm().then((success) {
                          if (success && context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LinkSyncingScreen(
                                  platformName: platformName,
                                  isDriverMode: isDriverMode,
                                ),
                              ),
                            );
                          }
                        });
                      }
                    : null,
              ).animate().fade(delay: 300.ms).scale(),

              SizedBox(height: 24.h),

              // 5. Resend Logic
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: RichText(
                    text: TextSpan(
                      text: "Didn't receive the code? ",
                      style: TextStyle(
                        color: const Color(0xFF999999),
                        fontSize: 14.sp,
                        fontFamily: 'Figtree',
                      ),
                      children: [
                        TextSpan(
                          text: "Resend",
                          style: TextStyle(
                            color: const Color(0xFF1D72DD),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // 6. Security Footer
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: const Color(0xFF999999),
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      "We only read earnings data. We never modify your account.",
                      style: TextStyle(
                        color: const Color(0xFF999999),
                        fontSize: 13.sp,
                        fontFamily: 'Figtree',
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ).animate().fade(delay: 400.ms),

              SizedBox(height: 40.h), // Added bottom padding instead of Spacer
            ],
          ),
        ),
      ),
    );
  }
}
