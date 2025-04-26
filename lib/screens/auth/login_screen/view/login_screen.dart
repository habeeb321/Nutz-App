import 'package:flutter/material.dart';
import 'package:nutz_app/screens/auth/bottom_navigation/view/bottom_navigation.dart';
import 'package:nutz_app/screens/auth/login_screen/controller/login_controller.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final login = Provider.of<LoginController>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.apple, color: Colors.white, size: 40),
                  SizedBox(width: 8),
                  Text(
                    'Apple',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: login.isLoading
                      ? null
                      : () => _handleGoogleSignIn(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 0,
                  ),
                  child: login.isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const _GoogleSignInButtonContent(),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    final login = Provider.of<LoginController>(context, listen: false);
    final user = await login.signInWithGoogle(context);
    if (user != null) {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigation()),
        );
      }
    }
  }
}

class _GoogleSignInButtonContent extends StatelessWidget {
  const _GoogleSignInButtonContent();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage('assets/google_logo.png'),
          height: 20,
          width: 20,
        ),
        SizedBox(width: 12),
        Text(
          'Continue with Google',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
