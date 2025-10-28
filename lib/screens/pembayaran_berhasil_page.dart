import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../widgets/info_row.dart';
import '../widgets/dialogs.dart';

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
              'Tagihan ${bill['id']} - Rp. ${bill['amount']}',
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
              'Detail pembayaran telah dikirim ke WhatsApp anda.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            /// ---------------- Detail Pembayaran ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detail Pembayaran',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InfoRow(title: 'Bill ID', value: bill['id'] ?? '-'),
                  InfoRow(
                    title: 'Tanggal & Waktu',
                    value: '26 April 2025, 23:59',
                  ),
                  InfoRow(title: 'Metode', value: method),
                  InfoRow(title: 'Jumlah', value: 'Rp. ${bill['amount']}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(color: Colors.black54),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: const Text(
                          'Terkonfirmasi',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ---------------- Bukti Pembayaran ----------------
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Icon(Icons.image_outlined, size: 50, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tangkap Layar Bukti Pembayaran',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),

            const SizedBox(height: 30),

            /// ---------------- Tombol Aksi ----------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showBuktiDialog(context, bill, method);
                },
                icon: const Icon(Icons.download),
                label: const Text('Unduh Bukti'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share),
                label: const Text('Kirim ke WhatsApp'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => DashboardScreen()),
                  (route) => false,
                );
              },
              child: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Kembali ke ',
                      style: TextStyle(color: Colors.black54),
                    ),
                    TextSpan(
                      text: 'Dashboard',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    TextSpan(
                      text: ' untuk melihat tagihan lainnya',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

/// ---------------- Dialog Bukti Pembayaran ----------------
void _showBuktiDialog(
  BuildContext context,
  Map<String, dynamic> bill,
  String method,
) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bukti Pembayaran',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              /// Isi Detail
              InfoRow(title: 'Tanggal', value: '1 April 2025'),
              InfoRow(title: 'Nominal', value: 'Rp. ${bill['amount']}'),
              InfoRow(title: 'Metode', value: method),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Status', style: TextStyle(color: Colors.black54)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: const Text(
                      'Terkonfirmasi',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Keterangan', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 4),
              const Text(
                'Pembayaran iuran sampah bulan untuk periode April 2025',
                style: TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 10),
              InfoRow(title: 'Tagihan', value: '#12346'),

              const SizedBox(height: 20),

              /// Tombol Unduh Bukti
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bukti berhasil diunduh!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Unduh Bukti'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
