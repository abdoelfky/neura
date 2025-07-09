import 'package:shared_preferences/shared_preferences.dart';
import 'package:neura/features/auth/data/auth_model.dart';

class SharedPrefs {
  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // In-memory cached values
  static String userName = '';
  static String userEmail = '';
  static String userToken = '';
  static String id = '';
  static bool rememberMe = false;
  static bool onboardingSeen = false;

  static Future<void> init() async {
    final prefs = await _prefs;
    userName = prefs.getString('user_name') ?? '';
    userEmail = prefs.getString('user_email') ?? '';
    userToken = prefs.getString('user_token') ?? '';
    id = prefs.getString('user_id') ?? '';
    rememberMe = prefs.getBool('remember_me') ?? false;
    onboardingSeen = prefs.getBool('onboarding_seen') ?? false;
  }

  static Future<void> setRememberMe(bool value) async {
    final prefs = await _prefs;
    rememberMe = value;
    await prefs.setBool('remember_me', value);
  }

  static Future<void> setOnboardingSeen(bool value) async {
    final prefs = await _prefs;
    onboardingSeen = value;
    await prefs.setBool('onboarding_seen', value);
  }

  static Future<void> saveUser(AuthModel user) async {
    final prefs = await _prefs;
    userName = user.userName;
    userEmail = user.email;
    userToken = user.token;
    id = user.id;
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_name', user.userName);
    await prefs.setString('user_token', user.token);
    await prefs.setString('user_id', user.id);
  }

  static Future<void> clearUser() async {
    final prefs = await _prefs;
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_token');
    await prefs.remove('user_id');
    userName = '';
    userEmail = '';
    userToken = '';
    id = '';
  }

  static Future<String> get userNameAsync async => (await _prefs).getString('user_name') ?? '';
  static Future<String> get userEmailAsync async => (await _prefs).getString('user_email') ?? '';
  static Future<String> get userTokenAsync async => (await _prefs).getString('user_token') ?? '';
  static Future<bool> get rememberMeAsync async => (await _prefs).getBool('remember_me') ?? false;
  static Future<bool> get onboardingSeenAsync async => (await _prefs).getBool('onboarding_seen') ?? false;
}
