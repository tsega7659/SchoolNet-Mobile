import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolnet/routes/app_route..dart';
import 'package:schoolnet/utils/responsive_utils.dart';
import 'login_screen.dart';

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
      Navigator.of(context).pushReplacementNamed(AppRoutes.preLogin);
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
          Positioned(
            bottom: ResponsiveUtils.getResponsiveHeight(context, 250),
            left: 0,
            right: 0,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.getResponsivePadding(
                            context,
                            4,
                          ),
                        ),
                        height: ResponsiveUtils.getResponsiveHeight(context, 8),
                        width:
                            _currentPage == index
                                ? ResponsiveUtils.getResponsiveWidth(
                                  context,
                                  24,
                                )
                                : ResponsiveUtils.getResponsiveWidth(
                                  context,
                                  8,
                                ),
                        decoration: BoxDecoration(
                          color:
                              _currentPage == index
                                  ? const Color(0xFFB188E3)
                                  : const Color(0xFF4A2C2A).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.getResponsiveWidth(context, 4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getResponsivePadding(context, 24),
        vertical: ResponsiveUtils.getResponsiveHeight(context, 16),
      ),
      color: const Color(0xFFF5F0FF),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: ResponsiveUtils.getResponsiveHeight(context, 30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      color: const Color(0xFFB188E3),
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        24,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveHeight(context, 40)),
          // Illustration
          SvgPicture.asset(
            page.illustration,
            height: ResponsiveUtils.getResponsiveHeight(context, 250),
            fit: BoxFit.contain,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveHeight(context, 50)),
          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF4A2C2A),
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 24),
              fontWeight: FontWeight.bold,
              fontFamily: 'WorkSans',
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveHeight(context, 30)),
          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF4A2C2A).withOpacity(0.8),
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              height: 1.5,
              fontFamily: 'WorkSans',
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveHeight(context, 150)),
          // Next Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: ResponsiveUtils.getResponsiveHeight(context, 56),
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
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.getResponsiveWidth(context, 10),
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.getResponsiveWidth(context, 10),
                        ),
                      ),
                    ),
                    onPressed: onNext,
                    child: Text(
                      isLastPage ? 'Get Started' : 'Next',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          18,
                        ),
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
