import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_values.dart';

/// Primary [FilledButton.icon] with shared shape and colors.
class AppFilledIconButton extends StatelessWidget {
  const AppFilledIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.backgroundColor = AppColors.primaryColor,
    this.foregroundColor = AppColors.textWhite,
    this.expandWidth = false,
    this.height = AppValues.buttonHeight,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool expandWidth;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final btn = FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.borderRadius),
        ),
      ),
      icon: Icon(icon, color: foregroundColor),
      label: Text(
        label,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: foregroundColor,
        ),
      ),
    );

    Widget w = btn;
    if (height != null) {
      w = SizedBox(height: height, child: w);
    }
    if (expandWidth) {
      w = SizedBox(width: double.infinity, child: w);
    }
    return w;
  }
}
