import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../widgets/info_row.dart';

class PembayaranBerhasilPage extends StatelessWidget {
  final Map<String, dynamic> bill;
  final String method;

  const PembayaranBerhasilPage({
    super.key,
    required this.bill,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    final String tanggal =
        bill['created_at']?.toString().substring(0, 16) ?? '-';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pembayaran Berhasil'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Tagihan #${bill['id']} - Rp ${bill['jumlah']}',
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 32),

            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 90,
            ),
            const SizedBox(height: 20),

            const Text(
              'Terima Kasih! Pembayaran Anda telah diterima.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              'Detail pembayaran telah tercatat di sistem.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // ================= DETAIL PEMBAYARAN =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detail Pembayaran',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  InfoRow(title: 'ID Tagihan', value: bill['id'].toString()),
                  InfoRow(title: 'Tanggal & Waktu', value: tanggal),
                  InfoRow(title: 'Metode Pembayaran', value: method),
                  InfoRow(
                    title: 'Jumlah',
                    value: 'Rp ${bill['jumlah']}',
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status',
                          style: TextStyle(color: Colors.black54)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border:
                              Border.all(color: Colors.green.shade200),
                        ),
                        child: const Text(
                          'Terkonfirmasi',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ================= TOMBOL AKSI =================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const DashboardScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Kembali ke Dashboard',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}