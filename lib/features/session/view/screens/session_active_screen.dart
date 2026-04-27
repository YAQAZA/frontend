import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

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
  CameraController? _cameraController;
  bool _cameraInitializing = false;
  bool _dialogShown = false;

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _ensureCamera() async {
    if (_cameraController != null || _cameraInitializing) return;
    _cameraInitializing = true;

    final status = await Permission.camera.request();

    if (!status.isGranted) {
      if (status.isPermanentlyDenied) {
        openAppSettings();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camera permission is required")),
      );

      _cameraInitializing = false;
      return;
    }

    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      _cameraInitializing = false;
      return;
    }

    final selected = cameras.firstWhere(
      (d) => d.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    final controller = CameraController(
      selected,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller.initialize();

    if (!mounted) return;

    setState(() {
      _cameraController = controller;
    });

    _cameraInitializing = false;
  }

  @override
  Widget build(BuildContext context) {
    final paddingH = SizeHelper.screenPaddingHorizontal(context);

    return BlocConsumer<SessionCubit, SessionState>(
      listener: (context, state) async {
        if (state is SessionActive || state is SessionPaused) {
          await _ensureCamera();
        }

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SessionAppHeader(),
                TimerWidget(elapsed: elapsed),
                CameraWidget(),
                SizedBox(height: AppValues.spacingMedium),
                StatusWidget(
                  paddingH: paddingH,
                  chipColor: chipColor,
                  borderColor: borderColor,
                  status: status,
                ),
                SizedBox(height: AppValues.spacingMedium),
                MetricsWidget(
                  paddingH: paddingH,
                  sleepinessProbability: sleepinessProbability,
                  barColor: barColor,
                  riskLabel: riskLabel,
                  isPaused: isPaused,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
