import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'debug/my_http_overrides.dart';
import 'providers/project_provider.dart';
import 'screens/debug/config_screen.dart';
import 'screens/raid_detail_screen.dart';
import 'screens/home_screen.dart';
import 'screens/club_screen.dart';
import 'screens/club_detail_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/user_races_screen.dart';
import 'screens/manage_team_screen.dart';
import 'models/raid_model.dart';
import 'models/club_model.dart';
import 'models/course_model.dart'; // Added import
import 'data/raid_data.dart';
import 'screens/raid_registration_screen.dart';
import 'screens/course_detail_screen.dart'; // Added import

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
      providers: [ChangeNotifierProvider(create: (_) => ProjectProvider())],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Orient Express',
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
    GoRoute(path: '/', builder: (context, state) => const ConfigScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/details',
      builder: (context, state) {
        final raid = state.extra as RaidModel;
        return RaidDetailScreen(raid: raid);
      },
    ),
    GoRoute(
      path: '/clubs',
      builder: (context, state) => ClubScreen(allEvents: allRaids),
    ),
    GoRoute(
      path: '/club-details',
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        return ClubDetailScreen(
          club: extra['club'] as ClubModel,
          allEvents: extra['events'] as List<RaidModel>,
        );
      },
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/my-races',
      builder: (context, state) => const UserRacesScreen(),
    ),
    GoRoute(
      path: '/raid-registration',
      builder: (context, state) {
        final raidName = state.uri.queryParameters['raidName'];
        final initialStepStr = state.uri.queryParameters['initialStep'];
        final initialStep = int.tryParse(initialStepStr ?? '') ?? 2;

        return RaidRegistrationScreen(
          raidName: raidName,
          initialStep: initialStep,
        );
      },
    ),
    GoRoute(
      path: '/manage-team',
      builder: (context, state) => const ManageTeamScreen(),
    ),
    GoRoute(
      path: '/course-details',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final course = extras['course'] as CourseModel;
        final raid = extras['raid'] as RaidModel;
        return CourseDetailScreen(course: course, raid: raid);
      },
    ),
  ],
);
