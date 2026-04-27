import 'package:shared_preferences/shared_preferences.dart';

class LocalService {
  static const String _keyAuthStep = 'auth_step';
  
  static Future<void> setAuthStep(String step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAuthStep, step);
  }

  static Future<String?> getAuthStep() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAuthStep);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

// Define step constants
class AuthSteps {
  static const String welcome = 'welcome';
  static const String registration = 'registration';
  static const String userType = 'user_type';
  static const String permissions = 'permissions';
  static const String paywall = 'paywall';
  static const String home = 'home';
}
