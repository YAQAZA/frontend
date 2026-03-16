import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class StatusDialog extends StatelessWidget {
  const StatusDialog({
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppValues.spacingXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppValues.logoSize,
              height: AppValues.logoSize,
              decoration: BoxDecoration(
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
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onPrimaryPressed ??
                    () {
                      Navigator.of(context).pop();
                    },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.textWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppValues.borderRadius),
                  ),
                ),
                child: Text(
                  primaryLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

