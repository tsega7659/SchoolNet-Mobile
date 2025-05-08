import 'package:flutter/material.dart';
import 'package:schoolnet/screens/auth/login_screen.dart';
import 'package:schoolnet/screens/profile/edit_profile.dart';
import 'package:schoolnet/screens/profile/profile_screen.dart';
import 'package:schoolnet/screens/school/acadamics.dart';
import 'package:schoolnet/screens/school/admissions.dart';
import 'package:schoolnet/screens/school/fees.dart';
import 'package:schoolnet/screens/school/filter_screen.dart';
import 'package:schoolnet/screens/school/home_screen.dart';
import 'package:schoolnet/screens/school/school_detail.dart';
import 'package:schoolnet/screens/school/staff.dart';
import 'package:schoolnet/screens/school/staff_detail.dart';
import 'package:schoolnet/screens/widgets/onboarding_screen.dart' as onboarding;
import 'package:schoolnet/screens/auth/reset_password_screen.dart';
import 'package:schoolnet/screens/widgets/school_filter_screen.dart';
import 'package:schoolnet/screens/widgets/selectuser_type.dart'
    as selectUserType;
import 'package:schoolnet/screens/auth/signup_screen.dart';
import 'package:schoolnet/screens/widgets/splash_screen.dart';

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
  static const String userstatus = '/userstatus';
  static const String schoolFilter = '/school_filter';
  static const String schoolDetails = '/schooldetailpage';
  static const String acadamics = '/acadamics';
  static const String admissions = '/admissions';
  static const String fees = '/fees';
  static const String staffs = '/staffs';
  static const String staffDetails = '/staffDetails';
  static const String filtter = '/filters';
  static const String edit_profile = '/edit_profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(filterAnswers: {}),
        );
      case onboardingScreen:
        return MaterialPageRoute(
          builder: (_) => const onboarding.OnboardingScreen(),
        );
      case userstatus:
        return MaterialPageRoute(
          builder: (_) => const selectUserType.UserTypeScreen(),
        );
      case schoolFilter:
        return MaterialPageRoute(builder: (_) => const SchoolFilterScreen());
      case schoolDetails:
        return MaterialPageRoute(
          builder: (_) => const SchoolDetailPage(schoolDetails: {}),
        );
      case resetPassword:
        return MaterialPageRoute(
          builder:
              (_) => ResetPasswordScreen(token: settings.arguments as String),
        );
      case acadamics:
        return MaterialPageRoute(builder: (_) => const AcadamicsScreen());
      case admissions:
        return MaterialPageRoute(builder: (_) => AddmissionsScreen());
      case fees:
        return MaterialPageRoute(builder: (_) => const FeesScreen());
      case staffs:
        return MaterialPageRoute(builder: (_) => StaffScreen());
      case staffDetails:
        return MaterialPageRoute(builder: (_) => const StaffDetail());
      case filtter:
        return MaterialPageRoute(builder: (_) => FiltersScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case edit_profile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());

      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
