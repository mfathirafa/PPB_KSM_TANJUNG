import 'package:http/http.dart' as http;
import 'base_service.dart';

class TagihanService {
  /// =========================
  /// GET TAGIHAN + SUMMARY
  /// =========================
  static Future<Map<String, dynamic>> list(String token) async {
    final res = await http.get(
      Uri.parse('${BaseService.baseUrl}/tagihan'),
      headers: BaseService.headers(token),
    );

    final data = BaseService.handle(res);

    if (data is! Map ||
        data['tagihan'] is! List ||
        data['summary'] is! Map) {
      throw Exception('Format tagihan tidak valid');
    }

    return {
      'tagihan': List<Map<String, dynamic>>.from(data['tagihan']),
      'summary': Map<String, dynamic>.from(data['summary']),
    };
  }
}