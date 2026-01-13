import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:saps5app/screens/auth_screen.dart';
import 'services/auth.dart';
import 'debug/my_http_overrides.dart';
import 'models/project.dart';
import 'providers/project_provider.dart';
import 'screens/debug/config_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/home_screen.dart';

void main() {
  if (kDebugMode) {
    HttpOverrides.global = MyHttpOverrides();
  }
  runApp(
      ChangeNotifierProvider(
        create: (BuildContext context) => AuthProvider(),
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: MaterialApp.router(
        title: 'Portfolio Viewer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: kDebugMode ? '/' : '/home',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ConfigScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) {
        final project = state.extra as Project;
        return DetailScreen(project: project);
      },
    ),
    GoRoute(
        path: '/login',
        builder: (context, state) {
          return const AuthScreen();
        }
    )
  ],
);
