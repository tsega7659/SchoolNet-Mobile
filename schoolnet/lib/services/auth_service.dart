import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolnet/models/verify_email_model.dart';

class AuthService {
  static const String _baseUrl = 'https://schoolnet-be-1.onrender.com/api/v1';

  Future<Map<String, dynamic>> signUp({
    required String phoneNumber,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/signup'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      body: jsonEncode({
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm,
      }),
    );

    print('Signup response: ${response.statusCode} ${response.body}');
    return jsonDecode(response.body);
  }

  Future<VerifyEmailResponse> verifyEmail(String email, String otp) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/users/verifyEmail'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      body: jsonEncode(VerifyEmailRequest(email: email, otp: otp).toJson()),
    );

    print('Verify response: ${response.statusCode} ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return VerifyEmailResponse.fromJson(jsonDecode(response.body));
      } catch (e) {
        return VerifyEmailResponse(
          isSuccess: true,
          message: response.body.isNotEmpty ? response.body : 'Email verified successfully',
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
      Uri.parse('$_baseUrl/users/login'),
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
    return jsonDecode(response.body);
  }
}