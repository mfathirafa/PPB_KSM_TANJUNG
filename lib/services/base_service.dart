import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseService {
  // =========================
  // BASE URL API
  // =========================
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // =========================
  // TOKEN (IN-MEMORY)
  // =========================
  static String _token = '';

  // =========================
  // SET TOKEN (PANGGIL SAAT LOGIN)
  // =========================
  static void setToken(String token) {
    _token = token;
  }

  // =========================
  // HEADER DENGAN TOKEN
  // =========================
  static Map<String, String> headers(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // =========================
  // HEADER DARI TOKEN GLOBAL
  // (untuk notifikasi, patch, dll)
  // =========================
  static Map<String, String> headersWithAuth() {
    if (_token.isEmpty) {
      throw Exception('Token belum diset');
    }

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    };
  }

  // =========================
  // RESPONSE HANDLER (WAJIB)
  // =========================
  static dynamic handle(http.Response res) {
    final status = res.statusCode;

    // No Content
    if (status == 204) return null;

    dynamic data;
    try {
      data = jsonDecode(res.body);
    } catch (_) {
      throw Exception('Response bukan JSON');
    }

    // Success
    if (status >= 200 && status < 300) {
      return data;
    }

    // Error dari backend
    if (data is Map && data.containsKey('message')) {
      throw Exception(data['message']);
    }

    throw Exception('Terjadi kesalahan ($status)');
  }
}