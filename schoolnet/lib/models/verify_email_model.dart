class VerifyEmailRequest {
  final String email;
  final String otp;

  VerifyEmailRequest({required this.email, required this.otp});

  Map<String, dynamic> toJson() => {
        'email': email,
        'otp': otp,
      };
}

class VerifyEmailResponse {
  final bool isSuccess;
  final String? message;

  VerifyEmailResponse({required this.isSuccess, this.message});

  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) {
    final status = json['status']?.toString().toLowerCase();
    final message = json['message']?.toString().toLowerCase();
    final isSuccess = status == 'success' ||
        status == 'ok' ||
        status == 'successful' ||
        json['success'] == true ||
        json['verified'] == true ||
        json['result'] == 'verified' ||
        (message != null && message.contains('verified'));

    return VerifyEmailResponse(
      isSuccess: isSuccess,
      message: json['message']?.toString() ??
          json['error']?.toString() ??
          json['result']?.toString() ??
          (isSuccess
              ? 'Email verified successfully'
              : 'Failed to verify email'),
    );
  }
}
