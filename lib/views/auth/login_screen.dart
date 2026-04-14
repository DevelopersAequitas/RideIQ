import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rideiq/core/constants/auth_assets.dart';
import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/views/onboarding/role_selection_screen.dart';
import 'package:rideiq/widgets/otp_digit_box.dart';
import 'package:rideiq/widgets/phone_outline_field.dart';
import 'package:rideiq/widgets/ride_primary_button.dart';

/// Login with phone + OTP — layout matched to reference (logo from asset only; no tagline Text).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const double _logoH = 200;
  static const double _horizontalPad = 24;
  static const double _otpGap = 10;
  static const double _phoneRadius = 12;
  static const double _otpCellRadius = 8;
  static const double _bannerRadius = 8;
  static const double _ctaRadius = 12;

  final _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocus = List.generate(4, (_) => FocusNode());

  Timer? _resendTimer;
  int _secondsLeft = 49;

  @override
  void initState() {
    super.initState();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 0) _secondsLeft--;
      });
    });

    for (var i = 0; i < 4; i++) {
      _otpFocus[i].addListener(() {
        if (_otpFocus[i].hasFocus) {
          _otpControllers[i].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _otpControllers[i].text.length,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _phoneController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocus) {
      f.dispose();
    }
    super.dispose();
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  void _onOtpChanged(int index, String value) {
    final digit = value.replaceAll(RegExp(r'\D'), '');
    if (digit.isEmpty) {
      _otpControllers[index].text = '';
      setState(() {});
      return;
    }
    final char = digit.substring(digit.length - 1);
    _otpControllers[index].text = char;
    if (index < 3) {
      _otpFocus[index + 1].requestFocus();
    } else {
      _otpFocus[index].unfocus();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.paddingOf(context);
    final contentW = MediaQuery.sizeOf(context).width - (_horizontalPad * 2);

    final timerGrey = TextStyle(
      color: AppColors.textSecondary.withValues(alpha: 0.9),
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.4,
    );

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
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              _horizontalPad,
              8,
              _horizontalPad,
              12 + viewPadding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Login',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    height: 4,
                  ),
                ),
                const SizedBox(height: 64),
                Center(
                  child: Image.asset(
                    AuthAssets.logo,
                    height: _logoH,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                PhoneOutlineField(
                  width: contentW,
                  controller: _phoneController,
                  borderRadius: _phoneRadius,
                ),
                const SizedBox(height: 22),
                _OtpSentBanner(width: contentW, borderRadius: _bannerRadius),
                const SizedBox(height: 34),
                Divider(height: 1, thickness: 1, color: AppColors.borderPrimary),
                const SizedBox(height: 28),
                Text(
                  'Enter OTP',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: contentW,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (var i = 0; i < 4; i++) ...[
                        if (i > 0) const SizedBox(width: _otpGap),
                        OtpDigitBox(
                          controller: _otpControllers[i],
                          focusNode: _otpFocus[i],
                          borderRadius: _otpCellRadius,
                          onChanged: (v) => _onOtpChanged(i, v),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: contentW,
                  child: Text.rich(
                    TextSpan(
                      style: timerGrey,
                      children: [
                        const TextSpan(text: 'Resend OTP in '),
                        TextSpan(
                          text:
                              '${_twoDigits(_secondsLeft ~/ 60)}:${_twoDigits(_secondsLeft % 60)}',
                          style: timerGrey.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: contentW,
                  child: RidePrimaryButton(
                    label: 'Login',
                    borderRadius: _ctaRadius,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const RoleSelectionScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Status chip after OTP is sent (reference: light blue tint, blue label).
class _OtpSentBanner extends StatelessWidget {
  const _OtpSentBanner({
    required this.width,
    required this.borderRadius,
  });

  final double width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          child: Text(
            'OTP Sent',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.ctaBlue,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 2.5,
            ),
          ),
        ),
      ),
    );
  }
}
