import 'package:breath_easy/presentation/utils/breathing_animation_helper.dart';
import 'package:breath_easy/presentation/view_models/breathing_view_model.dart';
import 'package:breath_easy/presentation/widgets/control_button.dart';
import 'package:breath_easy/presentation/widgets/phase_and_countdown_display.dart';
import 'package:breath_easy/presentation/widgets/water_level_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BreathingGuideScreen extends StatelessWidget {
  const BreathingGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BreathingViewModel(),
      child: const _BreathingGuideView(),
    );
  }
}

class _BreathingGuideView extends StatelessWidget {
  const _BreathingGuideView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BreathingAnimationHelper.getBackgroundColor(),
      body: Consumer<BreathingViewModel>(
        builder: (context, viewModel, child) {
          final state = viewModel.state;
          final screenHeight = MediaQuery.of(context).size.height;

          return Stack(
            children: [
              WaterLevelAnimation(
                progress: state.progress,
                screenHeight: screenHeight,
              ),
              PhaseAndCountdownDisplay(
                phase: state.currentPhase,
                countdown: state.countdown,
                isSessionRunning: state.isSessionRunning,
                currentCycle: state.currentCycle,
                totalCycles: state.totalCycles,
              ),
              ControlButton(
                isSessionRunning: state.isSessionRunning,
                onPressed: viewModel.toggleSession,
              ),
            ],
          );
        },
      ),
    );
  }
}