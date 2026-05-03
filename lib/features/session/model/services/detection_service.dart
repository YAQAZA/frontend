import 'package:camera/camera.dart';

import '../models/detection_result.dart';
import 'feature_service.dart';

class DetectionService {
  final FeatureService featureService;

  DetectionService(this.featureService);

  Future<DetectionResult> detect(CameraImage image) async {
    featureService.processFrame(image);


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

    return _mockResult();
  }

  DetectionResult _mockResult() {
    return DetectionResult(
      sleepiness: 85,
      status: "High",
      risk: "High Risk",
      isYawning: true,
      isLookingAway: false,
      object: null,
      imageURL: "",
    );
  }
}
