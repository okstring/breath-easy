import 'package:flutter/material.dart';
import 'package:breath_easy/models/constants.dart';

/// 호흡 애니메이션 관련 계산을 담당하는 헬퍼 클래스
class BreathingAnimationHelper {
  /// progress 값을 기반으로 수위 높이를 계산
  static double calculateWaterHeight(double progress, double screenHeight) {
    if (progress < BreathingTiming.inhaleEndNormalized) {
      // 들이쉬기: 0 → screenHeight
      final phaseProgress = progress / BreathingTiming.inhaleEndNormalized;
      return phaseProgress * screenHeight;
    } else if (progress < BreathingTiming.holdEndNormalized) {
      // 멈추기: screenHeight 유지
      return screenHeight;
    } else if (progress < BreathingTiming.exhaleEndNormalized) {
      // 내쉬기: screenHeight → 0
      final phaseProgress = (progress - BreathingTiming.holdEndNormalized) /
          (BreathingTiming.exhaleEndNormalized -
              BreathingTiming.holdEndNormalized);
      return screenHeight * (1.0 - phaseProgress);
    } else {
      // 휴식: 0 유지
      return 0.0;
    }
  }

  /// progress 값을 기반으로 색상을 계산
  static Color calculateWaterColor(double progress) {
    final lightTeal = Colors.teal.shade100;
    final darkTeal = Colors.teal.shade600;

    if (progress < BreathingTiming.inhaleEndNormalized) {
      // 들이쉬기: 연한색 → 진한색
      final phaseProgress = progress / BreathingTiming.inhaleEndNormalized;
      return Color.lerp(lightTeal, darkTeal, phaseProgress) ?? lightTeal;
    } else if (progress < BreathingTiming.holdEndNormalized) {
      // 멈추기: 진한색 유지
      return darkTeal;
    } else if (progress < BreathingTiming.exhaleEndNormalized) {
      // 내쉬기: 진한색 → 연한색
      final phaseProgress = (progress - BreathingTiming.holdEndNormalized) /
          (BreathingTiming.exhaleEndNormalized -
              BreathingTiming.holdEndNormalized);
      return Color.lerp(darkTeal, lightTeal, phaseProgress) ?? darkTeal;
    } else {
      // 휴식: 연한색 유지
      return lightTeal;
    }
  }

  /// 배경색 계산 (수위와 반대되는 기본 색상)
  static Color getBackgroundColor() {
    return Colors.teal.shade100;
  }
}
