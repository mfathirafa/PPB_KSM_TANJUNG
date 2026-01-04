import 'package:http/http.dart' as http;
import 'base_service.dart';

class PembayaranService {
  // =========================
  // RIWAYAT PEMBAYARAN
  // =========================
  static Future<List<Map<String, dynamic>>> riwayat(String token) async {
    final res = await http.get(
      Uri.parse('${BaseService.baseUrl}/pembayaran/riwayat'),
      headers: BaseService.headers(token),
    );

    final data = BaseService.handle(res);

    if (data is! Map || data['riwayat'] is! List) {
      throw Exception('Format riwayat pembayaran tidak valid');
    }

    return List<Map<String, dynamic>>.from(data['riwayat']);
  }

  // =========================
  // CREATE PEMBAYARAN
  // =========================
  static Future<void> create({
    required String token,
    required int tagihanId,
    required String metode,
  }) async {
    final res = await http.post(
      Uri.parse('${BaseService.baseUrl}/pembayaran/create'),
      headers: BaseService.headers(token),
      body: {
        'tagihan_id': tagihanId.toString(),
        'metode': metode,
      },
    );

    BaseService.handle(res);
  }

  // =========================
  // UPLOAD BUKTI
  // =========================
  static Future<void> uploadBukti({
    required String token,
    required int pembayaranId,
    required String buktiPath,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${BaseService.baseUrl}/pembayaran/upload-bukti'),
    );

    request.headers.addAll(BaseService.headers(token));
    request.fields['pembayaran_id'] = pembayaranId.toString();
    request.files.add(await http.MultipartFile.fromPath('bukti', buktiPath));

    final res = await request.send();

    if (res.statusCode != 200) {
      throw Exception('Gagal upload bukti pembayaran');
    }
  }
}