import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_values.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
    this.foregroundColor = AppColors.primaryColor,
  });

  final VoidCallback? onTap;
  final Color foregroundColor;
  final String label;
  final IconData? icon;


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppValues.buttonHeight,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.textMedium,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(AppValues.borderRadius),
          color: Colors.transparent
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppValues.spacingXSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foregroundColor),
              SizedBox(width: AppValues.spacingXSmall),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: foregroundColor,
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
