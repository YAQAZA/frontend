import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_values.dart';

/// Outlined button with app border radius; optional leading icon + label row.
class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.onPressed,
    this.label,
    this.icon,
    this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 14),
    this.borderColor = AppColors.borderLight,
    this.backgroundColor = AppColors.textWhite,
    this.foregroundColor,
    this.expandWidth = true,
    this.fixedHeight,
  }) : assert(
          child != null || label != null,
          'Provide child or label',
        );

  final VoidCallback? onPressed;
  final String? label;
  final IconData? icon;
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final Color borderColor;
  final Color backgroundColor;
  final Color? foregroundColor;
  final bool expandWidth;
  final double? fixedHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = foregroundColor ?? AppColors.textDark;
    final content = child ??
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: fg),
              SizedBox(width: AppValues.spacingSmall),
            ],
            Flexible(
              child: Text(
                label!,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );

    final button = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: fg,
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.borderRadius),
        ),
        padding: padding,
      ),
      child: content,
    );

    Widget result = button;
    if (fixedHeight != null) {
      result = SizedBox(
        height: fixedHeight,
        width: expandWidth ? double.infinity : null,
        child: result,
      );
    } else if (expandWidth) {
      result = SizedBox(width: double.infinity, child: result);
    }
    return result;
  }
}
