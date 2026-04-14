import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/widget/app_filled_icon_button.dart';
import '../../../../core/widget/app_outlined_button.dart';
import '../../view_model/cubit/session_cubit.dart';


class SessionButtonsWidget extends StatelessWidget {
  const SessionButtonsWidget({
    super.key,
    required this.isPaused,
  });

  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppOutlinedButton(
            expandWidth: true,
            fixedHeight: AppValues.buttonHeight,
            onPressed: () {
              if (isPaused) {
                context.read<SessionCubit>().startSession();
              } else {
                context.read<SessionCubit>().pauseSession();
              }
            },
            icon: Icons.pause_rounded,
            label: AppStrings.pauseSession,
            foregroundColor: AppColors.textMedium,
          ),
        ),
        SizedBox(width: AppValues.spacingMedium),
        Expanded(
          child: AppFilledIconButton(
            expandWidth: true,
            height: AppValues.buttonHeight,
            onPressed: () {
              context.read<SessionCubit>().endSession();
            },
            icon: Icons.stop_circle_rounded,
            label: AppStrings.endSession,
          ),
        ),
      ],
    );
  }
}
