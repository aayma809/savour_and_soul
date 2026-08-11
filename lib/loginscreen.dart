import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:savour_and_soul/deliverylocationscreen.dart';
import 'package:savour_and_soul/signupscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _background = Color(0xFFFAF3EE);
  static const _card = Color(0xFFFDF9F6);
  static const _green = Color(0xFF2F4B3C);
  static const _brown = Color(0xFF8B4226);
  static const _text = Color(0xFF1F1F1F);
  static const _grey = Color(0xFF9A9A9A);
  static const _border = Color(0xFFE3DDD6);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter your email address and password.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const DeliveryLocationScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      if (error.code == 'user-not-found' || error.code == 'invalid-credential') {
        _showMessage('No account found for this email. Please sign up first.');
      } else if (error.code == 'wrong-password') {
        _showMessage('Incorrect password. Please try again.');
      } else {
        _showMessage(error.message ?? 'Unable to log in. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 70),
              const Text(
                'Savor & Soul',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: _green,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome back',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: _text.withOpacity(.75)),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Email Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _text)),
                    const SizedBox(height: 10),
                    _field(
                      controller: _emailController,
                      hint: 'guest@example.com',
                      icon: Icons.mail_outline,
                    ),
                    const SizedBox(height: 20),
                    const Text('Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _text)),
                    const SizedBox(height: 10),
                    _field(
                      controller: _passwordController,
                      hint: 'Enter your password',
                      icon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffix: IconButton(
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: _grey),
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(backgroundColor: _brown, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                        child: _isLoading
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('LOG IN', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: .7)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Do not have an account? ', style: TextStyle(color: _text.withOpacity(.8), fontSize: 15)),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const SignUpScreen())),
                    child: const Text('Sign Up', style: TextStyle(color: _green, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({required TextEditingController controller, required String hint, required IconData icon, bool obscureText = false, Widget? suffix}) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: _border), borderRadius: BorderRadius.circular(14)),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: icon == Icons.mail_outline ? TextInputType.emailAddress : TextInputType.visiblePassword,
        decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: _grey), prefixIcon: Icon(icon, color: _grey, size: 22), suffixIcon: suffix, border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12)),
      ),
    );
  }
}
