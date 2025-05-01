import 'package:flutter/material.dart';
import 'package:schoolnet/utils/responsive_utils.dart';

class PreloginScreen extends StatelessWidget {
  const PreloginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getResponsivePadding(context, 24),
          vertical: ResponsiveUtils.getResponsiveHeight(context, 16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title and Description
            Column(
              children: [
                Text(
                  'Which one are you?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF4A2C2A),
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      32,
                    ),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WorkSans',
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveHeight(context, 16),
                ),
                Text(
                  'Are you looking to find a school for your child or are you a school looking to connect with parents',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF4A2C2A),
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      20,
                    ),
                    height: 1.5,
                    fontFamily: 'WorkSans',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveHeight(context, 100)),
            // Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Parent Icon
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: Column(
                    children: [
                      Container(
                        height: ResponsiveUtils.getResponsiveHeight(
                          context,
                          80,
                        ),
                        width: ResponsiveUtils.getResponsiveWidth(context, 80),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F0FF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: ResponsiveUtils.getResponsiveWidth(context, 40),
                          color: Colors.purple[300],
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveUtils.getResponsiveHeight(context, 8),
                      ),
                      Text(
                        'Parent',
                        style: TextStyle(
                          color: const Color(0xFF4A2C2A),
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // School Icon
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveUtils.getResponsiveWidth(context, 16),
                            ),
                          ),
                          title: Text(
                            'Notice',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                20,
                              ),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4A2C2A),
                            ),
                          ),
                          content: Text(
                            'For a better experience, please use our website.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                16,
                              ),
                              color: const Color(0xFF4A2C2A),
                            ),
                          ),
                          actions: [
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        ResponsiveUtils.getResponsiveHeight(
                                          context,
                                          14,
                                        ),
                                    horizontal:
                                        ResponsiveUtils.getResponsivePadding(
                                          context,
                                          28,
                                        ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFB188E3),
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveUtils.getResponsiveWidth(
                                        context,
                                        24,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      fontSize:
                                          ResponsiveUtils.getResponsiveFontSize(
                                            context,
                                            16,
                                          ),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        height: ResponsiveUtils.getResponsiveHeight(
                          context,
                          80,
                        ),
                        width: ResponsiveUtils.getResponsiveWidth(context, 80),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F0FF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.school,
                          size: ResponsiveUtils.getResponsiveWidth(context, 40),
                          color: Colors.purple[300],
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveUtils.getResponsiveHeight(context, 8),
                      ),
                      Text(
                        'School',
                        style: TextStyle(
                          color: const Color(0xFF4A2C2A),
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
