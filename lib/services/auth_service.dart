import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_config.dart';

class AuthService {
  static String? _currentUserId;
  static String? _currentUserName;
  
  static String? get userId => _currentUserId;
  static String? get userName => _currentUserName;
  static bool get isAuthenticated => _currentUserId != null;
  
  /// Login user
  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.loginUrl),
        headers: ApiConfig.headers,
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentUserId = data['user']['id'];
        _currentUserName = data['user']['name'];
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  /// Register new user
  static Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.registerUrl),
        headers: ApiConfig.headers,
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _currentUserId = data['user']['id'];
        _currentUserName = data['user']['name'];
        return true;
      }
      return false;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }
  
  static void logout() {
    _currentUserId = null;
    _currentUserName = null;
  }
}
