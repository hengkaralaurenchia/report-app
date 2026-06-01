import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:report_app/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static Future<Map<String, dynamic>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = "${ApiConfig.baseUrl}/notifications";

    print("Menembak ke URL: $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token ?? '',
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Respon Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': response.statusCode,
          'message': 'Gagal mengambil notifikasi',
        };
      }
    } catch (e) {
      print('Error getNotifications: $e');
      return {'status': 500, 'message': 'Server error'};
    }
  }

  static Future<Map<String, dynamic>> markAsRead(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = "${ApiConfig.baseUrl}/notifications/$id/read";

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token ?? '',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': response.statusCode,
          'message': 'Gagal update notifikasi',
        };
      }
    } catch (e) {
      print('Error markAsRead: $e');
      return {'status': 500, 'message': 'Server error'};
    }
  }

  static Future<Map<String, dynamic>> markAllAsRead() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = "${ApiConfig.baseUrl}/notifications/read-all";

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token ?? '',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': response.statusCode,
          'message': 'Gagal update notifikasi',
        };
      }
    } catch (e) {
      print('Error markAllAsRead: $e');
      return {'status': 500, 'message': 'Server error'};
    }
  }

  static Future<Map<String, dynamic>> deleteNotification(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = "${ApiConfig.baseUrl}/notifications/$id";

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token ?? '',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': response.statusCode,
          'message': 'Gagal hapus notifikasi',
        };
      }
    } catch (e) {
      print('Error deleteNotification: $e');
      return {'status': 500, 'message': 'Server error'};
    }
  }

  static Future<Map<String, dynamic>> deleteAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = "${ApiConfig.baseUrl}/notifications";

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token ?? '',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': response.statusCode,
          'message': 'Gagal hapus semua notifikasi',
        };
      }
    } catch (e) {
      print('Error deleteAllNotifications: $e');
      return {'status': 500, 'message': 'Server error'};
    }
  }
}
