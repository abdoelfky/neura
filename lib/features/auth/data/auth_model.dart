class AuthModel {
  final String token;
  final String userName;
  final String email;
  final String id;

  AuthModel({
    required this.token,
    required this.userName,
    required this.email,
    required this.id,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'] ?? json['user']['token']?? '',
      userName: json['user']['userName'] ?? '',
      email: json['user']['email'] ?? '',
      id: json['user']['id'] ?? '',
    );
  }
}
