import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

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

  // ─────────────────────────────────────────────────────────────
  // Convert CameraImage → ML Kit InputImage
  // ─────────────────────────────────────────────────────────────
  InputImage convertCameraImage(CameraImage image) {
    final allBytes = WriteBuffer();

    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();

    final format = image.format.raw == 35
        ? InputImageFormat.yuv420
        : InputImageFormat.nv21;

    final metadata = InputImageMetadata(
      size: Size(
        image.width.toDouble(),
        image.height.toDouble(),
      ),
      rotation: InputImageRotation.rotation90deg,
      format: format,
      bytesPerRow: image.planes.first.bytesPerRow,
    );

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: metadata,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Convert YUV420 CameraImage → RGB JPEG
  // ─────────────────────────────────────────────────────────────
  Future<Uint8List> convertCameraImageToJpeg(
    CameraImage image,
  ) async {
    final int width = image.width;
    final int height = image.height;

    final img.Image rgbImage = img.Image(
      width: width,
      height: height,
    );

    final Plane yPlane = image.planes[0];
    final Plane uPlane = image.planes[1];
    final Plane vPlane = image.planes[2];

    final int uvRowStride = uPlane.bytesPerRow;
    final int uvPixelStride = uPlane.bytesPerPixel!;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex =
            uvPixelStride * (x ~/ 2) +
            uvRowStride * (y ~/ 2);

        final int index = y * width + x;

        final int yp = yPlane.bytes[index];
        final int up = uPlane.bytes[uvIndex];
        final int vp = vPlane.bytes[uvIndex];

        // YUV420 → RGB
        int r = (yp + vp * 1436 / 1024 - 179).round();
        int g = (yp -
                up * 46549 / 131072 +
                44 -
                vp * 93604 / 131072 +
                91)
            .round();
        int b = (yp + up * 1814 / 1024 - 227).round();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        rgbImage.setPixelRgb(x, y, r, g, b);
      }
    }

    // Rotate image correctly
    final rotated = img.copyRotate(
      rgbImage,
      angle: 90,
    );

    final jpg = img.encodeJpg(
      rotated,
      quality: 85,
    );

    return Uint8List.fromList(jpg);
  }

  // ─────────────────────────────────────────────────────────────
  // Add frame to sequence buffer
  // ─────────────────────────────────────────────────────────────
  void addFrame({
    required double ear,
    required double mar,
    required double dEar,
    required double dMar,
  }) {
    _buffer.add([
      ear,
      mar,
      dEar,
      dMar,
    ]);

    if (_buffer.length > maxSize) {
      _buffer.removeAt(0);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Main frame processing
  // ─────────────────────────────────────────────────────────────
  Future<void> processFrame(
    CameraImage image,
  ) async {
    try {
      // ML Kit image
      final inputImage = convertCameraImage(image);

      // Face detection
      final faces = await faceDetector.processImage(
        inputImage,
      );

      AppLogger.warning(
        'Faces detected: ${faces.length}',
      );

      // Convert frame → JPEG bytes
      final jpegBytes =
          await convertCameraImageToJpeg(image);

      // Convert JPEG → Base64
      final base64String = base64Encode(
        jpegBytes,
      );

      AppLogger.fatal(
        'JPEG Base64 Size: ${base64String.length}',
      );

      AppLogger.fatal(
        'JPEG Base64 Sample: '
        '$base64String',
      );

      // This is now a REAL image
      // You can:
      // - Upload it
      // - Display it
      // - Send to APIs
      // - Open in online Base64 decoders

      if (faces.isEmpty) return;

      final face = faces.first;

      final leftEyeOpen =
          face.leftEyeOpenProbability ?? 1.0;

      final rightEyeOpen =
          face.rightEyeOpenProbability ?? 1.0;

      final ear =
          (leftEyeOpen + rightEyeOpen) / 2.0;

      final mar =
          face.smilingProbability ?? 0.0;

      double dEar = 0.0;
      double dMar = 0.0;

      if (_buffer.isNotEmpty) {
        final last = _buffer.last;

        dEar = ear - last[0];
        dMar = mar - last[1];
      }

      AppLogger.info(
        'EAR: $ear | '
        'MAR: $mar | '
        'dEAR: $dEar | '
        'dMAR: $dMar',
      );

      addFrame(
        ear: ear,
        mar: mar,
        dEar: dEar,
        dMar: dMar,
      );

      if (!isReady) return;

      // READY FOR MODEL INFERENCE
    } catch (e) {
      AppLogger.error(
        'Process Frame Error: $e',
      );
    }
  }

 
  List<List<double>> get buffer => _buffer;

  bool get isReady =>
      _buffer.length == maxSize;
}