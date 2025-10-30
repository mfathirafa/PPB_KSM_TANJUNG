import 'package:flutter/material.dart';
import 'whatsapp_login_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = Color(0xFF4CAF50);

    return Scaffold(
      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/ksmlogo.png',
                  height: 150,
                  width: 150,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Hai!!',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
                textAlign: TextAlign.left,
              ),
              const Text(
                'Welcome to\nKSM Tanjung App',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 30),

              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => WhatsAppLogin()),
                ),
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Color(0xFF25D366),
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Lanjutkan dengan WhatsApp',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterScreen()),
                ),
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.person_outline,
                        color: Colors.grey,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Belum punya akun? Daftar',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 35),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => WhatsAppLogin()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(55),
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Selanjutnya',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20),
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
