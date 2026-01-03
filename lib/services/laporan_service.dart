import 'package:http/http.dart' as http;
import 'base_service.dart';

class LaporanService {
  static Future<Map<String, dynamic>> getDashboard(String token) async {
    final res = await http.get(
      Uri.parse("${BaseService.baseUrl}/admin/laporan-keuangan"),
      headers: BaseService.headers(token),
    );
    return BaseService.handle(res);
  }

  static Future<Map<String, dynamic>> getPeriode(
    String token,
    String periode,
  ) async {
    final res = await http.get(
      Uri.parse(
        "${BaseService.baseUrl}/admin/laporan-keuangan/$periode",
      ),
      headers: BaseService.headers(token),
    );
    return BaseService.handle(res);
  }
}