import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolnet/routes/app_route..dart';

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
    final Size screenSize = MediaQuery.of(context).size;

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
            width: screenSize.width * 0.80,
            height: screenSize.height * 0.3,
            child: SvgPicture.asset(
              'assets/images/schoolnetlogo.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
