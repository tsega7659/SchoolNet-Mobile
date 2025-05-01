import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolnet/routes/app_route..dart';
import 'package:schoolnet/utils/responsive_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  void _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboardingScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color.fromARGB(255, 191, 154, 236)],
          ),
        ),
        child: Center(
          child: SizedBox(
            width: ResponsiveUtils.getResponsiveWidth(context, 300),
            height: ResponsiveUtils.getResponsiveHeight(context, 300),
            child: SvgPicture.asset(
              'assets/images/schoolnet1logo.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
