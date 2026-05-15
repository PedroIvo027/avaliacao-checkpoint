import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:projeto_usedev/src/models/login_response.dart';

class LoginService {
  static const String _baseUrl = 'https://fakestoreapi.com/auth/login';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode < 300) {
        final loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
        await _storage.write(key: 'auth_token', value: loginResponse.token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }
}