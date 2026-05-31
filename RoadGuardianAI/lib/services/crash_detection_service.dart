import 'dart:math';

class CrashDetectionService {
  CrashDetectionService._internal();

  static final CrashDetectionService instance = CrashDetectionService._internal();

  bool _crashDetected = false;

  bool get crashDetected => _crashDetected;

  Future<bool> simulateCrashCheck() async {
    await Future.delayed(const Duration(milliseconds: 900));
    final detected = Random().nextDouble() > 0.82;
    _crashDetected = detected;
    return detected;
  }

  void reset() {
    _crashDetected = false;
  }
}
