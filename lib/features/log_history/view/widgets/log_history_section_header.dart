import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class LogHistorySectionHeader extends StatelessWidget {
  const LogHistorySectionHeader({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.textMedium,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
    );
  }
}
