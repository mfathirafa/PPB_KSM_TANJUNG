import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'verification_screen.dart';

class WhatsAppLogin extends StatefulWidget {
  final String role;

  const WhatsAppLogin({
    super.key,
    this.role = "customer",
  });

  @override
  State<WhatsAppLogin> createState() => _WhatsAppLoginState();
}

class _WhatsAppLoginState extends State<WhatsAppLogin> {
  final TextEditingController _country =
      TextEditingController(text: '+62');
  final TextEditingController _phone = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _country.dispose();
    _phone.dispose();
    super.dispose();
  }

  // =========================
  // SEND OTP KE BACKEND
  // =========================
  Future<void> _sendOtp() async {
    if (_phone.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi nomor terlebih dahulu')),
      );
      return;
    }

    setState(() => _loading = true);
    final phone = "${_country.text}${_phone.text}";

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/send-otp'),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'phone': phone}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerificationScreen(
              phone: phone,
              role: widget.role,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim OTP')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error koneksi: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // =========================
  // UI LOGIN WHATSAPP
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _country,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Nomor WhatsApp',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _loading ? null : _sendOtp,
                child: _loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Kirim OTP'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
