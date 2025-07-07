import 'package:flutter/material.dart';
import 'package:neura/core/common/app_images.dart';
import 'package:neura/core/common/routes.dart';
import 'package:neura/core/storage/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {

    final seen = SharedPrefs.onboardingSeen;
    final isLoggedIn = SharedPrefs.userToken != '';

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;


    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.main);
    } else if (seen) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A5AE0),
      body: Center(
        child: Image.asset(AppImages.logo, height: 250),
      ),
    );
  }
}
