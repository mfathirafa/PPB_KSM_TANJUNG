import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/api.dart';
import 'verification_screen.dart';

class WhatsAppLogin extends StatefulWidget {
  final String role;

  const WhatsAppLogin({super.key, this.role = "customer"});

  @override
  State<WhatsAppLogin> createState() => _WhatsAppLoginState();
}

class _WhatsAppLoginState extends State<WhatsAppLogin> {
  final _country = TextEditingController(text: '+62');
  final _phone = TextEditingController();
  bool loading = false;

  Future<void> _sendOtp() async {
    if (_phone.text.isEmpty) return;

    setState(() => loading = true);
    final phone = "${_country.text}${_phone.text}";

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerificationScreen(phone: phone),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim OTP')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _country),
            TextField(controller: _phone),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : _sendOtp,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text('Kirim OTP'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
