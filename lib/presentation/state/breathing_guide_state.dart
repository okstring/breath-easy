import 'package:freezed_annotation/freezed_annotation.dart';

part 'breathing_guide_state.freezed.dart';

 @freezed
abstract class BreathingGuideState with _$BreathingState {
  const factory BreathingGuideState({
    @Default('준비') String currentPhase,
    @Default(0) int countdown,
    @Default(false) bool isSessionRunning,
    @Default(0.0) double progress, // 0.0 ~ 1.0 (전체 호흡 사이클에서의 진행도)
  }) = _BreathingState;
}
