import 'package:flutter/material.dart';

import '../constants/app_values.dart';

/// Material [Dialog] with app border radius and optional background.
class AppRoundedDialog extends StatelessWidget {
  const AppRoundedDialog({
    super.key,
    required this.child,
    this.borderRadius,
    this.backgroundColor = Colors.white,
    this.insetPadding = const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
  });

  final Widget child;
  final double? borderRadius;
  final Color backgroundColor;
  final EdgeInsets insetPadding;

  @override
  Widget build(BuildContext context) {
    final r = borderRadius ?? AppValues.borderRadius;
    return Dialog(
      insetPadding: insetPadding,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(r),
      ),
      child: child,
    );
  }
}
