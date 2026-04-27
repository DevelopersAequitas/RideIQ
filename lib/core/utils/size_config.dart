// ignore_for_file: unused_field

import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double _blockSizeHorizontal;
  static late double _blockSizeVertical;

  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    _blockSizeHorizontal = screenWidth / 100;
    _blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }

  static double setWidth(double width) {
    // Assuming 390 is our design base width
    return (width / 390.0) * screenWidth;
  }

  static double setHeight(double height) {
    // Assuming 844 is our design base height
    return (height / 844.0) * screenHeight;
  }

  static double setSp(double fontSize) {
    return (fontSize / 390.0) * screenWidth;
  }
}

extension ResponsiveSize on num {
  double get w => SizeConfig.setWidth(toDouble());
  double get h => SizeConfig.setHeight(toDouble());
  double get sp => SizeConfig.setSp(toDouble());
}
