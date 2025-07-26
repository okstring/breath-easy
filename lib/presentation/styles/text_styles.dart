import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle phaseAndCountdownTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(2.0, 2.0)),
    ],
  );
}
