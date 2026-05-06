import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/size_helper.dart';
import '../../model/models/alert_type.dart';
import '../widgets/camera_widget.dart';
import '../widgets/metrics_widget.dart';
import '../widgets/session_app_header.dart';
import '../widgets/session_alert_dialog.dart';
import '../../view_model/cubit/session_cubit.dart';
import '../../view_model/cubit/session_state.dart';
import '../widgets/status_widget.dart';
import '../widgets/timer_widget.dart';

class SessionActiveScreen extends StatefulWidget {
  const SessionActiveScreen({super.key});

  @override
  State<SessionActiveScreen> createState() => _SessionActiveScreenState();
}

class _SessionActiveScreenState extends State<SessionActiveScreen> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paddingH = SizeHelper.screenPaddingHorizontal(context);

    return BlocConsumer<SessionCubit, SessionState>(
      listener: (context, state) async {
        if (state is SessionActive) {
          final shouldShowDialog = state.alertType != AlertType.none;

          if (shouldShowDialog && !_dialogShown) {
            _dialogShown = true;

            await showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
                return SessionAlertDialog(
                  alertType: state.alertType,

                  onRemind: () {
                    Navigator.of(dialogContext).pop();
                  },

                  onAcknowledge: () {
                    context.read<SessionCubit>().acknowledgeAlert();
                    Navigator.of(dialogContext).pop();
                  },
                );
              },
            );

            if (!mounted) return;
          }

          if (state.alertType == AlertType.none && _dialogShown) {
            _dialogShown = false;
          }
        }
        if (state is SessionEnded) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.sessionStart,
            (_) => false,
          );
        }
      },
      builder: (context, state) {
        final metrics = state is SessionActive
            ? state.metrics
            : state is SessionPaused
            ? state.metrics
            : null;

        final elapsed = state is SessionActive
            ? state.elapsed
            : state is SessionPaused
            ? state.elapsed
            : Duration.zero;

        final sleepinessProbability = metrics?.sleepinessProbability ?? 0;
        final status = metrics?.status ?? AppStrings.statusNormal;
        final riskLabel = metrics?.risk.name ?? AppStrings.lowRisk;

        final chipColor = status == AppStrings.statusNormal
            ? AppColors.chipNormalBg
            : status == AppStrings.statusDrowsy
            ? AppColors.chipDrowsyBg
            : AppColors.chipSleepyBg;

        final borderColor = status == AppStrings.statusNormal
            ? AppColors.success
            : status == AppStrings.statusDrowsy
            ? AppColors.drowsy
            : AppColors.sleepy;

        final barColor = status == AppStrings.statusNormal
            ? AppColors.success
            : status == AppStrings.statusDrowsy
            ? AppColors.drowsy
            : AppColors.sleepy;

        final isPaused = state is SessionPaused;

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: SafeArea(
            child: Column(
              children: [
                SessionAppHeader(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: paddingH,
                      vertical: AppValues.spacingSmall,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TimerWidget(elapsed: elapsed),
                        SizedBox(height: AppValues.spacingMedium),
                        CameraWidget(),
                        SizedBox(height: AppValues.spacingMedium),
                        StatusWidget(
                          chipColor: chipColor,
                          borderColor: borderColor,
                          status: status,
                        ),
                        SizedBox(height: AppValues.spacingMedium),
                        MetricsWidget(
                          sleepinessProbability: sleepinessProbability,
                          barColor: barColor,
                          riskLabel: riskLabel,
                          isPaused: isPaused,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
