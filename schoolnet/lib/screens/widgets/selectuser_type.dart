import 'package:flutter/material.dart';

class UserTypeScreen extends StatelessWidget {
  const UserTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Centered Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Which one are you',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: "WorkSans",
                    color: Color(0xFF6440A2),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    'Are you looking to find a school for your child or are you a school looking to connect with parents',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF614B7D),
                      fontFamily: "WorkSans",
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Parent Button
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to the /login page
                          Navigator.of(context).pushNamed('/login');
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: const Color.fromARGB(
                            255,
                            229,
                            206,
                            234,
                          ),
                        ),
                        child: Image.asset("assets/images/person_icon.png"),
                      ),
                    ),
                    const SizedBox(width: 40),
                    // School Button
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          // Show popup dialog
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
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF4A2C2A),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: const Color.fromARGB(
                            255,
                            229,
                            206,
                            234,
                          ),
                        ),
                        child: Image.asset("assets/images/school_icon.png"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Next Button at Bottom-Right
          Positioned(
            bottom: 100,
            right: 20,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB188E3), Color.fromARGB(255, 74, 42, 69)],
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
                onPressed: () {
                  // Add your navigation or action logic here
                },
                child: const Text(
                  'Next',
                  style: TextStyle(
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
    );
  }
}
