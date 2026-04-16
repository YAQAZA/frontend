import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_values.dart';

/// White (or custom) surface with rounded corners; optional border.
class AppSurfaceCard extends StatelessWidget {
  const AppSurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppValues.spacingMedium),
    this.showBorder = false,
    this.borderColor = AppColors.borderLight,
    this.borderRadius = AppValues.cardRadius,
    this.color = AppColors.textWhite,
    this.width = double.infinity,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool showBorder;
  final Color borderColor;
  final double borderRadius;
  final Color color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }
}
