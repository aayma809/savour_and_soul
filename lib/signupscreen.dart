import 'dart:ui';

import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  static const Color deepGreen = Color(0xFF2F5645);
  static const Color terracotta = Color(0xFF9C3E1F);
  static const Color darkText = Color(0xFF1C1C1A);
  // ignore: unused_field
  static const Color labelText = Color(0xFF2B2B29);
  static const Color hintText = Color(0xFFAFAFAA);
  static const Color fieldBorder = Color(0xFFD9D5CC);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    // TODO: hook up to Firebase Auth / your backend here
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    // Navigate to Home screen and remove SignUp from the back stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Warm blurred background photo
          // Replace with Image.asset('assets/bg.jpg', fit: BoxFit.cover)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8A6A4A),
                  Color(0xFFB48A5E),
                  Color(0xFF7A5C3E),
                  Color(0xFF9C7B52),
                ],
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(color: Colors.black.withOpacity(0.05)),
          ),

          // Centered floating card
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 20,
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F1EC).withOpacity(0.97),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Savor & Soul',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                            color: deepGreen,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Join our culinary journey.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: darkText),
                        ),
                        const SizedBox(height: 28),

                        _buildLabeledField(
                          label: 'Full Name',
                          controller: _nameController,
                          hint: 'Guest Gourmet',
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        _buildLabeledField(
                          label: 'Email Address',
                          controller: _emailController,
                          hint: 'hello@example.com',
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            final emailRegex = RegExp(
                              r'^[\w.\-]+@([\w-]+\.)+[\w-]{2,}$',
                            );
                            if (!emailRegex.hasMatch(value.trim())) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        _buildLabeledField(
                          label: 'Password',
                          controller: _passwordController,
                          hint: '••••••••',
                          icon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: hintText,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        _buildLabeledField(
                          label: 'Phone Number',
                          controller: _phoneController,
                          hint: '+1 (555) 000-0000',
                          icon: Icons.call_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        _buildLabeledField(
                          label: 'Delivery Address',
                          controller: _addressController,
                          hint: 'Search location...',
                          icon: Icons.location_on_outlined,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your delivery address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _handleSignUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: terracotta,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(color: darkText, fontSize: 15),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigate to Log In screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Log In',
                                style: TextStyle(
                                  color: deepGreen,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: labelText,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          style: const TextStyle(fontSize: 15, color: darkText),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: hintText, fontSize: 15),
            prefixIcon: Icon(icon, color: const Color(0xFF6B6B65), size: 21),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white.withOpacity(0.6),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: fieldBorder, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: fieldBorder, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: deepGreen, width: 1.6),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------
/// Placeholder destinations so this file compiles on its own.
/// Replace these with your real screens, or delete if you already
/// have HomeScreen / LoginScreen defined elsewhere in your project
/// (and import them at the top instead).
/// ---------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color(0xFF2F5645),
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Welcome to Savor & Soul!')),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        backgroundColor: const Color(0xFF2F5645),
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Log in form goes here')),
    );
  }
}
