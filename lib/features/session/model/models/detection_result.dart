class DetectionResult {
  final int sleepiness;
  final String status;
  final String risk;
  final bool isYawning;
  final bool isLookingAway;
  final String? object;
  final String imageURL;

  DetectionResult({
    required this.sleepiness,
    required this.status,
    required this.risk,
    required this.isYawning,
    required this.isLookingAway,
    this.object,
    required this.imageURL,
  });
}