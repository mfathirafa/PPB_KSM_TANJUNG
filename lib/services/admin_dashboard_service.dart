import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboardService {
  static const String _endpoint = '/admin/dashboard';

  /// =========================
  /// FETCH DASHBOARD ADMIN
  /// =========================
  static Future<Map<String, dynamic>> fetch() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan, silakan login ulang');
    }

    final res = await http.get(
      Uri.parse('${BaseService.baseUrl}$_endpoint'),
      headers: BaseService.headers(token),
    );

    final data = BaseService.handle(res);

    // =========================
    // VALIDASI STRUKTUR RESPONSE
    // =========================
    if (data is! Map<String, dynamic>) {
      throw Exception('Format response dashboard tidak valid');
    }

    if (data['stats'] is! Map) {
      throw Exception('Data stats tidak valid');
    }

    if (data['tagihan_terbaru'] is! List) {
      throw Exception('Data tagihan terbaru tidak valid');
    }

    if (data['tanggal'] is! String) {
      throw Exception('Tanggal tidak valid');
    }

    return {
      'tanggal': data['tanggal'],
      'stats': Map<String, dynamic>.from(data['stats']),
      'tagihan_terbaru': List<Map<String, dynamic>>.from(
        data['tagihan_terbaru'],
      ),
    };
  }
}