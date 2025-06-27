import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScrubbrLoginScreen extends StatefulWidget {
  const ScrubbrLoginScreen({super.key});

  @override
  State<ScrubbrLoginScreen> createState() => _ScrubbrLoginScreenState();
}

class _ScrubbrLoginScreenState extends State<ScrubbrLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLogin = true;
  String errorMessage = '';
  bool isLoading = true;

  Future<void> _submit() async {
    setState(() {
      errorMessage = '';
      isLoading = true;
    });

    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'An unknown error occurred';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleModeAndSubmit(bool loginMode) {
    setState(() {
      isLogin = loginMode;
    });
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    final gradientBlue = const LinearGradient(
      colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final gradientGreen = const LinearGradient(
      colors: [Color(0xFFA8FF78), Color(0xFF78FFD6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3E9DF5), Color(0xFF96D9F9)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // White bottom card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 260,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
            ),
          ),

          // Foreground content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  'Scrubbr',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
                  ),
                ),
                Text(
                  'PRO APP',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                _buildInputField(Icons.person, 'Email or Phone', emailController),
                const SizedBox(height: 16),
                _buildInputField(Icons.lock, 'Password', passwordController, isPassword: true),

                const SizedBox(height: 10),

                // Error message
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),

                const SizedBox(height: 8),
                Text('Forgot Password?', style: TextStyle(color: Colors.black54)),

                const Spacer(flex: 3),
              ],
            ),
          ),

          // Buttons pinned at bottom over the white card
          Positioned(
            bottom: 60,
            left: 32,
            right: 32,
            child: Column(
              children: [
                _buildGradientButton(
                  'Login',
                  Colors.white,
                  gradientBlue,
                      () => _toggleModeAndSubmit(true),
                ),
                const SizedBox(height: 8),
                Text('or', style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 8),
                _buildGradientButton(
                  'Create an account',
                  Colors.black87,
                  gradientGreen,
                      () => _toggleModeAndSubmit(false),
                ),
                if (isLoading) const SizedBox(height: 16),
                if (isLoading) const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(IconData icon, String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildGradientButton(String text, Color textColor, Gradient gradient, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
