import 'package:flutter/material.dart';
import 'dart:async';

class QrisPaymentPage extends StatefulWidget {
  final Map<String, dynamic> bill;

  const QrisPaymentPage({
    super.key,
    required this.bill,
  });

  @override
  State<QrisPaymentPage> createState() => _QrisPaymentPageState();
}

class _QrisPaymentPageState extends State<QrisPaymentPage> {
  static const int _timeoutSeconds = 10 * 60; // 10 menit
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _timeoutSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_remainingSeconds <= 0) {
        timer.cancel();
        _onExpired();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _onExpired() {
    setState(() => _remainingSeconds = 0);

    // 🔔 NOTIFIKASI EXPIRED (LOGIC ONLY)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Waktu Habis'),
        content: const Text(
          'Waktu pembayaran QRIS telah berakhir.\nSilakan ulangi pembayaran.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // kembali ke pembayaran
            },
            child: const Text('Kembali'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.bill;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran Tagihan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Selesaikan Pembayaran QRIS\nSebelum Waktu Habis',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),

            // ⏱ TIMER
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  '$_formattedTime\nMenit',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 💰 JUMLAH TAGIHAN
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Jumlah tagihan',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Rp ${b['jumlah']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🟩 QR SECTION
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/qr.jpg',
                    height: 160,
                    width: 160,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  const Text('Powered by QRIS'),
                  const SizedBox(height: 4),
                  Text(
                    'Nomor Tagihan: #${b['id']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Unduh QRIS'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('QRIS diunduh (dummy)'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.share),
                label: const Text('Bagikan QRIS'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bagikan QRIS (dummy)'),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}