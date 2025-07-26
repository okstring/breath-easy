import 'package:breath_easy/core/logger.dart';
import 'package:breath_easy/presentation/screens/breathing_guide_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3-3-7 Breathing',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const BreathingGuideScreen(),
    );
  }
}
