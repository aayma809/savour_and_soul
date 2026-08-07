import 'dart:ui';

import 'package:flutter/material.dart';
import 'loginscreen.dart';

void main() {
  runApp(const SavorSoulApp());
}

class SavorSoulApp extends StatelessWidget {
  const SavorSoulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Savor & Soul',
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const Color deepGreen = Color(0xFF2F5645);
  static const Color darkText = Color(0xFF1C1C1A);
  static const Color subtitleText = Color(0xFF4A4A47);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFCFE0EA),
                  Color(0xFFDFE7DD),
                  Color(0xFFE9E2CF),
                  Color(0xFFECE2CF),
                ],
                stops: [0.0, 0.35, 0.6, 1.0],
              ),
            ),
          ),

          // Soft blurred color blobs to emulate a blurred photo background
          _blob(top: -40, left: -60, size: 260, color: const Color(0xFF8FAE7C)),
          _blob(
            bottom: 260,
            left: -40,
            size: 220,
            color: const Color(0xFFD8C9A3),
          ),
          _blob(top: 60, right: -80, size: 300, color: const Color(0xFFA9C6D8)),
          _blob(
            bottom: 120,
            right: -60,
            size: 260,
            color: const Color(0xFFE7D9B8),
          ),
          _blob(
            bottom: -40,
            left: 90,
            size: 340,
            color: const Color(0xFFF1E6C8),
          ),

          // Soft white overlay fade
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.35),
                ],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // Icon circle
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.92),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: deepGreen,
                      size: 34,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Title
                  const Text(
                    'Savor & Soul',
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: darkText,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 14),

                  // Subtitle
                  const Text(
                    'Artisanal Flavors, Heartfelt Soul.',
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontStyle: FontStyle.italic,
                      fontSize: 17,
                      color: subtitleText,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 60),

                  // Dots indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 1,
                        color: Colors.black.withOpacity(0.18),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black.withOpacity(0.35),
                            width: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 60,
                        height: 1,
                        color: Colors.black.withOpacity(0.18),
                      ),
                    ],
                  ),

                  const Spacer(flex: 5),

                  // CTA button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deepGreen,
                        foregroundColor: const Color(0xFFF5F2EA),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor: deepGreen.withOpacity(0.3),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'GET STARTED',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blob({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color.withOpacity(0.55),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
