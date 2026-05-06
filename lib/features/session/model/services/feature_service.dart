import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../../../core/constants/app_logger.dart';

class FeatureService {
  final List<List<double>> _buffer = [];

  static const int maxSize = 30;

  final faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      enableClassification: true,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

InputImage convertCameraImage(CameraImage image) {
  final allBytes = WriteBuffer();
  for (final plane in image.planes) {
    allBytes.putUint8List(plane.bytes);
  }
  final bytes = allBytes.done().buffer.asUint8List();

  // ✅ Detect format dynamically instead of hardcoding nv21
  final format = image.format.raw == 35
      ? InputImageFormat.yuv420  // most Android cameras
      : InputImageFormat.nv21;

  final metadata = InputImageMetadata(
    size: Size(image.width.toDouble(), image.height.toDouble()),
    rotation: InputImageRotation.rotation90deg, // ✅ try 90deg — back camera is usually rotated
    format: format,
    bytesPerRow: image.planes.first.bytesPerRow,
  );

  return InputImage.fromBytes(bytes: bytes, metadata: metadata);
}

  void addFrame({
    required double ear,
    required double mar,
    required double dEar,
    required double dMar,
  }) {
    _buffer.add([ear, mar, dEar, dMar]);

    if (_buffer.length > maxSize) {
      _buffer.removeAt(0);
    }
  }

  Future<void> processFrame(CameraImage image) async {
    final inputImage = convertCameraImage(image);

    final faces = await faceDetector.processImage(inputImage);

    AppLogger.logger.w('########## Faces detected: ${faces.length} ##########'); // ✅ add this

    if (faces.isEmpty) return;

    final face = faces.first;
    final leftEyeOpen = face.leftEyeOpenProbability ?? 1.0;
    final rightEyeOpen = face.rightEyeOpenProbability ?? 1.0;

    final ear = (leftEyeOpen + rightEyeOpen) / 2.0;
    final mouthOpen = face.smilingProbability ?? 0.0;
    final mar = mouthOpen;

    AppLogger.logger.i('##############################EAR: $ear, MAR: $mar#########################');

    addFrame(ear: ear, mar: mar, dEar: 0, dMar: 0);

    if (!isReady) return;
  }

  List<List<double>> get buffer => _buffer;

  bool get isReady => _buffer.length == maxSize;
}
