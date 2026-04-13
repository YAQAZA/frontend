import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/size_helper.dart';
import '../../../../core/widget/core_widgets.dart';
import '../../model/models/session_alert_type.dart';
import '../widgets/session_app_header.dart';
import '../widgets/session_alert_dialog.dart';
import '../../view_model/cubit/session_cubit.dart';
import '../../view_model/cubit/session_state.dart';

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
    _cameraController = null;
    super.dispose();
  }

  Future<void> _ensureCamera() async {
    if (_cameraController != null || _cameraInitializing) return;
    _cameraInitializing = true;

    final status = await Permission.camera.request();
    if (!status.isGranted) {
      _cameraInitializing = false;
      return;
    }

    final cameras = await availableCameras();
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

  String _formatHms(Duration d) {
    final hh = d.inHours.toString().padLeft(2, '0');
    final mm = (d.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
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
          final shouldShowDialog = state.alertType != SessionAlertType.none;
          if (shouldShowDialog && !_dialogShown) {
            _dialogShown = true;
            await showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
                return SessionAlertDialog(
                  alertType: state.alertType,
                  remindCount: state.remindCount,
                  onRemind: () {
                    context.read<SessionCubit>().remindAlert();
                    Navigator.of(dialogContext).pop();
                  },
                  onAcknowledge: () {
                    context.read<SessionCubit>().acknowledgeAlert();
                    Navigator.of(dialogContext).pop();
                  },
                );
              },
            );
          }

          if (state.alertType == SessionAlertType.none) {
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
        final threshold = metrics?.alertThreshold ?? 75;

        final status = metrics?.status ?? AppStrings.statusNormal;
        final riskLabel = metrics?.riskLabel ?? AppStrings.lowRisk;

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
                SessionAppHeader(
                  onSettingsTap: () {
                    Navigator.pushNamed(context, AppRoutes.settings);
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingH),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          color: AppColors.primaryColor),
                      SizedBox(width: AppValues.spacingSmall),
                      Text(
                        _formatHms(elapsed),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppValues.spacingMedium),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingH),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppValues.cameraCornerRadius),
                    child: Container(
                      height: MediaQuery.sizeOf(context).height *
                          AppValues.cameraHeightFactor,
                      color: AppColors.borderLight,
                      child: _cameraController != null &&
                              _cameraController!.value.isInitialized
                          ? CameraPreview(_cameraController!)
                          : const Center(
                              child: Icon(Icons.videocam_off_rounded),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: AppValues.spacingMedium),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingH),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppValues.spacingMedium,
                      vertical: AppValues.spacingSmall,
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
                        SizedBox(width: AppValues.spacingSmall),
                        Text(
                          'Status: $status',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppValues.spacingMedium),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: paddingH),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppStrings.fatigueLevel,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textMedium,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        SizedBox(height: AppValues.spacingSmall),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                AppStrings.sleepinessProbability,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textDark,
                                    ),
                              ),
                            ),
                            Text(
                              '$sleepinessProbability%',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: barColor,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppValues.spacingSmall),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: sleepinessProbability / 100,
                            minHeight: 10,
                            backgroundColor: AppColors.borderLight,
                            valueColor: AlwaysStoppedAnimation<Color>(barColor),
                          ),
                        ),
                        SizedBox(height: AppValues.spacingSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              riskLabel,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textMedium,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              'Alert Threshold: ${threshold}%',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textMedium,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppValues.spacingXLarge),
                        Row(
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

