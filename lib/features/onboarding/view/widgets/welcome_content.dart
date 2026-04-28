import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/features/onboarding/viewmodel/welcome_viewmodel.dart';
import 'package:rideiq/features/auth/view/screens/login_screen.dart';
import 'package:rideiq/features/auth/view/screens/create_account_screen.dart';
import 'package:rideiq/shared/widgets/primary_button.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class WelcomeContent extends ConsumerWidget {
  const WelcomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(welcomeViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Logo
          SvgPicture.asset(
            AppAssets.whiteLogoSvg,
            width: 100.w,
          ),
          
          const Spacer(),
          
          // Main Headline
          Text(
            l10n.welcome_title,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Figtree',
              fontSize: 46.sp,
              fontWeight: FontWeight.w600,
              height: 1.0,
              letterSpacing: -0.46,
            ),
          ),
          
          SizedBox(height: 40.h),
          
          // Buttons
          PrimaryButton(
            text: l10n.welcome_login,
            onPressed: () {
              viewModel.onLoginPressed();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
          
          SizedBox(height: 16.h),
          
          Center(
            child: TextButton(
              onPressed: () {
                viewModel.onSignUpPressed();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
                );
              },
              child: Text(
                l10n.welcome_signup,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.34,
                  letterSpacing: 0.0,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

