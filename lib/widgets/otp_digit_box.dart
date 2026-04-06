import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rideiq/core/theme/app_colors.dart';

/// Single OTP cell: green border, light fill, centered dot / caret (matches auth reference).
class OtpDigitBox extends StatefulWidget {
  const OtpDigitBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.borderRadius = 10,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final double borderRadius;

  @override
  State<OtpDigitBox> createState() => _OtpDigitBoxState();
}

class _OtpDigitBoxState extends State<OtpDigitBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursorAnim;
  late Animation<double> _cursorOpacity;

  static const double boxSize = 52;
  static const Color fill = Color(0xFFF5F6F8);

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _cursorAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 530),
    )..repeat(reverse: true);
    _cursorOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(_cursorAnim);

    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = widget.focusNode.hasFocus);
    if (widget.focusNode.hasFocus) {
      _cursorAnim.repeat(reverse: true);
    } else {
      _cursorAnim.stop();
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    _cursorAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = widget.controller.text.isEmpty;
    final showCursorOverlay = _isFocused && isEmpty;

    return GestureDetector(
      onTap: () => widget.focusNode.requestFocus(),
      child: SizedBox(
        width: boxSize,
        height: boxSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _isFocused
                  ? AppColors.primary2
                  : AppColors.primary2.withOpacity(0.6),
              width: _isFocused ? 1.6 : 1.2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  maxLength: 1,
                  obscureText: false,
                  showCursor: false,
                  autocorrect: false,
                  enableSuggestions: false,
                  spellCheckConfiguration:
                      SpellCheckConfiguration.disabled(),
                  style: const TextStyle(
                    color: Colors.transparent,
                    fontSize: 1,
                    height: 1.0,
                    decoration: TextDecoration.none,
                    decorationThickness: 0,
                  ),
                  strutStyle: const StrutStyle(
                    fontSize: 1,
                    height: 1.0,
                    forceStrutHeight: true,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    filled: true,
                    fillColor: Colors.transparent,
                    isDense: true,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: widget.onChanged,
                ),
              ),
              if (!isEmpty)
                IgnorePointer(
                  child: Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              if (showCursorOverlay)
                IgnorePointer(
                  child: Center(
                    child: FadeTransition(
                      opacity: _cursorOpacity,
                      child: Container(
                        width: 1.5,
                        height: 22,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
