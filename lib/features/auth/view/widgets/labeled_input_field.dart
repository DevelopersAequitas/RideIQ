import 'package:flutter/material.dart';

class LabeledInputField extends StatelessWidget {
  final String label;
  final String hint;
  final ValueChanged<String> onChanged;
  final bool hasLabelOnBorder;

  const LabeledInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.onChanged,
    this.hasLabelOnBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 64,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ),
        if (hasLabelOnBorder)
          Positioned(
            left: 14,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              color: Colors.white,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
