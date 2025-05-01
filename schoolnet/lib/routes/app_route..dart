import 'package:flutter/material.dart';
import 'package:schoolnet/screens/login_screen.dart';
import 'package:schoolnet/screens/onboarding_screen.dart';
import 'package:schoolnet/screens/prelogin.dart';
import 'package:schoolnet/screens/reset_password_screen.dart';
import 'package:schoolnet/screens/signup_screen.dart';
import 'package:schoolnet/screens/splash_screen.dart';


class AppRoutes {
  static const String splash = '/';
  static const String preLogin = '/prelogin';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String onboardingScreen = '/onboardingScreen';
  static const String eventDetails = '/event_details';
  static const String eventHistory = '/event_history';
  static const String resetPassword = '/resetPassword';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case preLogin:
        return MaterialPageRoute(builder: (_) => const PreloginScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      // case home:
      //   return MaterialPageRoute(builder: (_) => const HomeScreen());
      // case profile:
      //   return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case onboardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
       
      case resetPassword:
        return MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(token: settings.arguments as String));
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
