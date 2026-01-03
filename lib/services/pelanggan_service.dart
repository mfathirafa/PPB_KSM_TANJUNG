import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_service.dart';

class PelangganService {
  static Future<List<dynamic>> getAll(String token) async {
    final res = await http.get(
      Uri.parse("${BaseService.baseUrl}/admin/pelanggan"),
      headers: BaseService.headers(token),
    );
    return BaseService.handle(res);
  }

  static Future<void> create(
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

    BaseService.handle(res);
  }
}