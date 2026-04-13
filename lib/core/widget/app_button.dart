import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_values.dart';

/// Full-width primary filled button (loading state + optional trailing icon).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppValues.buttonHeight,
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.textWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppValues.borderRadius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: AppValues.iconSizeMedium,
                height: AppValues.iconSizeMedium,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.textWhite,
                ),
              )
            : _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.titleMedium?.copyWith(
      color: AppColors.textWhite,
      fontWeight: FontWeight.w600,
      fontSize: AppValues.buttonFontSize,
    );
    if (trailingIcon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: textStyle),
          SizedBox(width: AppValues.spacingSmall),
          trailingIcon!,
        ],
      );
    }
    return Text(label, style: textStyle);
  }
}
