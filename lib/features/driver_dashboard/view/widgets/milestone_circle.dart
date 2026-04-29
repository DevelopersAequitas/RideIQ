
import 'dart:math' as math; 

import 'package:flutter/material.dart';
import 'package:rideiq/core/utils/size_config.dart';

class MilestoneArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  MilestoneArcPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 8.w;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Fixed 110-degree gap fits "In Progress" at size 12 perfectly
    const gapAngleRad = 110 * (math.pi / 180);
    const sweepAngleRad = (2 * math.pi) - gapAngleRad;

    // Gap centered exactly at the top (270 degrees)
    const startAngle = (270 * (math.pi / 180)) + (gapAngleRad / 2);

    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngleRad,
      false,
      bgPaint,
    );

    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngleRad * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant MilestoneArcPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
