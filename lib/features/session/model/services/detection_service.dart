import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:yaqazah/core/ui.dart';
import '../models/detection_result.dart';
import 'feature_service.dart';

class DetectionService {
  final FeatureService featureService;

  Interpreter? _interpreter;
  DetectionService(this.featureService);

  // Future<void> loadModel() async {

  //   _interpreter = await Interpreter.fromAsset(AppAssets.drowsinessPath);
  //   print(
  //     '#################################################Model loaded successfully',
  //   );
  // }


Future<void> loadModel() async {
  final options = InterpreterOptions()
    ..useNnApiForAndroid = false; // fallback

  _interpreter = await Interpreter.fromAsset(
    AppAssets.drowsinessPath,
    options: options,
  );
}

  Future<DetectionResult> detect(CameraImage image) async {
    await featureService.processFrame(image);

    if (!featureService.isReady) {
      return DetectionResult(
        sleepiness: 0,
        status: "Normal",
        risk: "Low",
        isYawning: false,
        isLookingAway: false,
        object: null,
        imageURL: "",
      );
    }

    final sleepiness = await runModel(featureService.buffer);

    return _getResult(sleepiness);
  }

  Future<double> runModel(List<List<double>> buffer) async {
    final input = [buffer]; // shape [1,30,4]
    final output = List.filled(1, 0).reshape([1, 1]);

    _interpreter!.run(input, output);

    return output[0][0];
  }

  DetectionResult _getResult(double sleepiness) {
    return DetectionResult(
      sleepiness: (sleepiness * 100).toInt(),
      status: sleepiness > 0.65 ? "High" : "Normal",
      risk: sleepiness > 0.65 ? "High Risk" : "Low Risk",
      isYawning: false, // optional later
      isLookingAway: false,
      object: null,
      imageURL: "",
    );
  }
}
