import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/widget/app_filled_icon_button.dart';
import '../../../../core/widget/app_outlined_button.dart';
import '../../view_model/cubit/session_cubit.dart';
import '../../view_model/cubit/session_state.dart';

class SessionButtonsWidget extends StatelessWidget {
  const SessionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: BlocBuilder<SessionCubit, SessionState>(
            builder: (context, state) {
              bool isActive =
                  context.watch<SessionCubit>().state is SessionActive;
              return AppOutlinedButton(
                onTap: () {
                  if (isActive) {
                    context.read<SessionCubit>().pauseSession();
                  } else {
                    context.read<SessionCubit>().resumeSession();
                  }
                },
                icon: isActive ? Icons.pause_rounded : Icons.play_arrow_rounded,
                label: isActive
                    ? AppStrings.pauseSession
                    : AppStrings.resumeSession,
                foregroundColor: AppColors.textMedium,
              );
            },
          ),
        ),
        SizedBox(width: AppValues.spacingMedium),
        Expanded(
           flex: 3,
          child: AppFilledIconButton(
            onTap: () {
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
