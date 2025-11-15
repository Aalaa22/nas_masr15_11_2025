// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:nas_masr_app/screens/on_boarding_screen.dart';
import 'package:nas_masr_app/screens/login_screen.dart';
import 'package:nas_masr_app/screens/home.dart';
//import '../welcome_screen.dart'; // الشاشة اللي هينتقل إليها بعد الـ Splash

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // انتظار قصير ثم تحديد الوجهة حسب الحالة المخزّنة
    Future.delayed(const Duration(seconds:2), () async {
      final prefs = await SharedPreferences.getInstance();
      final onboardingDone = prefs.getBool('onboarding_done') ?? false;
      final token = prefs.getString('auth_token');

      Widget next;
      if (token != null && token.isNotEmpty) {
        next = const HomeScreen();
      } else if (onboardingDone) {
        next = const LoginScreen();
      } else {
        next = const OnboardingScreen();
      }

      if (!mounted) return;
      // استخدم go_router للتوجيه بدل Navigator
      if (next is HomeScreen) {
        context.go('/home');
      } else if (next is LoginScreen) {
        context.go('/login');
      } else {
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // أو اللون اللي في الخلفية في تصميمك
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/splash.png',
          fit: BoxFit.cover, // يغطي كامل العرض والارتفاع مع الحفاظ على النسبة
        ),
      ),
    );
  }
}