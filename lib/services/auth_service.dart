import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:report_app/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    final url = "${ApiConfig.baseUrl}/auth/login";

    print("Menembak ke URL: $url");
    print("Data yang dikirim: email=$email, password=$password");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print("Status Code dari Server: ${response.statusCode}");
      print("Respon Body dari Server: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final String token = responseData['data']['token'];
        final String name = responseData['data']['data']['name'];
        final String role = responseData['data']['data']['role'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('name', name);
        await prefs.setString('role', role);

        print("BEARER TOKEN BERHASIL DISIMPAN: $token");
        print("NAMA USER BERHASIL DISIMPAN: $name");
        print("ROLE USER BERHASIL DISIMPAN: $role");

        return true;
      } else {
        print(
          "Login gagal: Server merespon dengan status ${response.statusCode}",
        );
        return false;
      }
    } catch (e) {
      print('Error Login pada block catch: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final url = "${ApiConfig.baseUrl}/auth/register";

    print("Menembak ke URL: $url");
    print("Data yang dikirim: name=$name, email=$email, password=$password");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      print("Status Code dari Server: ${response.statusCode}");
      print("Respon Body dari Server: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print('Error Register pada block catch: $e');
      return {'status': 500, 'message': 'Server error: $e'};
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('name');
    await prefs.remove('role');
    print("Logout berhasil, semua data session dihapus");
  }
}
