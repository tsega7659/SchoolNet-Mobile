import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:schoolnet/screens/login_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _gradientAndTextController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _gradientStartAnimation;
  late Animation<Color?> _gradientEndAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _textScaleAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: math.pi * 2).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.5,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.5,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50.0,
      ),
    ]).animate(_scaleController);
    _gradientAndTextController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _gradientStartAnimation = ColorTween(
      begin: const Color(0xFF2B2447),
      end: const Color(0xFFB188E3),
    ).animate(
      CurvedAnimation(
        parent: _gradientAndTextController,
        curve: Curves.easeInOut,
      ),
    );
    _gradientEndAnimation = ColorTween(
      begin: const Color(0xFF4A2C2A),
      end: Color(0xFF614B7D),
    ).animate(
      CurvedAnimation(
        parent: _gradientAndTextController,
        curve: Curves.easeInOut,
      ),
    );
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradientAndTextController, curve: Curves.easeIn),
    );
    _textScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _gradientAndTextController,
        curve: Curves.easeOut,
      ),
    );

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    await _rotationController.forward();
    await _scaleController.forward();
    await _gradientAndTextController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _gradientAndTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _gradientStartAnimation,
          _gradientEndAnimation,
        ]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,

                colors: [
                  _gradientStartAnimation.value ?? const Color(0xFF2B2447),
                  _gradientEndAnimation.value ?? const Color(0xFF51457F),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _rotationAnimation,
                      _scaleAnimation,
                    ]),
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: SizedBox(
                            width: screenSize.width * 0.80,
                            height: screenSize.height * 0.3,
                            child: SvgPicture.asset(
                              'assets/images/schoolnet1logo.svg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
