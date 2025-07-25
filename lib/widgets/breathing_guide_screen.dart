import 'package:breath_easy/services/haptic_service.dart';
import 'package:breath_easy/services/tts_service.dart';
import 'package:breath_easy/services/wakelock_service.dart';
import 'package:flutter/material.dart';

class BreathingGuideScreen extends StatefulWidget {
  const BreathingGuideScreen({super.key});

  @override
  State<BreathingGuideScreen> createState() => _BreathingGuideScreenState();
}

class _BreathingGuideScreenState extends State<BreathingGuideScreen>
    with SingleTickerProviderStateMixin {
  // Animation & State
  late final AnimationController _controller;
  late final Animation<double> _heightAnimation;
  late final Animation<Color?> _colorAnimation;
  String _currentPhase = '준비';
  int _countdown = 0;
  bool _isSessionRunning = false;

  // Services
  final HapticService _hapticService = HapticService();
  final TtsService _ttsService = TtsService();
  final WakelockService _wakelockService = WakelockService();

  // Breathing Timings
  static const int _inhaleSeconds = 3;
  static const int _holdSeconds = 3;
  static const int _exhaleSeconds = 7;
  static const int _totalSeconds =
      _inhaleSeconds + _holdSeconds + _exhaleSeconds;

  @override
  void initState() {
    super.initState();
    _wakelockService.enable();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _totalSeconds),
    );

    // Defer animation initialization until the first build
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize animations here, where context is available.
    _initializeAnimations();
  }

  void _initializeAnimations() {
    final screenHeight = MediaQuery.of(context).size.height;
    const double inhaleWeight = _inhaleSeconds / _totalSeconds;
    const double holdWeight = _holdSeconds / _totalSeconds;
    const double exhaleWeight = _exhaleSeconds / _totalSeconds;

    _heightAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: screenHeight),
        weight: inhaleWeight,
      ),
      TweenSequenceItem(tween: ConstantTween(screenHeight), weight: holdWeight),
      TweenSequenceItem(
        tween: Tween(begin: screenHeight, end: 0.0),
        weight: exhaleWeight,
      ),
    ]).animate(_controller);

    _colorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(
          begin: Colors.teal.shade300,
          end: Colors.teal.shade600,
        ),
        weight: inhaleWeight,
      ),
      TweenSequenceItem(
        tween: ConstantTween(Colors.purple.shade400),
        weight: holdWeight,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: Colors.purple.shade400,
          end: Colors.teal.shade300,
        ),
        weight: exhaleWeight,
      ),
    ]).animate(_controller);

    _controller.addListener(_updateState);
  }

  void _updateState() {
    if (!_isSessionRunning || !mounted) return;

    final progress = _controller.value;
    const double inhaleEnd = _inhaleSeconds / _totalSeconds;
    const double holdEnd = (_inhaleSeconds + _holdSeconds) / _totalSeconds;

    String nextPhase = _currentPhase;
    int nextCountdown = _countdown;

    if (progress < inhaleEnd) {
      nextPhase = '들이쉬기';
      final phaseProgress = progress / inhaleEnd;
      nextCountdown = _inhaleSeconds - (_inhaleSeconds * phaseProgress).floor();
    } else if (progress < holdEnd) {
      nextPhase = '멈추기';
      final phaseProgress = (progress - inhaleEnd) / (holdEnd - inhaleEnd);
      nextCountdown = _holdSeconds - (_holdSeconds * phaseProgress).floor();
    } else {
      nextPhase = '내쉬기';
      final phaseProgress = (progress - holdEnd) / (1.0 - holdEnd);
      nextCountdown = _exhaleSeconds - (_exhaleSeconds * phaseProgress).floor();
    }

    if (nextPhase != _currentPhase) {
      _onPhaseChanged(nextPhase);
    }

    if (nextCountdown != _countdown) {
      setState(() {
        _countdown = nextCountdown;
      });
    }
  }

  void _onPhaseChanged(String newPhase) {
    _currentPhase = newPhase;
    try {
      _hapticService.vibrate();
      _ttsService.speak(_currentPhase);
    } catch (e) {
      debugPrint('Service call failed: $e');
    }
    setState(() {});
  }

  void _toggleSession() {
    if (!mounted) return;

    setState(() {
      _isSessionRunning = !_isSessionRunning;
      if (_isSessionRunning) {
        _startSession();
      } else {
        _stopSession();
      }
    });
  }

  void _startSession() {
    _ttsService.speak("3-3-7 호흡을 시작합니다.");
    _controller.repeat();
    _currentPhase = '들이쉬기'; // Set initial phase
    _countdown = _inhaleSeconds;
  }

  void _stopSession() {
    _ttsService.speak("호흡을 멈춥니다.");
    _controller.stop();
    _controller.reset();
    _currentPhase = '준비';
    _countdown = 0;
  }

  @override
  void dispose() {
    _controller.removeListener(_updateState);
    _controller.dispose();
    _wakelockService.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              _WaterLevelAnimation(
                height: _heightAnimation.value,
                color: _colorAnimation.value,
              ),
              _PhaseAndCountdownDisplay(
                phase: _currentPhase,
                countdown: _countdown,
                isSessionRunning: _isSessionRunning,
              ),
              _ControlButton(
                isSessionRunning: _isSessionRunning,
                onPressed: _toggleSession,
              ),
            ],
          );
        },
      ),
    );
  }
}

// --- Refactored Widgets ---

class _WaterLevelAnimation extends StatelessWidget {
  final double height;
  final Color? color;

  const _WaterLevelAnimation({required this.height, this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(width: double.infinity, height: height, color: color),
    );
  }
}

class _PhaseAndCountdownDisplay extends StatelessWidget {
  final String phase;
  final int countdown;
  final bool isSessionRunning;

  static final _textStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        blurRadius: 10.0,
        color: Colors.black.withValues(alpha: 0.5),
        offset: Offset(2.0, 2.0),
      ),
    ],
  );

  const _PhaseAndCountdownDisplay({
    required this.phase,
    required this.countdown,
    required this.isSessionRunning,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(phase, style: _textStyle.copyWith(fontSize: 32)),
          if (isSessionRunning && countdown > 0)
            Text(
              '$countdown',
              style: _textStyle.copyWith(fontSize: 48, height: 1.2),
            ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final bool isSessionRunning;
  final VoidCallback onPressed;

  const _ControlButton({
    required this.isSessionRunning,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.9),
            foregroundColor: Colors.teal.shade800,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(24),
            elevation: 10,
          ),
          child: Text(
            isSessionRunning ? '정지' : '시작',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
