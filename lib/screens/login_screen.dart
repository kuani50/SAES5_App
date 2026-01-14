import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/header_home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers to get values
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HeaderHomePage(), // Keeping header for consistency
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                const Text(
                  "Connexion",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900, // Very bold like image
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 40),

                // Email Field
                CustomTextField(
                  label: "Email",
                  hintText: "exemple@email.com",
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                const SizedBox(height: 24),

                // Password Field
                CustomTextField(
                  label: "Mot de passe",
                  hintText: "Votre mot de passe",
                  isPassword: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 40),

                // Login Button
                PrimaryButton(
                  text: "Se connecter",
                  onPressed: () {
                    // TODO: Login logic
                    // Simulating login and returning to home
                    context.go('/home'); 
                  },
                ),
                const SizedBox(height: 16),

                // Register Link
                Row(
                  children: [
                    const Text(
                      "Vous n'avez pas de compte ? ",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Register
                        context.go('/register');
                      },
                      child: const Text(
                        "Créez-en un",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
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
    );
  }
}