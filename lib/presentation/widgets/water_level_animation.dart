import 'package:breath_easy/presentation/utils/breathing_animation_helper.dart';
import 'package:breath_easy/models/constants.dart';
import 'package:flutter/material.dart';

class WaterLevelAnimation extends StatelessWidget {
  final double progress;
  final double screenHeight;

  const WaterLevelAnimation({
    super.key,
    required this.progress,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final height = BreathingAnimationHelper.calculateWaterHeight(
      progress,
      screenHeight,
    );
    final color = BreathingAnimationHelper.calculateWaterColor(progress);

    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: BreathingAnimationConstants.animationDurationMs,
        ),
        width: double.infinity,
        height: height,
        color: color,
      ),
    );
  }
}
