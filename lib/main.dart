import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:saps5app/providers/auth_provider.dart';
import 'package:saps5app/screens/auth_screen.dart';
import 'debug/my_http_overrides.dart';
import 'providers/api_provider.dart';
import 'package:saps5app/providers/project_provider.dart';
import 'screens/debug/config_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/home_screen.dart';
import 'screens/club_screen.dart';
import 'screens/club_detail_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'models/event_model.dart';
import 'models/club_model.dart';
import 'data/dummy_data.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApiProvider()),
        ChangeNotifierProxyProvider<ApiProvider, AuthProvider>(
          create: (context) => AuthProvider(context.read<ApiProvider>()),
          update: (context, apiProvider, previousAuth) =>
              AuthProvider(apiProvider),
        ),
        ChangeNotifierProxyProvider<ApiProvider, ProjectProvider>(
          create: (context) => ProjectProvider(context.read<ApiProvider>()),
          update: (context, apiProvider, previousProject) =>
              ProjectProvider(apiProvider),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'Orient Express',
        theme: ThemeData(
          // Using deepPurple as requested
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
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
        final event = state.extra as EventModel;
        return EventDetailScreen(event: event);
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const AuthScreen();
      },
    ),
    GoRoute(
      path: '/clubs',
      builder: (context, state) => ClubScreen(allEvents: dummyEvents),
    ),
    GoRoute(
      path: '/club-details',
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        return ClubDetailScreen(
          club: extra['club'] as ClubModel,
          allEvents: extra['events'] as List<EventModel>,
        );
      },
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);
