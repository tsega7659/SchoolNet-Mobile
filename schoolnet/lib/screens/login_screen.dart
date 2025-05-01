import 'package:flutter/material.dart';
import 'package:schoolnet/screens/home_screen.dart';
import 'package:schoolnet/screens/signup_screen.dart';
import 'package:schoolnet/screens/forgot_password_screen.dart';
import 'package:schoolnet/utils/responsive_utils.dart';

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

      // Simulate API call delay
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                        'login',
                        style: TextStyle(
                          fontFamily: "WorkSans",
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            80,
                          ),
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A2C2A),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: ResponsiveUtils.getResponsiveHeight(context, -15),
                      child: SizedBox(
                        width: ResponsiveUtils.getResponsiveWidth(context, 250),
                        height: ResponsiveUtils.getResponsiveHeight(
                          context,
                          250,
                        ),
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
              SizedBox(
                height: ResponsiveUtils.getResponsiveHeight(context, 20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.getResponsivePadding(context, 30),
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
                height: ResponsiveUtils.getResponsiveHeight(context, 20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.getResponsivePadding(context, 30),
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
                    hintText: 'Enter your password',
                    labelText: 'Password',
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
                height: ResponsiveUtils.getResponsiveHeight(context, 10),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.getResponsivePadding(context, 30),
                ),
                child: Row(
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
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            16,
                          ),
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsiveHeight(context, 60),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.getResponsivePadding(context, 30),
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
                    onPressed: _isLoading ? null : _handleLogin,
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
                              'Login',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.getResponsiveFontSize(
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
              SizedBox(
                height: ResponsiveUtils.getResponsiveHeight(context, 20),
              ),
              Text(
                '- or -',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsiveHeight(context, 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        16,
                      ),
                      color: Colors.grey,
                    ),
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
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          20,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsiveHeight(context, 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
