
import 'package:flutter/material.dart';

import 'package:rideiq/core/theme/app_colors.dart';

/// Outlined phone row: label on border, +00, divider, number field (matches auth reference).
class PhoneOutlineField extends StatefulWidget {
  const PhoneOutlineField({
    super.key,
    required this.width,
    this.controller,
    this.hintText = '0000 0000 00',
    this.label = 'Phone',
    this.borderRadius = 22,
  });

  final double width;
  final TextEditingController? controller;
  final String hintText;
  final String label;
  final double borderRadius;

  @override
  State<PhoneOutlineField> createState() => _PhoneOutlineFieldState();
}

class _PhoneOutlineFieldState extends State<PhoneOutlineField> {
  late final FocusNode _focusNode;

  static const double _h = 52;
  static const double _borderTop = 10;
  static const double _dividerHeight = 26;

  static const _labelStyle = TextStyle(
    color: AppColors.black,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 0.1,
  );

  static const _innerTextStyle = TextStyle(
    color: AppColors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.2,
    decoration: TextDecoration.none,
    decorationThickness: 0,
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

    return Center(
      child: SizedBox(
        width: widget.width,
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
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(color: borderColor, width: borderWidth),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '+00',
                        style: _innerTextStyle.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 14),
                      SizedBox(
                        height: _h,
                        child: Center(
                          child: Container(
                            width: 1,
                            height: _dividerHeight,
                            color: AppColors.borderPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextField(
                          controller: widget.controller,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.phone,
                          autocorrect: false,
                          enableSuggestions: false,
                          spellCheckConfiguration:
                              SpellCheckConfiguration.disabled(),
                          style: _innerTextStyle,
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                            hintStyle: _innerTextStyle.copyWith(
                              color: AppColors.black.withValues(alpha: 0.38),
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
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: _borderTop - labelLift,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                color: AppColors.surface,
                child: Text(widget.label, style: _labelStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
