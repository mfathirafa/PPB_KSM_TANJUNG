import 'package:http/http.dart' as http;
import 'base_service.dart';

class AdminDashboardService {
  static Future<Map<String, dynamic>> get(String token) async {
    final res = await http.get(
      Uri.parse('${BaseService.baseUrl}/admin/dashboard'),
      headers: BaseService.headers(token),
    );

    final data = BaseService.handle(res);

    if (data is! Map) {
      throw Exception('Format dashboard admin tidak valid');
    }

    return Map<String, dynamic>.from(data);
  }
}