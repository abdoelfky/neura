class ApiConstants {
  static const String baseUrl = 'https://brain-scan-nine.vercel.app/api/';
  static const localBaseUrl = 'http://127.0.0.1:5000/api';
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String resendCode = 'auth/send-code';
  static const String verifyCode = 'auth/verify-code';
  static const String forgetPassword = 'auth/forget-password';
  static const String resetPassword = 'auth/reset-password';
  static const String me = 'profile/me';
  static const String changeName = 'profile/change-name';
  static const String changeEmail = 'profile/change-email';
  static const String changePassword = 'profile/change-password';
  static const String deleteAccount = 'profile/delete-account';
  static const String myScans = 'scan/my-scans';
  static const String deleteScan = 'scan/delete';
}
