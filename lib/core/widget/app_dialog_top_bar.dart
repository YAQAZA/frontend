import 'package:flutter/material.dart';

import '../constants/app_values.dart';

/// Colored strip at the top of a dialog (e.g. alert severity accent).
class AppDialogTopBar extends StatelessWidget {
  const AppDialogTopBar({
    super.key,
    required this.color,
    this.height = 28,
    this.borderRadius = AppValues.cardRadius,
  });

  final Color color;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius),
        ),
      ),
    );
  }
}
