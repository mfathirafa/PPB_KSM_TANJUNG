import 'package:flutter/material.dart';
import '../models/dummy_data.dart';
import 'dashboard_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String phone;
  final String otp;
  const VerificationScreen({required this.phone, required this.otp, super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final controllers = List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var c in controllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
  }

  void _verify() {
    final code = controllers.map((c) => c.text).join();
    if (code == widget.otp) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Verified! (dummy)')));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kode salah')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Code'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              'Masukkan kode verifikasi yang telah dikirim ke ${widget.phone}',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) {
                return Container(
                  width: 42,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    controller: controllers[i],
                    focusNode: focusNodes[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: const InputDecoration(counterText: ''),
                    onChanged: (value) {
                      if (value.isNotEmpty && i < 5) {
                        focusNodes[i + 1].requestFocus();
                      } else if (value.isEmpty && i > 0) {
                        focusNodes[i - 1].requestFocus();
                      }
                      if (i == 5 && value.isNotEmpty) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verify,
                child: const Text('Verifkasi'),
              ),
            ),
            TextButton(
              onPressed: () {
                final newOtp = generateOtp();
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text('Resent (dummy) OTP: $newOtp'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Kirim ulang kode'),
            ),
          ],
        ),
      ),
    );
  }
}
