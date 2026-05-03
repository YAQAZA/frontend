import 'package:camera/camera.dart';

class FeatureService {
  final List<List<double>> _buffer = [];

  static const int maxSize = 30;


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

   void processFrame(CameraImage image) async {
    final ear = 0.5; // replace with real EAR
    final mar = 0.2; // replace with real MAR

    addFrame(ear: ear, mar: mar, dEar: 0, dMar: 0);

    if (!isReady) return;
  }


  List<List<double>> get buffer => _buffer;

  bool get isReady => _buffer.length == maxSize;
}