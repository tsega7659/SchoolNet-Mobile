// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:schoolnet/screens/home_screen.dart';
// import 'package:schoolnet/screens/signup_screen.dart';
// import 'package:schoolnet/screens/forgot_password_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isPasswordVisible = false;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your email';
//     }
//     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//       return 'Incorrect email';
//     }
//     return null;
//   }

//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your password';
//     }
//     if (value.length < 8) {
//       return 'Incorrect password';
//     }
//     return null;
//   }

//   void _togglePasswordVisibility() {
//     setState(() {
//       _isPasswordVisible = !_isPasswordVisible;
//     });
//   }

//   Future<void> _handleLogin() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         final response = await http.post(
//           Uri.parse('https://schoolnet-be.onrender.com/api/v1/users/login'),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode({
//             'email': _emailController.text,
//             'password': _passwordController.text,
//           }),
//         );

//         setState(() {
//           _isLoading = false;
//         });

//         if (response.statusCode == 200) {
//           jsonDecode(response.body);

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const HomeScreen()),
//           );
//         } else {
//           final error = jsonDecode(response.body)['message'] ?? 'Login failed';
//           showDialog(
//             context: context,
//             builder:
//                 (context) => AlertDialog(
//                   title: const Text('Error'),
//                   content: Text(error),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('OK'),
//                     ),
//                   ],
//                 ),
//           );
//         }
//       } catch (e) {
//         setState(() {
//           _isLoading = false;
//         });
//         showDialog(
//           context: context,
//           builder:
//               (context) => AlertDialog(
//                 title: const Text('Error'),
//                 content: const Text('An error occurred. Please try again.'),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('OK'),
//                   ),
//                 ],
//               ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(bottom: 20),
//                   width: double.infinity,
//                   height: 400,
//                   decoration: const BoxDecoration(
//                     color: Color(0xFFB188E3),
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(800),
//                       bottomRight: Radius.circular(800),
//                     ),
//                   ),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Positioned(
//                         top: 65,
//                         child: Text(
//                           'login',
//                           style: TextStyle(
//                             fontFamily: "WorkSans",
//                             fontSize: 80,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF4A2C2A),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: -15,
//                         child: SizedBox(
//                           width: 250,
//                           height: 250,
//                           child: Center(
//                             child: Image.asset(
//                               'assets/images/login_image.png',
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: TextFormField(
//                     controller: _emailController,
//                     validator: _validateEmail,
//                     decoration: InputDecoration(
//                       prefixIcon: const Icon(
//                         Icons.email_outlined,
//                         color: Colors.grey,
//                       ),
//                       hintText: 'email@gmail.com',
//                       labelText: 'Email',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(50),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: TextFormField(
//                     controller: _passwordController,
//                     validator: _validatePassword,
//                     obscureText: !_isPasswordVisible,
//                     decoration: InputDecoration(
//                       prefixIcon: const Icon(
//                         Icons.lock_outlined,
//                         color: Colors.grey,
//                       ),
//                       hintText: 'Enter your password',
//                       labelText: 'Password',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(50),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _isPasswordVisible
//                               ? Icons.visibility_outlined
//                               : Icons.visibility_off_outlined,
//                           color: Colors.grey,
//                         ),
//                         onPressed: _togglePasswordVisibility,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const ForgotPasswordScreen(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         'Forgot Password?',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 60),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: Container(
//                     width: double.infinity,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF4A2C2A), Color(0xFFB188E3)],
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: ElevatedButton(
//                       onPressed: _isLoading ? null : _handleLogin,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.transparent,
//                         shadowColor: Colors.transparent,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                       ),
//                       child:
//                           _isLoading
//                               ? const CircularProgressIndicator(
//                                 color: Colors.white,
//                               )
//                               : const Text(
//                                 'Login',
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   '- or -',
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 10),

//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Don't have an account?",
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const SignUpScreen(),
//                           ),
//                         );
//                       },
//                       style: TextButton.styleFrom(
//                         foregroundColor: const Color(0xFFB188E3),
//                       ),
//                       child: const Text(
//                         " Sign up",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:schoolnet/screens/auth/signup_screen.dart';
import 'package:schoolnet/screens/auth/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Incorrect email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Incorrect password';
    }
    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate a successful login and navigate to HomeScreen
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacementNamed(context, '/school_filter');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: double.infinity,
                  height: 300,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB188E3),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(800),
                      bottomRight: Radius.circular(800),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Positioned(
                        top: 20,
                        child: Text(
                          'login',
                          style: TextStyle(
                            fontFamily: "WorkSans",
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A2C2A),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -15,
                        child: SizedBox(
                          width: 250,
                          height: 250,
                          child: Center(
                            child: Image.asset(
                              'assets/images/login_image.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: _emailController,
                    validator: _validateEmail,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.grey,
                      ),
                      hintText: 'email@gmail.com',
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: _validatePassword,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock_outlined,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4A2C2A), Color(0xFFB188E3)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '- or -',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFB188E3),
                      ),
                      child: const Text(
                        " Sign up",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
