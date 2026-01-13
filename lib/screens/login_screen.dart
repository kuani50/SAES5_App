import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/header_home_page.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController(text: "thomas.dupont@email.com");
    final passwordController = TextEditingController(text: "password123");

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
                // Titre
                const Text(
                  "Connexion",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 40),

                // Champ Email
                CustomTextField(
                  label: "Email",
                  hintText: "exemple@email.com",
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                const SizedBox(height: 24),

                // Champ Mot de passe
                CustomTextField(
                  label: "Mot de passe",
                  hintText: "Votre mot de passe",
                  isPassword: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 40),

                // Bouton Se connecter
                PrimaryButton(
                  text: "Se connecter",
                  onPressed: () {
                    // Pour l'instant, on simule une connexion et on retourne à l'accueil
                    context.go('/home'); 
                  },
                ),
                const SizedBox(height: 16),

                // Lien Inscription
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
