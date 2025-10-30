import 'package:flutter/material.dart';
import '../models/dummy_data.dart';
import 'dashboard_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verifikasi Berhasil! (dummy)')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kode Verifikasi Salah!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final whatsappGreen = const Color(0xFF25D366);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 60,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.whatsapp, color: whatsappGreen, size: 60),
            const SizedBox(height: 20),

            // Judul dan Deskripsi
            const Text(
              'Verifikasi dengan WhatsApp',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Masukkan Kode Verifikasi yang telah dikirim ke nomor ${widget.phone}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Kotak Input Kode Verifikasi (OTP)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) {
                return Flexible(
                  child: Container(
                    height: 55,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.5,
                      ),
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
                        contentPadding: EdgeInsets.zero,
                      ),
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
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),

            // Tombol "Verifikasi Kode"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: whatsappGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Verifikasi Kode',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Kotak informasi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey[600]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Kami akan mengirimkan Kode Verifikasi melalui WhatsApp ke nomor yang Anda masukkan',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Link Syarat & Ketentuan dan Kebijakan Privasi
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Dengan melanjutkan, Anda menyetujui\n',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                children: [
                  TextSpan(
                    text: 'Syarat & Ketentuan',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: ' serta '),
                  TextSpan(
                    text: 'Kebijakan Privasi',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                final newOtp = generateOtp();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Mengirim ulang OTP (dummy): $newOtp'),
                  ),
                );
              },
              child: const Text('Kirim ulang kode'),
              style: TextButton.styleFrom(
                foregroundColor: whatsappGreen,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
