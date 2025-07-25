import 'package:wakelock_plus/wakelock_plus.dart';

class WakelockService {
  Future<void> enable() async {
    // The wakelock_plus package handles all platform-specific checks.
    await WakelockPlus.enable();
  }

  Future<void> disable() async {
    await WakelockPlus.disable();
  }
}