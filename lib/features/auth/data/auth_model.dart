class AuthModel {
  final String token;
  final String userName;
  final String email;

  AuthModel({
    required this.token,
    required this.userName,
    required this.email,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'] ?? '',
      userName: json['user']['userName'] ?? '',
      email: json['user']['email'] ?? '',
    );
  }
}
