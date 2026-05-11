import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widget/core_widgets.dart';
import '../../model/models/alert_type.dart';

class SessionAlertDialog extends StatefulWidget {
  const SessionAlertDialog({
    super.key,
    required this.alertType,
    required this.onAcknowledge,
  });

  final AlertType alertType;
  final VoidCallback onAcknowledge;

  @override
  State<SessionAlertDialog> createState() => _SessionAlertDialogState();
}

class _SessionAlertDialogState extends State<SessionAlertDialog> {
  int _seconds = AppValues.seconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    final isDistraction = widget.alertType == AlertType.distraction;

    // Auto acknowledge only for drowsiness
    if (!isDistraction) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_seconds == 1) {
          timer.cancel();

          widget.onAcknowledge();

          // if (mounted) {
          //   Navigator.of(context).pop();
          // }
        } else {
          setState(() {
            _seconds--;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleAcknowledge() {
    _timer?.cancel();
    widget.onAcknowledge();

    // if (mounted) {
    //   Navigator.of(context).pop();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final isDistraction = widget.alertType == AlertType.distraction;

    final Color topBarColor = isDistraction
        ? AppColors.primaryColor
        : AppColors.sleepy;

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

                if (!isDistraction)
                  Text(
                    AppStrings.drowsinessDetectedBody,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMedium,
                    ),
                    textAlign: TextAlign.center,
                  ),

                SizedBox(height: AppValues.spacingLarge),

                if (isDistraction)
                  TextButton(
                    onPressed: _handleAcknowledge,
                    child: Text(
                      AppStrings.ok,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  AppFilledIconButton(
                    onTap: _handleAcknowledge,
                    icon: Icons.check_circle,
                    label: 'I am Alert ($_seconds)',
                  ),
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
            isDistraction ? Icons.warning_amber_rounded : Icons.warning_rounded,
            color: bg,
            size: 26,
          ),
        ),
      ),
    );
  }
}
