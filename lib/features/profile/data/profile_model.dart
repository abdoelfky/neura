// features/profile/data/profile_model.dart
class ProfileModel {
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String gender;
  final String birthDate;

  ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.gender,
    required this.birthDate,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      birthDate: json['birthDate'] ?? '',
    );
  }
}
