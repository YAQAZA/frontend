import '../models/detection_result.dart';

class DetectionService {
  // later → add TFLite interpreter here

  Future<DetectionResult> detect() async {
    // TEMP (until ML is ready)
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