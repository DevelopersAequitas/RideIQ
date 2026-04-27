import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rideiq/core/utils/size_config.dart';

class OtpInputField extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final int length;

  const OtpInputField({super.key, required this.onCompleted, required this.length});

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String _otp = "";

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    setState(() {}); // Trigger rebuild for green borders
    
    if (value.length == 1 && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    
    _otp = _controllers.map((e) => e.text).join();
    if (_otp.length == widget.length) {
      widget.onCompleted(_otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        final isFilled = _controllers[index].text.isNotEmpty;
        
        return Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: isFilled ? const Color(0xFF4CAF50) : const Color(0xFFE0E0E0), 
              width: 1.2.w,
            ),
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: Center(
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              onChanged: (value) => _onChanged(value, index),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Figtree',
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                counterText: "",
              ),
            ),
          ),
        );
      }),
    );
  }
}
