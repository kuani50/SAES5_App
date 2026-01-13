import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'debug/my_http_overrides.dart';
import 'models/project.dart';
import 'providers/project_provider.dart';
import 'screens/debug/config_screen.dart';
import 'screens/event_detail_screen.dart'; 
import 'models/event_model.dart'; 
import 'screens/home_screen.dart';
import 'screens/club_screen.dart'; // Import

void main() {
  if (kDebugMode) {
    HttpOverrides.global = MyHttpOverrides();
  }
  runApp(const MyApp());
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
        final event = state.extra as EventModel;
        return EventDetailScreen(event: event);
      },
    ),
    GoRoute(
      path: '/clubs', // Nouvelle route
      builder: (context, state) => const ClubScreen(),
    ),
  ],
);
