import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:savour_and_soul/services/firebase_service.dart';

import 'deliverylocationscreen.dart';

class _AppColors {
  static const background = Color(0xFFFAF3EE);
  static const cardBackground = Color(0xFFFDF9F6);
  static const darkGreen = Color(0xFF2F4B3C);
  static const brown = Color(0xFF8B4226);
  static const textDark = Color(0xFF1F1F1F);
  static const textGrey = Color(0xFF9A9A9A);
  static const borderGrey = Color(0xFFE3DDD6);
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showMessage('Passwords do not match');
      return;
    }
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      _showMessage('Please complete all fields');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
      );
      if (!mounted) return;
      // On successful account creation, send the user
      // straight to set their delivery location.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DeliveryLocationScreen()),
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      final message = switch (error.code) {
        'email-already-in-use' => 'An account already exists. Please log in.',
        'operation-not-allowed' =>
          'Email/password sign-up is not enabled in Firebase.',
        'invalid-email' => 'Please enter a valid email address.',
        'weak-password' => 'Use a password with at least 6 characters.',
        'network-request-failed' =>
          'Check your internet connection and try again.',
        _ => error.message ?? 'Unable to create your account.',
      };
      _showMessage(message);
    } catch (_) {
      if (!mounted) return;
      _showMessage(
        'Authentication is unavailable. Fully restart the app after running flutter pub get.',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signUpWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    try {
      final credential = await FirebaseService.signInWithGoogle();
      if (credential == null) {
        // User closed the Google account picker.
        return;
      }
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DeliveryLocationScreen()),
      );
    } on FirebaseAuthException catch (error) {
      debugPrint(
        'Google sign-in FirebaseAuthException: ${error.code} - ${error.message}',
      );
      if (!mounted) return;
      _showMessage(error.message ?? 'Google sign-in failed. Please try again.');
    } catch (error, stackTrace) {
      debugPrint('Google sign-in error: $error');
      debugPrint('$stackTrace');
      if (!mounted) return;
      _showMessage('Google sign-in failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 70),

              // ── Title ──
              const Text(
                'Savor & Soul',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily:
                      'Georgia', // swap for a serif font like Playfair Display
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: _AppColors.darkGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create Your Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: _AppColors.textDark.withOpacity(0.75),
                ),
              ),

              const SizedBox(height: 32),

              // ── Card ──
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _AppColors.cardBackground,
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
                    // Name
                    const Text(
                      'Full Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: _AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _nameController,
                      hint: 'Jane Doe',
                      icon: Icons.person_outline,
                      obscure: false,
                    ),

                    const SizedBox(height: 20),

                    // Email
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: _AppColors.textDark,
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

                    // Password
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: _AppColors.textDark,
                      ),
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
                          color: _AppColors.textGrey,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Confirm Password
                    const Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: _AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      hint: '',
                      icon: Icons.lock_outline,
                      obscure: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: _AppColors.textGrey,
                        ),
                        onPressed: () {
                          setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Sign Up button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _AppColors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Sign Up',
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

                    const SizedBox(height: 20),

                    // ── Divider ──
                    Row(
                      children: [
                        Expanded(child: Divider(color: _AppColors.borderGrey)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: _AppColors.textGrey,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: _AppColors.borderGrey)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Continue with Google ──
                    SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: _isGoogleLoading ? null : _signUpWithGoogle,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _AppColors.borderGrey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isGoogleLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: _AppColors.darkGreen,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const _GoogleLogo(size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: _AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Log in row ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: _AppColors.textDark.withValues(alpha: 0.8),
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: _AppColors.darkGreen,
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
        border: Border.all(color: _AppColors.borderGrey),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        obscuringCharacter: '●',
        style: const TextStyle(fontSize: 16, color: _AppColors.textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: _AppColors.textGrey),
          prefixIcon: Icon(icon, color: _AppColors.textGrey, size: 22),
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

class LoginScreen {
  const LoginScreen();
}

/// Loads the real Google 'G' logo from assets/icons/google_logo.png.
/// Falls back to a plain "G" badge if the asset hasn't been added yet,
/// so the button never breaks the layout.
class _GoogleLogo extends StatelessWidget {
  final double size;
  const _GoogleLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/google_logo.png',
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFDADCE0)),
        ),
        child: Text(
          'G',
          style: TextStyle(
            fontSize: size * 0.65,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4285F4),
            height: 1,
          ),
        ),
      ),
    );
  }
}
