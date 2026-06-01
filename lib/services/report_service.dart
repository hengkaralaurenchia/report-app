import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:report_app/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportService {
  static Future<Map<String, dynamic>> getReports({
    String? status,
    String? sortBy,
    String? order,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    String url = "${ApiConfig.baseUrl}/reports";
    List<String> params = [];

    if (status != null) params.add("status=$status");
    if (sortBy != null) params.add("sortBy=$sortBy");
    if (order != null) params.add("order=$order");
    if (params.isNotEmpty) url += "?${params.join('&')}";

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
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        return {
          'status': response.statusCode,
          'message': 'Gagal mengambil data',
        };
      }
    } catch (e) {
      print('Error getReports: $e');
      return {'status': 500, 'message': 'Server error'};
    }
  }

  static Future<Map<String, dynamic>> createReport({
    required String type,
    required String location,
    required String description,
    required File imageFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = "${ApiConfig.baseUrl}/reports";

    print("Menembak ke URL: $url");
    print("Data: type=$type, location=$location, description=$description");

    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = token ?? '';
      request.fields['type'] = type;
      request.fields['location'] = location;
      request.fields['description'] = description;

      final multipartFile = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("Status Code: ${response.statusCode}");
      print("Respon Body: $responseBody");

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(responseBody);
        return responseData;
      } else {
        return {
          'status': response.statusCode,
          'message': 'Gagal membuat laporan',
        };
      }
    } catch (e) {
      print('Error createReport: $e');
      return {'status': 500, 'message': 'Server error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getReportById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = "${ApiConfig.baseUrl}/reports/$id";

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
          'message': 'Gagal mengambil data',
        };
      }
    } catch (e) {
      print('Error getReportById: $e');
      return {'status': 500, 'message': 'Server error'};
    }
  }

  static Future<Map<String, dynamic>> deleteReport(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = "${ApiConfig.baseUrl}/reports/$id";

    print("Menembak ke URL DELETE: $url");

    try {
      final response = await http.delete(
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
          'message': 'Gagal menghapus laporan',
        };
      }
    } catch (e) {
      print('Error deleteReport: $e');
      return {'status': 500, 'message': 'Server error: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateStatus(
    int id, {
    required String status,
    String? estimatedCompletion,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = "${ApiConfig.baseUrl}/reports/$id/status";

    print("Menembak ke URL: $url");
    print("Token: $token");
    print("Body: status=$status, estimated=$estimatedCompletion");

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token ?? '',
        },
        body: jsonEncode({
          'status': status,
          if (estimatedCompletion != null && estimatedCompletion.isNotEmpty)
            'estimated_completion': estimatedCompletion,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Respon Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': response.statusCode,
          'message': 'Gagal update status',
        };
      }
    } catch (e) {
      print('Error updateStatus: $e');
      return {'status': 500, 'message': 'Server error: $e'};
    }
  }

  static Future<Map<String, dynamic>> uploadFixPhoto(
    int id,
    File imageFile,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = "${ApiConfig.baseUrl}/reports/$id/fix-image";

    print("Menembak ke URL: $url");

    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = token ?? '';

      final multipartFile = await http.MultipartFile.fromPath(
        'fix_image',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("Status Code: ${response.statusCode}");
      print("Respon Body: $responseBody");

      if (response.statusCode == 200) {
        return jsonDecode(responseBody);
      } else {
        return {'status': response.statusCode, 'message': 'Gagal upload foto'};
      }
    } catch (e) {
      print('Error uploadFixPhoto: $e');
      return {'status': 500, 'message': 'Server error: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateReport({
    required int id,
    required String type,
    required String location,
    required String description,
    File? imageFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = "${ApiConfig.baseUrl}/reports/$id";

    print("=== UPDATE REPORT ===");
    print("URL: $url");
    print("Type: $type, Location: $location, Description: $description");

    try {
      if (imageFile != null) {
        // Jika ada file baru, pakai multipart
        final request = http.MultipartRequest('PUT', Uri.parse(url));
        request.headers['Authorization'] = token ?? '';
        request.fields['type'] = type;
        request.fields['location'] = location;
        request.fields['description'] = description;

        final multipartFile = await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        print("Status Code: ${response.statusCode}");
        print("Response Body: $responseBody");

        if (response.statusCode == 200) {
          return jsonDecode(responseBody);
        } else {
          return {
            'status': response.statusCode,
            'message': 'Gagal update laporan',
          };
        }
      } else {
        // Jika tidak ada file baru, pakai JSON biasa
        final response = await http.put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token ?? '',
          },
          body: jsonEncode({
            'type': type,
            'location': location,
            'description': description,
          }),
        );

        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else {
          return {
            'status': response.statusCode,
            'message': 'Gagal update laporan',
          };
        }
      }
    } catch (e) {
      print('Error updateReport: $e');
      return {'status': 500, 'message': 'Server error: $e'};
    }
  }
}
