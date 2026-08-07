import 'package:flutter/material.dart';
import 'package:savour_and_soul/signupscreen.dart';

// ─────────────────────────────────────────────────────────────
// Colors used across the screen — tweak these to fine-tune the look
// ─────────────────────────────────────────────────────────────
class AppColors {
  static const background = Color(0xFFFAF3EE);
  static const cardBackground = Color(0xFFFDF9F6);
  static const darkGreen = Color(0xFF2F4B3C);
  static const brown = Color(0xFF8B4226);
  static const textDark = Color(0xFF1F1F1F);
  static const textGrey = Color(0xFF9A9A9A);
  static const borderGrey = Color(0xFFE3DDD6);
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 90),

              // ── Title ──
              Text(
                'Savor & Soul',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily:
                      'Georgia', // swap for a serif font like Playfair Display
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: AppColors.darkGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.textDark.withOpacity(0.75),
                ),
              ),

              const SizedBox(height: 40),

              // ── Card ──
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email label
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _emailController,
                      hint: 'guest@example.com',
                      icon: Icons.mail_outline,
                      obscure: false,
                    ),

                    const SizedBox(height: 20),

                    // Password label + forgot password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO: navigate to forgot password flow
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.darkGreen,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _passwordController,
                      hint: '',
                      icon: Icons.lock_outline,
                      obscure: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textGrey,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Log In button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: handle login
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Sign up row ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: AppColors.textDark.withOpacity(0.8),
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool obscure,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderGrey),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        obscuringCharacter: '●',
        style: const TextStyle(fontSize: 16, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textGrey),
          prefixIcon: Icon(icon, color: AppColors.textGrey, size: 22),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 12,
          ),
        ),
      ),
    );
  }
}
