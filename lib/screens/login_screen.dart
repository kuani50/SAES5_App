import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../data/login_data.dart';

import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/header_home_page.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController(text: email);
    final passwordController = TextEditingController(text: password);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HeaderHomePage(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Connexion",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 40),

                CustomTextField(
                  label: "Email",
                  hintText: "exemple@email.com",
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                const SizedBox(height: 24),

                CustomTextField(
                  label: "Mot de passe",
                  hintText: "Votre mot de passe",
                  isPassword: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 40),

                PrimaryButton(
                  text: "Se connecter",
                  onPressed: () {
                    // Login logic
                    context.read<ProjectProvider>().login();

                    // Check for redirect param
                    final redirect = GoRouterState.of(
                      context,
                    ).uri.queryParameters['redirect'];
                    if (redirect != null) {
                      context.go(redirect);
                    } else {
                      context.go('/home');
                    }
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    const Text(
                      "Vous n'avez pas de compte ? ",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
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
