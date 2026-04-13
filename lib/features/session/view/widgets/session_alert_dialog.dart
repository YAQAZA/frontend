import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widget/core_widgets.dart';
import '../../model/models/session_alert_type.dart';

class SessionAlertDialog extends StatelessWidget {
  const SessionAlertDialog({
    super.key,
    required this.alertType,
    required this.remindCount,
    required this.onRemind,
    required this.onAcknowledge,
  });

  final SessionAlertType alertType;
  final int remindCount;
  final VoidCallback onRemind;
  final VoidCallback onAcknowledge;

  @override
  Widget build(BuildContext context) {
    final isDistraction = alertType == SessionAlertType.distraction;

    final Color topBarColor =
        isDistraction ? AppColors.primaryColor : AppColors.sleepy;
    final String title = isDistraction
        ? AppStrings.distractionDetected
        : AppStrings.drowsinessDetected;

    return AppRoundedDialog(
      borderRadius: AppValues.cardRadius,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppDialogTopBar(
            color: topBarColor,
            borderRadius: AppValues.cardRadius,
          ),
          Padding(
            padding: EdgeInsets.all(AppValues.spacingLarge),
            child: Column(
              children: [
                _buildIcon(isDistraction: isDistraction),
                SizedBox(height: AppValues.spacingLarge),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                ),
                SizedBox(height: AppValues.spacingMedium),
                if (isDistraction)
                  const SizedBox.shrink()
                else
                  Text(
                    AppStrings.drowsinessDetectedBody,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMedium,
                        ),
                    textAlign: TextAlign.center,
                  ),
                if (isDistraction) ...[
                  SizedBox(height: AppValues.spacingLarge),
                  TextButton(
                    onPressed: () {
                      onAcknowledge();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppStrings.ok,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ] else ...[
                  SizedBox(height: AppValues.spacingLarge),
                  Row(
                    children: [
                      Expanded(
                        child: AppOutlinedButton(
                          expandWidth: true,
                          fixedHeight: AppValues.buttonHeight,
                          onPressed: onRemind,
                          label: '${AppStrings.remind} ($remindCount)',
                          foregroundColor: AppColors.textDark,
                        ),
                      ),
                      SizedBox(width: AppValues.spacingMedium),
                      Expanded(
                        child: AppFilledIconButton(
                          expandWidth: true,
                          height: AppValues.buttonHeight,
                          onPressed: onAcknowledge,
                          icon: Icons.check_circle,
                          label: AppStrings.iamAlert,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon({required bool isDistraction}) {
    final Color bg = isDistraction ? AppColors.primaryColor : AppColors.sleepy;
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg.withValues(alpha: 0.12),
      ),
      child: Center(
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bg.withValues(alpha: 0.15),
            border: Border.all(color: bg.withValues(alpha: 0.6), width: 4),
          ),
          child: Icon(
            isDistraction
                ? Icons.warning_amber_rounded
                : Icons.warning_rounded,
            color: bg,
            size: 26,
          ),
        ),
      ),
    );
  }
}
