import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolnet/routes/app_route..dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Sign Up',
      description: 'Choose your role: Parent, School,\nTeacher, or Student',
      illustration: 'assets/images/signup_onboarding.svg',
      color: const Color(0xFF4A2C2A),
    ),
    OnboardingPage(
      title: 'Complete Profile',
      description: 'Answer onboarding questions or set\nup school information',
      illustration: 'assets/images/complete-form_onboarding.svg',
      color: const Color(0xFF4A2C2A),
    ),
    OnboardingPage(
      title: 'Explore Schools',
      description: 'Search or receive recommendations\nbased on your needs',
      illustration: 'assets/images/exploreschool_onboarding.svg',
      color: const Color(0xFF4A2C2A),
    ),
    OnboardingPage(
      title: 'Connect',
      description: 'Message schools or access learning\nmaterials directly',
      illustration: 'assets/images/connect_onboarding.svg',
      color: const Color(0xFF4A2C2A),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.userstatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return OnboardingPageWidget(
                page: _pages[index],
                isLastPage: index == _pages.length - 1,
                onNext: _nextPage,
              );
            },
          ),
          // Positioned(
          //   bottom: 200,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: List.generate(
          //             _pages.length,
          //             (index) => AnimatedContainer(
          //               duration: const Duration(milliseconds: 300),
          //               margin: const EdgeInsets.symmetric(horizontal: 4),
          //               height: 8,
          //               width: _currentPage == index ? 24 : 8,
          //               decoration: BoxDecoration(
          //                 color:
          //                     _currentPage == index
          //                         ? const Color(0xFFB188E3)
          //                         : const Color(0xFF4A2C2A).withOpacity(0.4),
          //                 borderRadius: BorderRadius.circular(4),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String illustration;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.illustration,
    required this.color,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;
  final bool isLastPage;
  final VoidCallback onNext;

  const OnboardingPageWidget({
    Key? key,
    required this.page,
    required this.isLastPage,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: const Color(0xFFF5F0FF),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/userstatus');
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      color: Color(0xFFB188E3),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          // Illustration
          SvgPicture.asset(
            page.illustration,
            height: MediaQuery.of(context).size.height * 0.35,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 50),
          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF4A2C2A),
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'WorkSans',
            ),
          ),
          const SizedBox(height: 30),
          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF4A2C2A).withOpacity(0.8),
              fontSize: 16,
              height: 1.5,
              fontFamily: 'WorkSans',
            ),
          ),
          const SizedBox(height: 150),
          // Next Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 56,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFB188E3),
                        Color.fromARGB(255, 74, 42, 69),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: onNext,
                    child: Text(
                      isLastPage ? 'Get Started' : 'Next',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
