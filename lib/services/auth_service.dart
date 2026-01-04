import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_service.dart';

class AuthService {
  static Future<void> sendOtp(String phone) async {
    await http.post(
      Uri.parse('${BaseService.baseUrl}/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );
  }

  static Future<Map<String, dynamic>> verifyOtp(
    String phone,
    String otp,
  ) async {
    final res = await http.post(
      Uri.parse('${BaseService.baseUrl}/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'otp': otp}),
    );

    return BaseService.handle(res);
  }
}