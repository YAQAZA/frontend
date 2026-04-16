import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';


class TimerWidget extends StatefulWidget {
  final Duration elapsed;
  const TimerWidget({super.key, required this.elapsed});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  String _formatHms(Duration d) {
    final hh = d.inHours.toString().padLeft(2, '0');
    final mm = (d.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppValues.spacingMedium,
        vertical: AppValues.spacingMedium,
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time_rounded, color: AppColors.primaryColor),
          const SizedBox(width: AppValues.spacingSmall),
          Text(
            _formatHms(widget.elapsed),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
