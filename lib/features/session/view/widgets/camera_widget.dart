import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';
import '../../view_model/cubit/session_cubit.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController? _controller;
  bool _isLoading = true;
  String? _error;
  bool isInit = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      /// 1. Request permission
      final status = await Permission.camera.request();

      if (status.isDenied) {
        setState(() {
          _error = "Camera permission denied";
          _isLoading = false;
        });
        return;
      }

      if (status.isPermanentlyDenied) {
        await openAppSettings();
        setState(() {
          _error = "Enable camera permission from settings";
          _isLoading = false;
        });
        return;
      }

      /// 2. Get cameras
      final cameras = await availableCameras();

      final selected = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      /// 3. Initialize controller
      final controller = CameraController(
        selected,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();

      isInit = true;
      int _frameCounter = 0;

      controller.startImageStream((CameraImage image) {
        if (!mounted || _controller == null) return;
        _frameCounter++;

        if (_frameCounter % 5 != 0) return;

        if (isInit || context.read<SessionCubit>().isProcessing) {
          context.read<SessionCubit>().updateMetrics(image);
          isInit = false;
        }
      });

      if (!mounted) return;

      setState(() {
        _controller = controller;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to initialize camera";
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.stopImageStream();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      content = Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    } else if (_controller != null && _controller!.value.isInitialized) {
      content = CameraPreview(_controller!);
    } else {
      content = const Center(child: Icon(Icons.videocam_off_rounded));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppValues.cameraCornerRadius),
      child: Container(
        width: MediaQuery.of(context).size.width*0.8,
        height:
            MediaQuery.sizeOf(context).height * AppValues.cameraHeightFactor,
        color: AppColors.borderLight,
        child: content,
      ),
    );
  }
}
