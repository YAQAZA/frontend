import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widget/app_surface_card.dart';
import '../../model/models/log_history_summary_model.dart';

class LogHistorySummaryCards extends StatelessWidget {
  const LogHistorySummaryCards({
    super.key,
    required this.summary,
  });

  final LogHistorySummaryModel summary;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: AppSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SAFETY SCORE',
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textMedium,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppValues.spacingSmall),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${summary.safetyScore}%',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: AppValues.spacingSmall),
                    Text(
                      '+${summary.safetyDelta}%',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: AppValues.spacingSmall),
        Expanded(
          child: AppSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL DRIVES',
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textMedium,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppValues.spacingSmall),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${summary.totalDrives}',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: AppValues.spacingSmall),
                    Text(
                      summary.totalDrivesPeriodLabel,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
