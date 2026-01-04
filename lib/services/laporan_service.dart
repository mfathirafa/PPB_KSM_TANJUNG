import 'package:http/http.dart' as http;
import 'base_service.dart';

class LaporanService {
  /// =========================
  /// DASHBOARD LAPORAN
  /// GET /admin/laporan-keuangan
  /// =========================
  static Future<Map<String, dynamic>> getDashboard(String token) async {
    final res = await http.get(
      Uri.parse('${BaseService.baseUrl}/admin/laporan-keuangan'),
      headers: BaseService.headers(token),
    );

    final data = BaseService.handle(res);

    if (data is! Map<String, dynamic>) {
      throw Exception('Format dashboard laporan tidak valid');
    }

    return data;
  }

  /// =========================
  /// LAPORAN PER PERIODE
  /// GET /admin/laporan-keuangan/{YYYY-MM}
  /// =========================
  static Future<Map<String, dynamic>> getPeriode(
    String token,
    String periode,
  ) async {
    // VALIDASI KERAS FORMAT PERIODE
    final regex = RegExp(r'^\d{4}-\d{2}$');
    if (!regex.hasMatch(periode)) {
      throw Exception('Format periode harus YYYY-MM');
    }

    final res = await http.get(
      Uri.parse('${BaseService.baseUrl}/admin/laporan-keuangan/$periode'),
      headers: BaseService.headers(token),
    );

    final data = BaseService.handle(res);

    if (data is! Map<String, dynamic>) {
      throw Exception('Format laporan periode tidak valid');
    }

    return data;
  }
}