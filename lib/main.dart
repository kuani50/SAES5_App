import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:saps5app/providers/auth_provider.dart';
import 'package:saps5app/screens/auth_screen.dart';
import 'debug/my_http_overrides.dart';
import 'models/project.dart';
import 'providers/project_provider.dart';
import 'screens/debug/config_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/home_screen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  // runApp(
  //     ChangeNotifierProvider(
  //       create: (BuildContext context) => AuthProvider(),
  //       child: MyApp(),
  //     )
  // );

  //Launch class with default App class
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp.router(title: "Orient'Express", routerConfig: _router),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: kDebugMode ? '/debug/apiconfig' : '/home',
  routes: [
    GoRoute(
      path: '/debug/apiconfig',
      builder: (context, state) => const ConfigScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
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
      },
    ),
  ],
);
