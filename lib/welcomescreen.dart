import 'package:flutter/material.dart';

void main() {
  runApp(const SavourSoulApp());
}

class SavourSoulApp extends StatelessWidget {
  const SavourSoulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Savor & Soul',
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color deepGreen = Color(0xFF2F4A3E);
  static const Color deepGreenDark = Color(0xFF24392F);
  static const Color cream = Color(0xFFFAF6EE);
  static const Color ink = Color(0xFF241F1A);
  static const Color muted = Color(0xFF5B5148);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background.jpg', fit: BoxFit.cover),
        ],
      ),
    );
  }
}
