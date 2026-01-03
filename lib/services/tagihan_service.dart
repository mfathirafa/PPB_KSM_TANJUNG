import 'package:http/http.dart' as http;
import 'base_service.dart';

class TagihanService {
  static Future<List<dynamic>> getCustomerTagihan(String token) async {
    final res = await http.get(
      Uri.parse("${BaseService.baseUrl}/tagihan"),
      headers: BaseService.headers(token),
    );

    final data = BaseService.handle(res);
    return data['tagihan'] ?? [];
  }

  static Future<List<dynamic>> getAdminTagihan(String token) async {
    final res = await http.get(
      Uri.parse("${BaseService.baseUrl}/admin/tagihan"),
      headers: BaseService.headers(token),
    );

    return BaseService.handle(res);
  }
}