import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'base_service.dart';

class UserService {
  /// =========================
  /// AMBIL TOKEN LOGIN
  /// =========================
  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan, silakan login ulang');
    }

    return token;
  }

  /// =========================
  /// GET USER LOGIN (/me)
  /// =========================
  static Future<Map<String, dynamic>> me(String token) async {
    final res = await http.get(
      Uri.parse('${BaseService.baseUrl}/me'),
      headers: BaseService.headers(token),
    );

    final data = BaseService.handle(res);

    if (data is! Map<String, dynamic>) {
      throw Exception('Format data user tidak valid');
    }

    return data;
  }

  /// =========================
  /// SIMPAN TOKEN SAAT LOGIN
  /// =========================
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  /// =========================
  /// LOGOUT
  /// =========================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}