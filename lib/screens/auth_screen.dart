import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saps5app/screens/home_screen.dart';
import 'package:saps5app/services/auth.dart';
import 'login_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          switch (auth.isAuthenticated) {
            case true:
              return const HomeScreen();
            default:
              return const LoginForm();
          }
        },
      ),
    );
  }
}
