import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/welcome_screen.dart';
import '../screens/qris_payment_page.dart';
import 'info_row.dart';

/// ================= PROCESSING DIALOG =================
void showProcessingDialog(BuildContext context,
    {String message = 'Memproses...'}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    ),
  );
}

/// ================= QRIS CONFIRMATION =================
void showQrisConfirmationDialog(
  BuildContext context,
  Map<String, dynamic> bill,
) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        'Konfirmasi Pembayaran',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InfoRow(title: 'ID Tagihan', value: bill['id'].toString()),
          InfoRow(title: 'Jumlah', value: 'Rp ${bill['jumlah']}'),
          InfoRow(title: 'Metode', value: 'QRIS'),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => QrisPaymentPage(bill: bill),
                ),
              );
            },
            child: const Text('Lanjutkan Pembayaran'),
          ),
        ),
      ],
    ),
  );
}

/// ================= LOGOUT CONFIRMATION =================
class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        'Konfirmasi Logout',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'Apakah Anda yakin ingin keluar dari aplikasi?',
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => _logout(context),
                child: const Text('Keluar'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}