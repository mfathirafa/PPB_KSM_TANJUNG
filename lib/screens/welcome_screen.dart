import 'package:flutter/material.dart';
import 'whatsapp_login_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF4CAF50);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 360,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

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
                ),

                const Text(
                  'Welcome to\nKSM Tanjung App',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 30),

                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WhatsAppLogin(role: "customer"),
                    ),
                  ),
                  child: Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
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

                const SizedBox(height: 15),

                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WhatsAppLogin(role: "admin"),
                    ),
                  ),
                  child: Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.admin_panel_settings,
                            color: Colors.blueGrey, size: 26),
                        SizedBox(width: 10),
                        Text(
                          'Masuk sebagai Admin',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
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
                      MaterialPageRoute(
                        builder: (_) => WhatsAppLogin(role: "customer"),
                      ),
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

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
