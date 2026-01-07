import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_service.dart';

class PelangganAdminService {

  // =========================
  // LIST
  // =========================
  static Future<List<Map<String, dynamic>>> list(String token) async {
    final res = await http.get(
      Uri.parse('${BaseService.baseUrl}/admin/pelanggan'),
      headers: BaseService.headers(token),
    );

    final data = BaseService.handle(res);

    if (data is! Map || data['pelanggan'] is! List) {
      throw Exception('Format pelanggan admin tidak valid');
    }

    return List<Map<String, dynamic>>.from(data['pelanggan']);
  }

  // =========================
  // CREATE
  // =========================
  static Future<void> create(
    String token,
    String nama,
    String phone,
    String alamat,
  ) async {
    final res = await http.post(
      Uri.parse('${BaseService.baseUrl}/admin/pelanggan'),
      headers: BaseService.headers(token),
      body: jsonEncode({
        'nama': nama,
        'phone': phone,
        'alamat': alamat,
      }),
    );

    BaseService.handle(res);
  }

  // =========================
  // UPDATE  ✅ INI YANG HILANG
  // =========================
  static Future<void> update(
    String token,
    int id,
    String nama,
    String alamat,
  ) async {
    final res = await http.put(
      Uri.parse('${BaseService.baseUrl}/admin/pelanggan/$id'),
      headers: BaseService.headers(token),
      body: jsonEncode({
        'nama': nama,
        'alamat': alamat,
      }),
    );

    BaseService.handle(res);
  }

  // =========================
  // DELETE
  // =========================
  static Future<void> delete(String token, int id) async {
    final res = await http.delete(
      Uri.parse('${BaseService.baseUrl}/admin/pelanggan/$id'),
      headers: BaseService.headers(token),
    );

    BaseService.handle(res);
  }
}