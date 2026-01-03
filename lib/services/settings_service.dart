import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_service.dart';

class SettingsService {
  /// Ambil setting admin
  static Future<Map<String, dynamic>> getSettings(String token) async {
    final res = await http.get(
      Uri.parse("${BaseService.baseUrl}/admin/settings"),
      headers: BaseService.headers(token),
    );
    return BaseService.handle(res);
  }

  /// Update setting admin
  static Future<void> updateSettings(
    String token, {
    required bool waNotif,
    required int timeout,
    required bool enforceHttps,
    required bool midtransEnabled,
  }) async {
    final res = await http.put(
      Uri.parse("${BaseService.baseUrl}/admin/settings"),
      headers: BaseService.headers(token),
      body: jsonEncode({
        "wa_notification": waNotif,
        "notification_timeout": timeout,
        "enforce_https": enforceHttps,
        "midtrans_enabled": midtransEnabled,
      }),
    );

    BaseService.handle(res);
  }

  /// Regenerate JWT secret
  static Future<void> regenerateJwt(String token) async {
    final res = await http.post(
      Uri.parse("${BaseService.baseUrl}/admin/settings/regenerate-jwt"),
      headers: BaseService.headers(token),
    );

    BaseService.handle(res);
  }
}