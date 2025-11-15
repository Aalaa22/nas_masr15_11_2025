import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nas_masr_app/screens/splash_screen.dart';
import 'package:nas_masr_app/screens/on_boarding_screen.dart';
import 'package:nas_masr_app/screens/login_screen.dart';
import 'package:nas_masr_app/screens/home.dart';
import 'package:nas_masr_app/screens/setting.dart';
import 'package:nas_masr_app/screens/profile_screen.dart';
import 'package:nas_masr_app/screens/terms_screen.dart';
import 'package:nas_masr_app/screens/privacy_policy_screen.dart';

// Centralized GoRouter configuration kept separate from main.dart
class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const Setting(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/terms',
        name: 'terms',
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('صفحة غير موجودة: ${state.uri.path}'),
      ),
    ),
    // You can add redirect logic here later if needed.
  );
}