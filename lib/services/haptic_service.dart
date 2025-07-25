import 'package:haptic_feedback/haptic_feedback.dart';

class HapticService {
  Future<void> vibrate() async {
    // This package handles platform checks internally.
    // We can call it directly.
    await Haptics.vibrate(HapticsType.light);
  }
}