class BreathingPhase {
  static const String ready = '준비';
  static const String inhale = '들이쉬기';
  static const String hold = '멈추기';
  static const String exhale = '내쉬기';
  static const String rest = '휴식';
}

class BreathingTiming {
  static const int inhaleSeconds = 3;
  static const int holdSeconds = 3;
  static const int exhaleSeconds = 7;
  static const int restSeconds = 1;
  static const int totalSeconds =
      inhaleSeconds + holdSeconds + exhaleSeconds + restSeconds;

  static const double inhaleEndNormalized = inhaleSeconds / totalSeconds;
  static const double holdEndNormalized =
      (inhaleSeconds + holdSeconds) / totalSeconds;
  static const double exhaleEndNormalized =
      (inhaleSeconds + holdSeconds + exhaleSeconds) / totalSeconds;
}

class BreathingConstants {
  static const int updateIntervalMs = 50;
}

class BreathingAnimationConstants {
  static const int animationDurationMs = 50;
}
