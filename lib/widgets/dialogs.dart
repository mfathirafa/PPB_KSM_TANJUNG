import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/qris_payment_page.dart';
import '../screens/pembayaran_berhasil_page.dart';
import 'info_row.dart';

/// ---------------- Dialog Pemrosesan ----------------
void showProcessingDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const Dialog();
    },
  );
}

/// ---------------- Dialog Konfirmasi QRIS ----------------
void showQrisConfirmationDialog(
  BuildContext context,
  Map<String, dynamic> bill,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => QrisPaymentPage(bill: bill)),
              );
            },
            child: const Text('Bayar dengan Qris'),
          ),
        ],
      );
    },
  );
}

/// ---------------- Dialog Bukti Pembayaran ----------------
void showBuktiDialog(
  BuildContext context,
  Map<String, dynamic> bill,
  String method,
) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog();
    },
  );
}

/// ---------------- Logout Confirmation ----------------
class LogoutConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        'Konfirmasi Logout',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Apakah Anda yakin ingin keluar?'),
          SizedBox(height: 8),
          Text(
            'Pastikan Anda telah menyelesaikan pembayaran dan menyimpan bukti pembayaran sebelum keluar',
            style: TextStyle(color: Colors.grey, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => WelcomeScreen()),
                      (route) => false,
                    );
                  },
                  child: const Text('Keluar'),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Akun Anda akan keluar dan kembali ke halaman login',
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
