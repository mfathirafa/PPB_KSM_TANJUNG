import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseService {
  static const String baseUrl = "http://10.0.2.2:8000/api";

  static Map<String, String> headers(String token) => {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

  static dynamic handle(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body);
    } else {
      throw Exception("API ${res.statusCode}: ${res.body}");
    }
  }
}