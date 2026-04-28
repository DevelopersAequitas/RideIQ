import 'package:shared_preferences/shared_preferences.dart';

class LocalService {
  static const String _keyAuthStep = 'auth_step';
  static const String _keyAuthToken = 'auth_token';
  static const String _keyBridgeToken = 'bridge_token';
  static const String _keyDriverPhone = 'driver_phone';
  static const String _keyDriverLicense = 'driver_license';


  
  static Future<void> setAuthStep(String step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAuthStep, step);
  }

  static Future<String?> getAuthStep() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAuthStep);
  }

  static Future<void> setDriverDetails({required String phone, required String license}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDriverPhone, phone);
    await prefs.setString(_keyDriverLicense, license);
  }

  static Future<Map<String, String>> getDriverDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'phone': prefs.getString(_keyDriverPhone) ?? '',
      'license': prefs.getString(_keyDriverLicense) ?? '',
    };
  }

  static Future<void> setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAuthToken, token);
  }

  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAuthToken);
  }

  static Future<void> setBridgeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBridgeToken, token);
  }

  static Future<String?> getBridgeToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBridgeToken);
  }

  static Future<void> clearBridgeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBridgeToken);
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
