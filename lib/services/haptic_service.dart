import 'package:haptic_feedback/haptic_feedback.dart';

class HapticService {
  Future<void> medium() async {
    await Haptics.vibrate(HapticsType.medium);
  }

  Future<void> success() async {
    await Haptics.vibrate(HapticsType.success);
  }
}