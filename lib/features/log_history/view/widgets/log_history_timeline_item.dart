import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../model/models/log_history_timeline_event_model.dart';

class LogHistoryTimelineItem extends StatelessWidget {
  const LogHistoryTimelineItem({
    super.key,
    required this.event,
    required this.isLast,
  });

  final LogHistoryTimelineEventModel event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final iconColor = _eventColor(event.eventType);
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: iconColor, width: 2),
                  ),
                  child: Icon(
                    _eventIcon(event.eventType),
                    size: 14,
                    color: iconColor,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      width: 2,
                      color: AppColors.borderLight,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: AppValues.spacingMedium),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppValues.spacingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    event.timeLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMedium,
                    ),
                  ),
                  if (event.description.isNotEmpty) ...[
                    SizedBox(height: AppValues.spacingSmall),
                    Row(
                      children: [
                        if (event.levelLabel.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: iconColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              event.levelLabel,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: iconColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        if (event.levelLabel.isNotEmpty)
                          SizedBox(width: AppValues.spacingSmall),
                        Expanded(
                          child: Text(
                            event.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (event.previewImageUrl != null) ...[
                    SizedBox(height: AppValues.spacingSmall),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        event.previewImageUrl!,
                        height: 96,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _eventColor(String type) {
  switch (type) {
    case 'high':
      return AppColors.sleepy;
    case 'low':
      return AppColors.drowsy;
    case 'end':
      return AppColors.success;
    default:
      return AppColors.primaryColor;
  }
}

IconData _eventIcon(String type) {
  switch (type) {
    case 'start':
      return Icons.play_arrow_rounded;
    case 'low':
      return Icons.warning_amber_rounded;
    case 'high':
      return Icons.dangerous_outlined;
    case 'phone':
      return Icons.phone_android_rounded;
    case 'end':
      return Icons.check_rounded;
    default:
      return Icons.info_outline_rounded;
  }
}
