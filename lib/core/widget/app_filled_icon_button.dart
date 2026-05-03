import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_values.dart';

/// Primary [FilledButton.icon] with shared shape and colors.
class AppFilledIconButton extends StatelessWidget {
  const AppFilledIconButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
    this.backgroundColor = AppColors.primaryColor,
  });

  final VoidCallback? onTap;
  final Color backgroundColor;
  final String label;
  final IconData? icon;


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppValues.buttonHeight,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppValues.borderRadius)
        ),
        child: Padding(
          padding: const EdgeInsets.only(right:AppValues.spacingXSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.backgroundLight),
              SizedBox(width: AppValues.spacingXSmall),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.backgroundLight,
                      fontWeight: FontWeight.w700
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
