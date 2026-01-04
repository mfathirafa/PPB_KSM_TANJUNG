import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_service.dart';

class SettingsService {
  /// =========================
  /// GET SETTINGS (ADMIN)
  /// =========================
  static Future<Map<String, dynamic>> getSettings(String token) async {
    final res = await http.get(
      Uri.parse("${BaseService.baseUrl}/admin/settings"),
      headers: BaseService.headers(token),
    );

    final data = BaseService.handle(res);

    if (data == null || data is! Map<String, dynamic>) {
      throw Exception("Format settings tidak valid");
    }

    return data;
  }

  /// =========================
  /// UPDATE SETTINGS
  /// =========================
  static Future<void> updateSettings(
    String token, {
    required bool waNotif,
    required int timeout,
    required bool enforceHttps,
    required bool midtransEnabled,
  }) async {
    final payload = {
      "wa_notification": waNotif,
      "notification_timeout": timeout,
      "enforce_https": enforceHttps,
      "midtrans_enabled": midtransEnabled,
    };

    final res = await http.put(
      Uri.parse("${BaseService.baseUrl}/admin/settings"),
      headers: BaseService.headers(token),
      body: jsonEncode(payload),
    );

    BaseService.handle(res);
  }

  /// =========================
  /// REGENERATE JWT
  /// =========================
  static Future<void> regenerateJwt(String token) async {
    final res = await http.post(
      Uri.parse("${BaseService.baseUrl}/admin/settings/regenerate-jwt"),
      headers: BaseService.headers(token),
    );

    BaseService.handle(res);
  }
}