import 'package:flutter/material.dart';

class PreloginScreen extends StatelessWidget {
  const PreloginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title and Description
            Column(
              children: const [
                Text(
                  'Which one are you?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF4A2C2A),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WorkSans',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Are you looking to find a school for your child or are you a school looking to connect with parents',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF4A2C2A),
                    fontSize: 20,
                    height: 1.5,
                    fontFamily: 'WorkSans',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
            // Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Parent Icon
                GestureDetector(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamed('/login'); 
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F0FF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.purple[300],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Parent',
                        style: TextStyle(
                          color: Color(0xFF4A2C2A),
                          fontSize: 20,
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
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text(
                            'Notice',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A2C2A),
                            ),
                          ),
                          content: const Text(
                            'For a better experience, please use our website.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4A2C2A),
                            ),
                          ),
                          actions: [
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pop(); // Close the dialog
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 28,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFB188E3),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                      fontSize: 16,
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
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F0FF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.school,
                          size: 40,
                          color: Colors.purple[300],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'School',
                        style: TextStyle(
                          color: Color(0xFF4A2C2A),
                          fontSize: 20,
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
