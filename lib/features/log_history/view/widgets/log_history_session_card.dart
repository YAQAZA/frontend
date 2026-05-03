import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widget/app_surface_card.dart';
import '../../model/models/history_session_model.dart';

class LogHistorySessionCard extends StatelessWidget {
  const LogHistorySessionCard({
    super.key,
    required this.session,
    required this.onTap,
  });

  final HistorySessionModel session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = AppColors.logoBackground;
    return GestureDetector(
      onTap: onTap,
      child: AppSurfaceCard(
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            Container(
              width: 4,
              height: 110,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppValues.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.statusLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppValues.spacingXSmall),
                    Text(
                      session.startedAtLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: AppValues.spacingXSmall),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: AppColors.textMedium,
                        ),
                        SizedBox(width: AppValues.spacingXSmall),
                        Text(
                          session.durationLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textMedium,
                          ),
                        ),
                        SizedBox(width: AppValues.spacingMedium),
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: AppColors.textMedium,
                        ),
                        SizedBox(width: AppValues.spacingXSmall),
                        Text(
                          '${session.alertsDetected} alerts detected',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: session.alertsDetected == 0
                                ? AppColors.textMedium
                                : accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: AppValues.spacingMedium,
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

