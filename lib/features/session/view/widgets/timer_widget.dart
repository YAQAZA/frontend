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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.textMedium)
      ),
      width: MediaQuery.of(context).size.width*0.4,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppValues.spacingXSmall,
          vertical: AppValues.spacingXSmall,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.access_time_rounded,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: AppValues.spacingXSmall),
            Text(
              _formatHms(widget.elapsed),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
