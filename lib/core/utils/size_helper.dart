import 'package:flutter/material.dart';

import '../constants/constants.dart';

/// Responsive size helper using MediaQuery.
/// Use for layout and spacing that should scale with screen size.
class SizeHelper {
  SizeHelper._();

  static Size screenSize(BuildContext context) {
    return MediaQuery.sizeOf(context);
  }

  static double width(BuildContext context) => screenSize(context).width;
  static double height(BuildContext context) => screenSize(context).height;

  static bool isTabletOrLarger(BuildContext context) {
    return width(context) >= AppValues.breakpointTablet;
  }

  static bool isDesktop(BuildContext context) {
    return width(context) >= AppValues.breakpointDesktop;
  }

  /// Horizontal padding for screen edges. Larger on tablet/desktop.
  static double screenPaddingHorizontal(BuildContext context) {
    if (isDesktop(context)) {
      return AppValues.screenPaddingHorizontal * 2;
    }
    if (isTabletOrLarger(context)) {
      return AppValues.screenPaddingHorizontal * 1.5;
    }
    return AppValues.screenPaddingHorizontal;
  }

  /// Top padding for scrollable content (e.g. login screen).
  static double screenPaddingTop(BuildContext context) {
    return height(context) * 0.06;
  }
}
