import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo placeholder
              const Icon(
                Icons.play_circle_filled,
                size: 100,
                color: Color(0xFFE50914),
              ),
              const SizedBox(height: 40),
              const Text(
                'Video Streaming',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              // TODO: Implement login form with CustomInput widgets
              CustomInput(
                controller: _emailController,
                hintText: 'Email',
                icon: Icons.email,
              ),
              const SizedBox(height: 16),
              CustomInput(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement login action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50914),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
