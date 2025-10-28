import 'package:flutter/material.dart';
import '../models/dummy_data.dart';
import 'verification_screen.dart';

class WhatsAppLogin extends StatefulWidget {
  @override
  _WhatsAppLoginState createState() => _WhatsAppLoginState();
}

class _WhatsAppLoginState extends State<WhatsAppLogin> {
  final _country = TextEditingController(text: '+62');
  final _phone = TextEditingController();

  void _sendOtp() {
    if (_phone.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Isi nomor')));
      return;
    }
    final otp = generateOtp();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Dummy OTP'),
        content: Text('Kode verifikasi: $otp\n(Ini cuma simulasi)'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VerificationScreen(
                    phone: '${_country.text} ${_phone.text}',
                    otp: otp,
                  ),
                ),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login dengan WhatsApp'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Text(
              'Masuk Menggunakan Nomor WhatsApp Anda',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  width: 90,
                  child: TextField(
                    controller: _country,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _phone,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan Nomor WhatsApp Anda',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendOtp,
                child: const Text('Kirim Kode Verifikasi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
