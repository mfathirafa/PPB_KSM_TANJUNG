import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/base_service.dart';
import 'dashboard_screen.dart';
import 'dashboard_admin_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String phone;
  final String role; // tetap ada, tapi role final ditentukan backend

  const VerificationScreen({
    super.key,
    required this.phone,
    required this.role,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes =
      List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in controllers) c.dispose();
    for (final f in focusNodes) f.dispose();
    super.dispose();
  }

  // ============================
  // VERIFY OTP (FINAL FIX)
  // ============================
  Future<void> _verify() async {
    final otp = controllers.map((c) => c.text).join();

    if (otp.length != 6) {
      _showSnack('Kode OTP tidak lengkap');
      return;
    }

    try {
      final res = await http.post(
        Uri.parse('${BaseService.baseUrl}/verify-otp'),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'phone': widget.phone,
          'otp': otp,
        }),
      );

      final data = BaseService.handle(res);

      // ============================
      // 🔒 SIMPAN DATA WAJIB
      // ============================
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('role', data['role']);
      await prefs.setString('user', jsonEncode(data['user']));

      if (!mounted) return;

      // ============================
      // 🔀 REDIRECT SESUAI ROLE
      // ============================
      if (data['role'] == 'admin') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const DashboardAdminScreen(),
          ),
          (_) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const DashboardScreen(),
          ),
          (_) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showSnack(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // ============================
  // RESEND OTP
  // ============================
  Future<void> _resendOtp() async {
    try {
      await http.post(
        Uri.parse('${BaseService.baseUrl}/send-otp'),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'phone': widget.phone,
        }),
      );

      if (!mounted) return;
      _showSnack('Kode OTP dikirim ulang');
    } catch (_) {
      if (!mounted) return;
      _showSnack('Gagal mengirim ulang OTP');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // ============================
  // UI (TIDAK DIUBAH)
  // ============================
  @override
  Widget build(BuildContext context) {
    const whatsappGreen = Color(0xFF25D366);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const FaIcon(
              FontAwesomeIcons.whatsapp,
              color: whatsappGreen,
              size: 60,
            ),
            const SizedBox(height: 20),
            const Text(
              'Verifikasi dengan WhatsApp',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Masukkan kode yang dikirim ke ${widget.phone}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) {
                return Container(
                  width: 45,
                  height: 55,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: controllers[i],
                    focusNode: focusNodes[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                    onChanged: (val) {
                      if (val.isNotEmpty && i < 5) {
                        focusNodes[i + 1].requestFocus();
                      } else if (val.isEmpty && i > 0) {
                        focusNodes[i - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: whatsappGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Verifikasi Kode',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: _resendOtp,
              child: const Text('Kirim ulang kode'),
            ),
          ],
        ),
      ),
    );
  }
}