import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_values.dart';


class StatusWidget extends StatelessWidget {
  const StatusWidget({
    super.key,
    required this.chipColor,
    required this.borderColor,
    required this.status,
  });

  final Color chipColor;
  final Color borderColor;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppValues.spacingMedium,
        vertical: AppValues.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            status == AppStrings.statusNormal
                ? Icons.check_circle
                : Icons.warning_amber_rounded,
            color: borderColor,
          ),
          SizedBox(width: AppValues.spacingXSmall),
          Text(
            'Status: $status',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
          ),
        ],
      ),
    );
  }
}
