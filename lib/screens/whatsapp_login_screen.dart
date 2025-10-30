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

    // Menampilkan dialog OTP dummy
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Ikon WhatsApp
              Image.asset('assets/wa.png', height: 55),
              const SizedBox(height: 12),
              // Judul Utama
              const Text(
                'Login dengan WhatsApp',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Sub Judul
              const Text(
                'Masuk Menggunakan Nomor WhatsApp Anda',
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),

              // Bagian Input Nomor Telepon
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: _country,
                        keyboardType: TextInputType.phone,
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
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan Nomor WhatsApp Anda',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Tombol "Kirim Kode Verifikasi"
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

              // Kotak Info Verifikasi
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Kami akan mengirimkan Kode Verifikasi melalui WhatsApp ke nomor yang anda masukkan',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Teks Syarat & Ketentuan dan Kebijakan Privasi
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                  children: [
                    const TextSpan(
                      text: 'Dengan melanjutkan, Anda menyetujui\n',
                    ),
                    TextSpan(
                      text: 'Syarat & Ketentuan',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' serta '),
                    TextSpan(
                      text: 'Kebijakan Privasi',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
