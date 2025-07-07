import 'package:flutter/material.dart';
import 'package:neura/features/home/main_navigation_screen.dart';
import 'package:neura/features/notifications/notifications_screen.dart';
import 'package:neura/features/profile/account_info_screen.dart';
import 'package:neura/features/profile/change_password_screen.dart';
import 'package:neura/features/profile/settings_screen.dart';
import 'package:neura/features/splash/splash_screen.dart';
import 'package:neura/features/onboarding/screens/onboarding_screen.dart';
import 'package:neura/features/auth/screens/login_screen.dart';
import 'package:neura/features/auth/screens/signup_screen.dart';
import 'package:neura/features/auth/screens/forget_password_screen.dart';
import 'package:neura/features/auth/screens/verification_screen.dart';
import 'package:neura/features/auth/screens/reset_password_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forget = '/forget';
  static const String verification = '/verification';
  static const String reset = '/reset';
  static const String main = '/main';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String info = '/info';
  static const String changePassword = '/changePassword';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case forget:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());
      case verification:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => VerificationScreen(
            email: args['email'],
            isResetPassword: args['isResetPassword'],
          ),
        );
      case reset:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case info:
        return MaterialPageRoute(builder: (_) => const AccountInfoScreen());
      case main:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
