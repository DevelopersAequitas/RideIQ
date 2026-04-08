import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Small responsive helper for consistent sizing across mobile/tablet/desktop/web.
class RideResponsive {
  RideResponsive._(this.size);

  final Size size;

  static RideResponsive of(BuildContext context) =>
      RideResponsive._(MediaQuery.sizeOf(context));

  bool get isCompact => size.width < 600;
  bool get isMedium => size.width >= 600 && size.width < 1024;
  bool get isExpanded => size.width >= 1024;

  /// Constrain page content on wide screens.
  double get contentMaxWidth => isExpanded ? 560 : double.infinity;

  static const double _baseWidth = 390;

  /// Gentle scaling for spacing/type. Clamped to avoid huge desktop UI.
  double get scale {
    final raw = size.width / _baseWidth;
    return raw.clamp(0.88, 1.15);
  }

  double s(double v) => v * scale;

  double hClamp(double preferred, {double min = 0, double? max}) {
    final upper = max ?? size.height;
    return preferred.clamp(min, math.max(min, upper)).toDouble();
  }
}

extension RideResponsiveContextX on BuildContext {
  RideResponsive get r => RideResponsive.of(this);
}

