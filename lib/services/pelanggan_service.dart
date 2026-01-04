import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_service.dart';

class PelangganService {
  /// =========================
  /// LIST PELANGGAN
  /// =========================
  static Future<List<Map<String, dynamic>>> getAll(String token) async {
    final res = await http.get(
      Uri.parse("${BaseService.baseUrl}/admin/pelanggan"),
      headers: BaseService.headers(token),
    );

    final data = BaseService.handle(res);

    if (data is! List) {
      throw Exception('Format data pelanggan tidak valid');
    }

    return List<Map<String, dynamic>>.from(data);
  }

  /// =========================
  /// CREATE PELANGGAN
  /// =========================
  static Future<Map<String, dynamic>> create(
    String token,
    String nama,
    String phone,
    String alamat,
  ) async {
    final res = await http.post(
      Uri.parse("${BaseService.baseUrl}/admin/pelanggan"),
      headers: BaseService.headers(token),
      body: jsonEncode({
        "nama": nama,
        "phone": phone,
        "alamat": alamat,
      }),
    );

    final data = BaseService.handle(res);

    if (data is! Map<String, dynamic> ||
        data['pelanggan'] == null) {
      throw Exception('Response create pelanggan tidak valid');
    }

    return data['pelanggan'];
  }
}