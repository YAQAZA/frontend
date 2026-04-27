
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/constants/dummy_data.dart';
import 'session_buttons_widget.dart';

class MetricsWidget extends StatelessWidget {
  const MetricsWidget({
    super.key,
    required this.paddingH,
    required this.sleepinessProbability,
    required this.barColor,
    required this.riskLabel,
    required this.isPaused,
  });

  final double paddingH;
  final int sleepinessProbability;
  final Color barColor;
  final String riskLabel;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingH),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.fatigueLevel,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(
                      color: AppColors.textMedium,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            SizedBox(height: AppValues.spacingSmall),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    AppStrings.sleepinessProbability,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                  ),
                ),
                Text(
                  '$sleepinessProbability%',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: barColor,
                      ),
                ),
              ],
            ),
            SizedBox(height: AppValues.spacingSmall),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: sleepinessProbability / 100,
                minHeight: 10,
                backgroundColor: AppColors.borderLight,
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
            SizedBox(height: AppValues.spacingSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  riskLabel,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(
                        color: AppColors.textMedium,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  'Alert Threshold: ${DummyData.alertThreshold}%',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(
                        color: AppColors.textMedium,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            SizedBox(height: AppValues.spacingXLarge),
            SessionButtonsWidget(isPaused: isPaused),
          ],
        ),
      ),
    );
  }
}

