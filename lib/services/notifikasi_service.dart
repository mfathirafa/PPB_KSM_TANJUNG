import 'package:http/http.dart' as http;
import 'base_service.dart';

class NotifikasiService {
  // =========================
  // LIST NOTIFIKASI
  // GET /notifikasi
  // =========================
  static Future<List<Map<String, dynamic>>> list(String token) async {
    final res = await http.get(
      Uri.parse('${BaseService.baseUrl}/notifikasi'),
      headers: BaseService.headers(token),
    );

    final data = BaseService.handle(res);

    if (data is! Map || data['notifikasi'] is! List) {
      throw Exception('Format notifikasi tidak valid');
    }

    return List<Map<String, dynamic>>.from(data['notifikasi']);
  }

  // =========================
  // MARK NOTIFIKASI AS READ
  // PATCH /notifikasi/{id}/read
  // =========================
  static Future<void> markRead(int id) async {
    final res = await http.patch(
      Uri.parse('${BaseService.baseUrl}/notifikasi/$id/read'),
      headers: BaseService.headersWithAuth(),
    );

    BaseService.handle(res);
  }
}