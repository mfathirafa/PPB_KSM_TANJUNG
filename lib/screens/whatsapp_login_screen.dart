import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'verification_screen.dart';

class WhatsAppLogin extends StatefulWidget {
  final String role; // WAJIB

  const WhatsAppLogin({
    super.key,
    required this.role,
  });

  @override
  State<WhatsAppLogin> createState() => _WhatsAppLoginState();
}

class _WhatsAppLoginState extends State<WhatsAppLogin> {
  final TextEditingController _country =
      TextEditingController(text: '+62'); // UI TETAP
  final TextEditingController _phone = TextEditingController();

  static const String baseUrl = "http://10.0.2.2:8000/api";

  // ============================
  // NORMALIZE PHONE
  // ============================
  String normalizePhone(String input) {
    input = input.replaceAll(RegExp(r'[^0-9]'), '');

    if (input.startsWith('0')) return '+62${input.substring(1)}';
    if (input.startsWith('62')) return '+$input';
    if (input.startsWith('8')) return '+62$input';

    throw Exception('Nomor tidak valid');
  }

  // ============================
  // SEND OTP
  // ============================
  Future<void> _sendOtp() async {
    if (_phone.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor WhatsApp wajib diisi')),
      );
      return;
    }

    late String phone;

    try {
      phone = normalizePhone(_phone.text);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format nomor tidak valid')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send-otp'),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'phone': phone,
          'role': widget.role, // 🔒 ROLE DIKUNCI DI SINI
        }),
      );

      if (response.statusCode == 200 && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerificationScreen(
              phone: phone,
              role: widget.role, // 🔒 TERUSKAN ROLE
            ),
          ),
        );
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error['message'] ?? 'Gagal mengirim OTP')),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error koneksi ke server')),
      );
    }
  }

  // =========================
  // UI (TIDAK DIUBAH)
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 10),

            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            const SizedBox(height: 30),
            Image.asset('assets/wa.png', height: 55),
            const SizedBox(height: 12),

            const Text(
              'Login dengan WhatsApp',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            const Text(
              'Masuk menggunakan nomor WhatsApp Anda',
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _country,
                      enabled: false,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(height: 30, width: 1, color: Colors.grey.shade300),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan nomor WhatsApp Anda',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Kirim Kode Verifikasi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.info_outline, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Kode OTP akan dikirim melalui WhatsApp.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}