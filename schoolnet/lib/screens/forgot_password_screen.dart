import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolnet/screens/reset_password_screen.dart';
import 'package:schoolnet/utils/responsive_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
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

  Future<void> _handleForgotPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse(
            'https://schoolnet-be.onrender.com/api/v1/users/forgotPassword',
          ),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': _emailController.text}),
        );

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.getResponsiveWidth(context, 20),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  title: Text(
                    'Reset Link Sent',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2C2A),
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        18,
                      ),
                    ),
                  ),
                  content: Text(
                    'A password reset link has been sent to your email. Please check your inbox.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        16,
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back to login screen
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: Color(0xFFB188E3),
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          );
        } else {
          final error =
              jsonDecode(response.body)['message'] ??
              'Failed to send reset link';
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text(
                    'Error',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        18,
                      ),
                    ),
                  ),
                  content: Text(
                    error,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        16,
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(
                  'Error',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      18,
                    ),
                  ),
                ),
                content: Text(
                  'An error occurred. Please try again.',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      16,
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        );
      }
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
                  margin: EdgeInsets.only(
                    bottom: ResponsiveUtils.getResponsiveHeight(context, 20),
                  ),
                  width: double.infinity,
                  height: ResponsiveUtils.getResponsiveHeight(context, 400),
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
                      Positioned(
                        top: ResponsiveUtils.getResponsiveHeight(context, 65),
                        child: Text(
                          'Reset\nPassword',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "WorkSans",
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context,
                              60,
                            ),
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A2C2A),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: ResponsiveUtils.getResponsiveHeight(
                          context,
                          -70,
                        ),
                        child: SizedBox(
                          width: ResponsiveUtils.getResponsiveWidth(
                            context,
                            300,
                          ),
                          height: ResponsiveUtils.getResponsiveHeight(
                            context,
                            300,
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/forgot_password.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveHeight(context, 20),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.getResponsivePadding(
                      context,
                      30,
                    ),
                  ),
                  child: Text(
                    "Please enter your email address.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        16,
                      ),
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveHeight(context, 30),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.getResponsivePadding(
                      context,
                      30,
                    ),
                  ),
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
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.getResponsiveWidth(context, 50),
                        ),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveHeight(context, 40),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.getResponsivePadding(
                      context,
                      30,
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: ResponsiveUtils.getResponsiveHeight(context, 50),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4A2C2A), Color(0xFFB188E3)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.getResponsiveWidth(context, 25),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleForgotPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.getResponsiveWidth(context, 25),
                          ),
                        ),
                      ),
                      child:
                          _isLoading
                              ? SizedBox(
                                width: ResponsiveUtils.getResponsiveWidth(
                                  context,
                                  20,
                                ),
                                height: ResponsiveUtils.getResponsiveHeight(
                                  context,
                                  20,
                                ),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                'Reset Password',
                                style: TextStyle(
                                  fontSize:
                                      ResponsiveUtils.getResponsiveFontSize(
                                        context,
                                        20,
                                      ),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
