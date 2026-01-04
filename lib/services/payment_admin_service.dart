import 'package:http/http.dart' as http;
import 'base_service.dart';

class PaymentAdminService {
  // =========================
  // GET ALL PEMBAYARAN (ADMIN)
  // =========================
  static Future<List<Map<String, dynamic>>> list(String token) async {
    final res = await http.get(
      Uri.parse('${BaseService.baseUrl}/admin/pembayaran'),
      headers: BaseService.headers(token),
    );

    final data = BaseService.handle(res);

    if (data is! Map || data['pembayaran'] is! List) {
      throw Exception('Format pembayaran admin tidak valid');
    }

    return List<Map<String, dynamic>>.from(data['pembayaran']);
  }

  // =========================
  // APPROVE
  // =========================
  static Future<void> approve(String token, int id) async {
    final res = await http.put(
      Uri.parse('${BaseService.baseUrl}/admin/pembayaran/$id/approve'),
      headers: BaseService.headers(token),
    );

    BaseService.handle(res);
  }

  // =========================
  // REJECT
  // =========================
  static Future<void> reject(String token, int id) async {
    final res = await http.put(
      Uri.parse('${BaseService.baseUrl}/admin/pembayaran/$id/reject'),
      headers: BaseService.headers(token),
    );

    BaseService.handle(res);
  }
}