import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolnet/screens/login_screen.dart';
import 'package:schoolnet/utils/responsive_utils.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.patch(
          Uri.parse(
            'https://schoolnet-be.onrender.com/api/v1/users/resetPassword/${widget.token}',
          ),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'password': _passwordController.text,
            'passwordConfirm': _confirmPasswordController.text,
          }),
        );

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.getResponsiveWidth(context, 20),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  title: Text(
                    'Success',
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
                    'Your password has been reset successfully.',
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
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Login',
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
              'Failed to reset password';
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
                          'Set New\nPassword',
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
                          -10,
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
                    'Must be at least 8 characters',
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
                    controller: _passwordController,
                    validator: _validatePassword,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock_outlined,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter your new password',
                      labelText: 'New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.getResponsiveWidth(context, 50),
                        ),
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
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    validator: _validateConfirmPassword,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock_outlined,
                        color: Colors.grey,
                      ),
                      hintText: 'Confirm your new password',
                      labelText: 'Confirm New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.getResponsiveWidth(context, 50),
                        ),
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
                      onPressed: _isLoading ? null : _handleResetPassword,
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
