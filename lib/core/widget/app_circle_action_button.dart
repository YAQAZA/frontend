import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_values.dart';

/// Large circular action (e.g. session start play).
class AppCircleActionButton extends StatelessWidget {
  const AppCircleActionButton({
    super.key,
    required this.onPressed,
    this.enabled = true,
    this.diameter = AppValues.sessionStartButtonDiameter,
    this.icon = Icons.play_arrow,
    this.iconSize = AppValues.sessionStartPlayIconSize,
    this.iconColor = AppColors.textWhite,
    this.backgroundColor = AppColors.primaryColor,
    this.shadowColor,
    this.shadowBlur = AppValues.sessionStartShadowBlur,
    this.shadowOffsetY = AppValues.sessionStartShadowOffsetY,
  });

  final VoidCallback? onPressed;
  final bool enabled;
  final double diameter;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Color backgroundColor;
  final Color? shadowColor;
  final double shadowBlur;
  final double shadowOffsetY;

  @override
  Widget build(BuildContext context) {
    final effectiveShadow = shadowColor ?? backgroundColor.withValues(alpha: 0.25);
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            blurRadius: shadowBlur,
            offset: Offset(0, shadowOffsetY),
            color: effectiveShadow,
          ),
        ],
      ),
      child: IconButton(
        onPressed: enabled ? onPressed : null,
        icon: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}
