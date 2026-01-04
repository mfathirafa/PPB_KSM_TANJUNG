import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Map<String, String> headers(String token) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  static dynamic handle(http.Response res) {
    final body = jsonDecode(res.body);

    if (res.statusCode >= 400) {
      throw Exception(body['message'] ?? 'Terjadi kesalahan');
    }

    return body;
  }
}