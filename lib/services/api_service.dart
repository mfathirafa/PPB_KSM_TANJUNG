import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://10.0.2.2:8000/api"; // ganti sesuai device

  static Map<String, String> _headers(String token) => {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

  // ======================
  // CUSTOMER
  // ======================
  static Future<List<dynamic>> getTagihan(String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/tagihan"),
      headers: _headers(token),
    );

    if (res.statusCode != 200) {
      throw Exception("Gagal mengambil tagihan");
    }

    final data = jsonDecode(res.body);
    return data['tagihan']; // ⬅️ sesuai API backend kamu
  }

  static Future<void> bayarTagihan(
      String token, int tagihanId, String metode) async {
    final res = await http.post(
      Uri.parse("$baseUrl/pembayaran/create"),
      headers: _headers(token),
      body: jsonEncode({
        "tagihan_id": tagihanId,
        "metode": metode,
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Gagal membuat pembayaran");
    }
  }

  // ======================
  // ADMIN
  // ======================
  static Future<List<dynamic>> getPelanggan(String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/admin/pelanggan"),
      headers: _headers(token),
    );

    if (res.statusCode != 200) {
      throw Exception("Gagal mengambil pelanggan");
    }

    return jsonDecode(res.body);
  }

  static Future<void> buatTagihan(
      String token, int pelangganId, int jumlah) async {
    final res = await http.post(
      Uri.parse("$baseUrl/admin/tagihan"),
      headers: _headers(token),
      body: jsonEncode({
        "pelanggan_id": pelangganId,
        "jumlah": jumlah,
        "tanggal": DateTime.now().toIso8601String().substring(0, 10),
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Gagal membuat tagihan");
    }
  }
}