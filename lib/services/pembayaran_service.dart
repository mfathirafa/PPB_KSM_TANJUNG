import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_service.dart';

class PembayaranService {
  static Future<Map<String, dynamic>> create(
    String token,
    int tagihanId,
    String metode,
  ) async {
    final res = await http.post(
      Uri.parse("${BaseService.baseUrl}/pembayaran/create"),
      headers: BaseService.headers(token),
      body: jsonEncode({
        "tagihan_id": tagihanId,
        "metode": metode,
      }),
    );

    return BaseService.handle(res);
  }

  static Future<List<dynamic>> riwayat(String token) async {
    final res = await http.get(
      Uri.parse("${BaseService.baseUrl}/pembayaran/riwayat"),
      headers: BaseService.headers(token),
    );

    final data = BaseService.handle(res);
    return data['riwayat'] ?? [];
  }
}