class LoginResponse {
  final String token;

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}