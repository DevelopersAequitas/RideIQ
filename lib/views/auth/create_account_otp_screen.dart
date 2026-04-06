import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rideiq/core/constants/auth_assets.dart';
import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/views/onboarding/role_selection_screen.dart';
import 'package:rideiq/widgets/otp_digit_box.dart';
import 'package:rideiq/widgets/ride_primary_button.dart';

/// OTP entry, profile fields, and confirm — matches post–Send OTP reference.
class CreateAccountOtpScreen extends StatefulWidget {
  const CreateAccountOtpScreen({super.key});

  @override
  State<CreateAccountOtpScreen> createState() => _CreateAccountOtpScreenState();
}

class _CreateAccountOtpScreenState extends State<CreateAccountOtpScreen> {
  static const double _logoH = 202;
  static const double _horizontalPad = 24;
  /// Gap between OTP cells (left-aligned row).
  static const double _otpGap = 10;

  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocus = List.generate(4, (_) => FocusNode());

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;

  Timer? _resendTimer;
  int _secondsLeft = 49;

  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();

    _termsTap = TapGestureRecognizer()..onTap = () {};
    _privacyTap = TapGestureRecognizer()..onTap = () {};

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        }
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
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocus) {
      f.dispose();
    }
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _termsTap.dispose();
    _privacyTap.dispose();
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
    final contentW =
        MediaQuery.sizeOf(context).width - (_horizontalPad * 2);
    final linkStyle = TextStyle(
      color: AppColors.ctaBlue,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.4,
    );
    final footerGrey = TextStyle(
      color: AppColors.textSecondary.withOpacity(0.9),
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
                  'Create Account',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: Image.asset(
                    AuthAssets.logo,
                    height: _logoH,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
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
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      for (var i = 0; i < 4; i++) ...[
                        if (i > 0) const SizedBox(width: _otpGap),
                        OtpDigitBox(
                          controller: _otpControllers[i],
                          focusNode: _otpFocus[i],
                          onChanged: (v) => _onOtpChanged(i, v),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                SizedBox(
                  width: contentW,
                  child: Text.rich(
                    TextSpan(
                      style: footerGrey,
                      children: [
                        const TextSpan(text: 'Resend OTP in '),
                        TextSpan(
                          text:
                              '${_twoDigits(_secondsLeft ~/ 60)}:${_twoDigits(_secondsLeft % 60)}',
                          style: footerGrey.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 35),
                Divider(height: 1, thickness: 1, color: AppColors.borderPrimary),
                const SizedBox(height: 30),
                SizedBox(
                  width: contentW,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                        _OutlinedGreyLabelField(
                          label: 'First name',
                          hint: 'Placeholder...',
                          controller: _firstNameController,
                        ),
                        const SizedBox(height: 14),
                        _OutlinedGreyLabelField(
                          label: 'Last name',
                          hint: 'Placeholder...',
                          controller: _lastNameController,
                        ),
                        const SizedBox(height: 14),
                        _EmailOptionalField(controller: _emailController),
                        const SizedBox(height: 25),
                        RidePrimaryButton(
                          label: 'Confirm',
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (_) => const RoleSelectionScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'By Clicking Confirm, I agree to',
                              textAlign: TextAlign.center,
                              style: footerGrey,
                            ),
                            const SizedBox(height: 2),
                            Text.rich(
                              TextSpan(
                                style: footerGrey,
                                children: [
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: linkStyle,
                                    recognizer: _termsTap,
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: linkStyle,
                                    recognizer: _privacyTap,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                    ],
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

class _OutlinedGreyLabelField extends StatefulWidget {
  const _OutlinedGreyLabelField({
    required this.label,
    required this.hint,
    required this.controller,
  });

  final String label;
  final String hint;
  final TextEditingController controller;

  @override
  State<_OutlinedGreyLabelField> createState() => _OutlinedGreyLabelFieldState();
}

class _OutlinedGreyLabelFieldState extends State<_OutlinedGreyLabelField> {
  late final FocusNode _focusNode;

  static const double _h = 52;
  static const double _borderTop = 10;
  static const double _radius = 12;

  static const _labelStyle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.0,
  );

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const labelLift = 6.5;
    final focused = _focusNode.hasFocus;
    final borderColor = focused ? AppColors.borderDark : AppColors.borderPrimary;
    final borderWidth = focused ? 1.5 : 1.0;

    return SizedBox(
      height: _borderTop + _h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topLeft,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: _borderTop,
            height: _h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(_radius),
                border: Border.all(color: borderColor, width: borderWidth),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    autocorrect: false,
                    enableSuggestions: false,
                    spellCheckConfiguration:
                        SpellCheckConfiguration.disabled(),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      decoration: TextDecoration.none,
                      decorationThickness: 0,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.85),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      isDense: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isCollapsed: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 14,
            top: _borderTop - labelLift,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              color: AppColors.surface,
              child: Text(widget.label, style: _labelStyle),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailOptionalField extends StatefulWidget {
  const _EmailOptionalField({required this.controller});

  final TextEditingController controller;

  @override
  State<_EmailOptionalField> createState() => _EmailOptionalFieldState();
}

class _EmailOptionalFieldState extends State<_EmailOptionalField> {
  late final FocusNode _focusNode;

  static const double _h = 52;
  static const double _radius = 12;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focusNode.hasFocus;
    final borderColor = focused ? AppColors.borderDark : AppColors.borderPrimary;
    final borderWidth = focused ? 1.5 : 1.0;

    return SizedBox(
      height: _h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(_radius),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Center(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              enableSuggestions: true,
              spellCheckConfiguration:
                  SpellCheckConfiguration.disabled(),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.2,
                decoration: TextDecoration.none,
                decorationThickness: 0,
              ),
              decoration: InputDecoration(
                hintText: 'Email (Optional)',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.85),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isCollapsed: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
