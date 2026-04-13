import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_values.dart';
import 'app_button.dart';
import 'app_rounded_dialog.dart';

/// Success / info dialog with icon, title, body, and primary action.
class AppStatusDialog extends StatelessWidget {
  const AppStatusDialog({
    super.key,
    required this.title,
    required this.body,
    required this.primaryLabel,
    this.onPrimaryPressed,
  });

  final String title;
  final String body;
  final String primaryLabel;
  final VoidCallback? onPrimaryPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppRoundedDialog(
      borderRadius: AppValues.borderRadius,
      child: Padding(
        padding: EdgeInsets.all(AppValues.spacingXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppValues.logoSize,
              height: AppValues.logoSize,
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 40,
              ),
            ),
            SizedBox(height: AppValues.spacingLarge),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppValues.spacingMedium),
            Text(
              body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textMedium,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppValues.spacingXLarge),
            AppButton(
              label: primaryLabel,
              onPressed: onPrimaryPressed ??
                  () {
                    Navigator.of(context).pop();
                  },
            ),
          ],
        ),
      ),
    );
  }
}
