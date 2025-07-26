import 'package:breath_easy/presentation/styles/text_styles.dart';
import 'package:flutter/material.dart';

class PhaseAndCountdownDisplay extends StatelessWidget {
  final String phase;
  final int countdown;
  final bool isSessionRunning;

  const PhaseAndCountdownDisplay({
    super.key,
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
          Text(
            phase,
            style: AppTextStyles.phaseAndCountdownTextStyle.copyWith(
              fontSize: 42,
            ),
          ),
          if (isSessionRunning && countdown > 0)
            Text(
              '$countdown',
              style: AppTextStyles.phaseAndCountdownTextStyle.copyWith(
                fontSize: 48,
                height: 1.2,
              ),
            ),
        ],
      ),
    );
  }
}
