import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final bool isSessionRunning;
  final VoidCallback onPressed;

  const ControlButton({
    super.key,
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
            backgroundColor: Colors.white.withOpacity(0.9),
            foregroundColor: Colors.teal.shade800,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(32),
            elevation: 10,
          ),
          child: Text(
            isSessionRunning ? '정지' : '시작',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
