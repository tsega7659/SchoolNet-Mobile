import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolnet/models/verify_email_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'https://schoolnet-be.onrender.com';
  String? _jwtToken;
  bool _isInitialized = false;

  // Singleton pattern to ensure a single instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    _initialize();
  }

  // Initialize the token
  Future<void> _initialize() async {
    await _loadToken();
    _isInitialized = true;
  }

  // Ensure initialization is complete
  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await _initialize();
    }
  }

  // Getter for JWT token
  String? get jwtToken => _jwtToken;

  // Load token from SharedPreferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _jwtToken = prefs.getString('jwt_token');
    print('Loaded token from SharedPreferences: $_jwtToken');
  }

  // Store JWT token after login
  Future<void> setJwtToken(String token) async {
    _jwtToken = token; // Set in-memory token first
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    print('Token saved to SharedPreferences: $token');
  }

  // Clear JWT token (e.g., on logout)
  Future<void> clearJwtToken() async {
    _jwtToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    print('Cleared token from SharedPreferences');
  }

  Future<void> logout() async {
    await clearJwtToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
  }

  Future<Map<String, dynamic>> signUp({
    required String phoneNumber,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      final payload = {
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm,
      };
      print('Sending signup request with payload: $payload');

      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/users/signup'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
        },
        body: jsonEncode(payload),
      );

      print('Signup response: ${response.statusCode} ${response.body}');

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonResponse;
      } else {
        String errorMessage = jsonResponse['message'] ?? 'Signup failed';
        if (jsonResponse['error'] != null &&
            jsonResponse['error']['stack'] != null) {
          errorMessage += '\nDetails: ${jsonResponse['error']['stack']}';
        }
        print('Signup error: $errorMessage');
        return {
          'status': 'error',
          'message': errorMessage,
        };
      }
    } catch (e) {
      print('Signup exception: $e');
      return {
        'status': 'error',
        'message': 'Network or server error: $e',
      };
    }
  }

  Future<VerifyEmailResponse> verifyEmail(String email, String otp) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/api/v1/users/verifyEmail'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      body: jsonEncode(VerifyEmailRequest(email: email, otp: otp).toJson()),
    );

    print('Verify response: ${response.statusCode} ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final json = jsonDecode(response.body);
        return VerifyEmailResponse.fromJson(json);
      } catch (e) {
        return VerifyEmailResponse(
          isSuccess: true,
          message: response.body.isNotEmpty
              ? response.body
              : 'Email verified successfully',
        );
      }
    } else {
      try {
        final json = jsonDecode(response.body);
        return VerifyEmailResponse(
          isSuccess: false,
          message: json['message']?.toString() ??
              json['error']?.toString() ??
              'Failed to verify email',
        );
      } catch (e) {
        return VerifyEmailResponse(
          isSuccess: false,
          message: 'Failed to verify email: ${response.body}',
        );
      }
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/v1/users/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print('Login response: ${response.statusCode} ${response.body}');
    final json = jsonDecode(response.body);
    if (json['status'] == 'success' && json['token'] != null) {
      await setJwtToken(json['token'] as String);
      print('Token set in AuthService: ${_jwtToken}');
    } else {
      print('Login failed or no token in response');
    }
    return json;
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/v1/users/forgotPassword'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      body: jsonEncode({'email': email}),
    );

    print('Forgot password response: ${response.statusCode} ${response.body}');
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> verifyForgotResetOtp({
    required String email,
    required String otp,
  }) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/api/v1/users/verifyForgotResetOtp'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      body: jsonEncode({
        'email': email,
        'otp': otp,
      }),
    );

    print(
        'Verify forgot reset OTP response: ${response.statusCode} ${response.body}');
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String password,
    required String passwordConfirm,
  }) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/api/v1/users/resetPassword'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      body: jsonEncode({
        'token': token,
        'password': password,
        'passwordConfirm': passwordConfirm,
      }),
    );

    print('Reset password response: ${response.statusCode} ${response.body}');
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateMyPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (_jwtToken == null) {
      return {
        'status': 'error',
        'message': 'User not authenticated',
      };
    }

    final response = await http.patch(
      Uri.parse('$_baseUrl/api/v1/users/updateMyPassword'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Authorization': 'Bearer $_jwtToken',
      },
      body: jsonEncode({
        'passwordCurrent': currentPassword,
        'password': newPassword,
        'passwordConfirm': confirmPassword,
      }),
    );

    print('Update password response: ${response.statusCode} ${response.body}');
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateRole(String role) async {
    if (_jwtToken == null) {
      return {
        'status': 'error',
        'message': 'User not authenticated',
      };
    }

    final response = await http.patch(
      Uri.parse('$_baseUrl/api/v1/users/updateRole'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Cookie': 'jwt=$_jwtToken', 
      },
      body: jsonEncode({'role': role}),
    );

    print('Update role response: \\${response.statusCode} \\${response.body}');
    return jsonDecode(response.body);
  }
}
