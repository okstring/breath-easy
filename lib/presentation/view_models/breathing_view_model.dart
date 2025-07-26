import 'dart:async';

import 'package:breath_easy/models/constants.dart';
import 'package:breath_easy/presentation/state/breathing_guide_state.dart';
import 'package:breath_easy/services/haptic_service.dart';
import 'package:breath_easy/services/wakelock_service.dart';
import 'package:flutter/foundation.dart';

class BreathingViewModel extends ChangeNotifier {
  // 서비스 인스턴스
  final HapticService _hapticService = HapticService();
  final WakelockService _wakelockService = WakelockService();

  // 상태
  BreathingGuideState _state = const BreathingGuideState();

  // 타이머 관련
  Timer? _timer;
  DateTime? _sessionStartTime;

  // Getter
  BreathingGuideState get state => _state;

  // 세션 토글
  void toggleSession() {
    if (_state.isSessionRunning) {
      stopSession();
    } else {
      startSession();
    }
  }

  // 세션 시작
  void startSession() {
    if (_state.isSessionRunning) return;

    _sessionStartTime = DateTime.now();
    _state = _state.copyWith(
      isSessionRunning: true,
      currentPhase: BreathingPhase.inhale,
      countdown: BreathingTiming.inhaleSeconds,
      progress: 0.0,
    );

    // 화면 꺼짐 방지 활성화
    _wakelockService.enable();

    // 첫 번째 단계 햅틱 피드백
    _hapticService.success();

    // 타이머 시작
    _startTimer();

    notifyListeners();
  }

  // 세션 정지
  void stopSession() {
    if (!_state.isSessionRunning) return;

    _timer?.cancel();
    _timer = null;
    _sessionStartTime = null;

    _state = _state.copyWith(
      isSessionRunning: false,
      currentPhase: BreathingPhase.ready,
      countdown: 0,
      progress: 0.0,
    );

    // 화면 꺼짐 방지 비활성화
    _wakelockService.disable();

    notifyListeners();
  }

  // 타이머 시작
  void _startTimer() {
    _timer = Timer.periodic(
      Duration(milliseconds: BreathingConstants.updateIntervalMs),
      (_) => _updateProgress(),
    );
  }

  // 진행도 업데이트
  void _updateProgress() {
    if (_sessionStartTime == null || !_state.isSessionRunning) return;

    final elapsed = DateTime.now().difference(_sessionStartTime!);
    final totalDurationMs = BreathingTiming.totalSeconds * 1000;
    final progressMs = elapsed.inMilliseconds % totalDurationMs;
    final progress = progressMs / totalDurationMs;

    // 현재 단계와 카운트다운 계산
    final phaseInfo = _calculatePhaseAndCountdown(progress);

    // 단계 변경 체크
    if (phaseInfo.phase != _state.currentPhase) {
      _onPhaseChanged(phaseInfo.phase);
    }

    _state = _state.copyWith(
      progress: progress,
      currentPhase: phaseInfo.phase,
      countdown: phaseInfo.countdown,
    );

    notifyListeners();
  }

  // 단계와 카운트다운 계산
  ({String phase, int countdown}) _calculatePhaseAndCountdown(double progress) {
    if (progress < BreathingTiming.inhaleEndNormalized) {
      // 들이쉬기 단계
      final phaseProgress = progress / BreathingTiming.inhaleEndNormalized;
      final countdown =
          (phaseProgress * BreathingTiming.inhaleSeconds).floor() + 1;
      return (
        phase: BreathingPhase.inhale,
        countdown: countdown.clamp(1, BreathingTiming.inhaleSeconds),
      );
    } else if (progress < BreathingTiming.holdEndNormalized) {
      // 멈추기 단계
      final phaseProgress =
          (progress - BreathingTiming.inhaleEndNormalized) /
          (BreathingTiming.holdEndNormalized -
              BreathingTiming.inhaleEndNormalized);
      final countdown =
          (phaseProgress * BreathingTiming.holdSeconds).floor() + 1;
      return (
        phase: BreathingPhase.hold,
        countdown: countdown.clamp(1, BreathingTiming.holdSeconds),
      );
    } else {
      // 내쉬기 단계
      final phaseProgress =
          (progress - BreathingTiming.holdEndNormalized) /
          (1.0 - BreathingTiming.holdEndNormalized);
      final countdown =
          (phaseProgress * BreathingTiming.exhaleSeconds).floor() + 1;
      return (
        phase: BreathingPhase.exhale,
        countdown: countdown.clamp(1, BreathingTiming.exhaleSeconds),
      );
    }
  }

  // 단계 변경 시 햅틱 피드백
  void _onPhaseChanged(String newPhase) {
    if (newPhase == BreathingPhase.inhale) {
      _hapticService.success();
    } else {
      _hapticService.medium();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _wakelockService.disable();
    super.dispose();
  }
}
