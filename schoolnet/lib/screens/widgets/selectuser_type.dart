import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schoolnet/services/auth_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  _UserTypeScreenState createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    _clearExistingRole();
  }

  Future<void> _checkAuthentication() async {
    await _authService.ensureInitialized();
    print('Checking authentication, token: ${_authService.jwtToken}');
    if (_authService.jwtToken == null) {
      print('No token found, redirecting to login');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to continue')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      print('Token found, proceeding: ${_authService.jwtToken}');
    }
  }

  Future<void> _clearExistingRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
    await prefs.remove('onboarding_completed');
    print('Cleared existing role and onboarding status');
  }

  Future<void> _updateUserRole(String role) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = _authService.jwtToken;
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      print('Updating user role to: $role with token: $token');
      final response = await http.patch(
        Uri.parse('https://schoolnet-be.onrender.com/api/v1/users/updateRole'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Cookie': 'jwt=$token',
        },
        body: jsonEncode({'role': role}),
      );

      print('Update role response: ${response.statusCode} ${response.body}');
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_role', role);
        print('User role saved: $role');

        if (role == 'parent') {
          Navigator.pushReplacementNamed(context, '/school_filter');
        } else if (role == 'school') {
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
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'For a better experience, please use our website.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4A2C2A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
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
                        onPressed: () async {
                          // Close the dialog
                          Navigator.of(context).pop();
                          // Open the website
                          final Uri url =
                              Uri.parse('https://schoolnet-alpha.vercel.app/');
                          try {
                            final bool canLaunch = await canLaunchUrl(url);
                            if (!canLaunch) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Cannot launch website'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              return;
                            }

                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                              webViewConfiguration: const WebViewConfiguration(
                                enableJavaScript: true,
                                enableDomStorage: true,
                              ),
                            );
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error launching website: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Go to Website',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
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
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(json['message'] ?? 'Failed to update role')),
        );
      }
    } catch (e) {
      print('Error updating role: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                    Column(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () => _updateUserRole('parent'),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                              backgroundColor:
                                  const Color.fromARGB(255, 229, 206, 234),
                            ),
                            child: Image.asset("assets/images/person_icon.png"),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Parent',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A2C2A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 40),
                    Column(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () => _updateUserRole('school'),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                              backgroundColor:
                                  const Color.fromARGB(255, 229, 206, 234),
                            ),
                            child: Image.asset("assets/images/school_icon.png"),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'School',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A2C2A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!_isLoading)
            Positioned(
              bottom: 100,
              right: 20,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFB188E3),
                      Color.fromARGB(255, 74, 42, 69)
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
                  onPressed: null,
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
