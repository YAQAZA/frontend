import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widget/app_surface_card.dart';

class LogHistoryDetailsSummaryRow extends StatelessWidget {
  const LogHistoryDetailsSummaryRow({
    super.key,
    required this.durationLabel,
    required this.safetyScore,
    required this.detectionsCount,
  });

  final String durationLabel;
  final int safetyScore;
  final int detectionsCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: AppSurfaceCard(
            child: _summaryCell(
              label: 'DURATION',
              value: durationLabel,
              textTheme: textTheme,
            ),
          ),
        ),
        SizedBox(width: AppValues.spacingSmall),
        Expanded(
          child: AppSurfaceCard(
            child: _summaryCell(
              label: 'SAFETY SCORE',
              value: '$safetyScore %',
              textTheme: textTheme,
              valueColor: AppColors.success,
            ),
          ),
        ),
        SizedBox(width: AppValues.spacingSmall),
        Expanded(
          child: AppSurfaceCard(
            child: _summaryCell(
              label: 'DETECTIONS',
              value: '$detectionsCount total',
              textTheme: textTheme,
              valueColor: AppColors.drowsy,
            ),
          ),
        ),
      ],
    );
  }

  Widget _summaryCell({
    required String label,
    required String value,
    required TextTheme textTheme,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: AppColors.textMedium,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppValues.spacingSmall),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
