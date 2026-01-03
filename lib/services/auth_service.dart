import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    final res = await http.post(
      Uri.parse("${BaseService.baseUrl}/send-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phone}),
    );
    return BaseService.handle(res);
  }

  static Future<Map<String, dynamic>> verifyOtp(
    String phone,
    String otp,
    String role,
  ) async {
    final res = await http.post(
      Uri.parse("${BaseService.baseUrl}/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "phone": phone,
        "otp": otp,
        "role": role,
      }),
    );
    return BaseService.handle(res);
  }
}