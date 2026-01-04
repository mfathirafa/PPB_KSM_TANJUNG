import 'base_service.dart';
import 'package:http/http.dart' as http;


class UserService {
  /// =========================
  /// GET USER LOGIN (/me)
  /// =========================
  static Future<Map<String, dynamic>> me(String token) async {
    final res = await http.get(
      Uri.parse('${BaseService.baseUrl}/me'),
      headers: BaseService.headers(token),
    );

    final data = BaseService.handle(res);

    // VALIDASI KERAS
    if (data is! Map<String, dynamic>) {
      throw Exception('Format data user tidak valid');
    }

    return data;
  }
}