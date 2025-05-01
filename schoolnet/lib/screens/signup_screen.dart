import 'package:flutter/material.dart';
import 'package:schoolnet/screens/login_screen.dart';
import 'package:schoolnet/utils/responsive_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String _selectedRole = 'Parent';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
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

  void _handleSignUp() {
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
          MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                height: ResponsiveUtils.getResponsiveHeight(context, 350),
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
                        'Sign Up',
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
                      bottom: ResponsiveUtils.getResponsiveHeight(context, -10),
                      child: SizedBox(
                        width: ResponsiveUtils.getResponsiveWidth(context, 300),
                        height: ResponsiveUtils.getResponsiveHeight(
                          context,
                          300,
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/signup_image.png',
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
                  controller: _nameController,
                  validator: _validateName,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                    ),
                    hintText: 'Enter your name',
                    labelText: 'Name',
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
                child: DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.people_outline,
                      color: Colors.grey,
                    ),
                    labelText: 'Role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.getResponsiveWidth(context, 50),
                      ),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  items:
                      ['Parent', 'School', 'Teacher', 'Student']
                          .map(
                            (role) => DropdownMenuItem(
                              value: role,
                              child: Text(role),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
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
                height: ResponsiveUtils.getResponsiveHeight(context, 20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.getResponsivePadding(context, 30),
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
                    hintText: 'Confirm your password',
                    labelText: 'Confirm Password',
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
                    onPressed: _isLoading ? null : _handleSignUp,
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
                              'Sign Up',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFB188E3),
                    ),
                    child: Text(
                      "Login",
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
