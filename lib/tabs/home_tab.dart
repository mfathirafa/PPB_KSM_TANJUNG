import 'package:flutter/material.dart';
import '../widgets/info_row.dart';
import '../screens/pembayaran_screen.dart';

class HomeTab extends StatelessWidget {
  final Map<String, dynamic> member;
  final List<Map<String, dynamic>> bills;
  const HomeTab({required this.member, required this.bills, super.key});

  @override
  Widget build(BuildContext context) {
    final nextBill = bills.firstWhere(
      (b) =>
          (b['status'] ?? '') != 'Lunas' &&
          (b['status'] ?? '') != 'Sudah Dibayar',
      orElse: () => {
        'id': 'N/A',
        'title': 'Tidak ada tagihan',
        'amount': 0.0,
        'due': 'N/A',
        'status': 'Lunas',
      },
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* --------------------------- Header --------------------------- */
          const Text(
            'Selamat datang, Lando Norris!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            'Minggu, 20 April 2025',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          /* ---------------------- Informasi Pelanggan ---------------------- */
          const Text(
            'Informasi Pelanggan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRow(title: 'Nama Lengkap', value: member['name']),
                const InfoRow(
                  title: 'No. WhatsApp',
                  value: '+62 812 3456 7890',
                ),
                const InfoRow(
                  title: 'Alamat',
                  value: 'Jl. Tanjung Raya No. 45, RT 03/RW 02',
                ),
                const InfoRow(title: 'Role', value: 'Pelanggan'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /* ---------------------- Informasi Tagihan ---------------------- */
          const Text(
            'Informasi Tagihan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InfoRow(title: 'Bulan', value: 'April 2025'),
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
                        color: Colors.amber[700],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        nextBill['status'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                InfoRow(title: 'Jumlah', value: 'Rp. ${nextBill['amount']}'),
                InfoRow(title: 'Deadline', value: nextBill['due']),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed:
                        nextBill['status'] != 'Lunas' &&
                            nextBill['status'] != 'Sudah Dibayar'
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PembayaranScreen(bill: nextBill),
                              ),
                            );
                          }
                        : null,
                    child: Text(
                      nextBill['status'] != 'Lunas' &&
                              nextBill['status'] != 'Sudah Dibayar'
                          ? 'Bayar Sekarang'
                          : 'Lunas',
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /* ---------------------- Notifikasi ---------------------- */
          const Text(
            'Notifikasi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.notifications, color: Colors.black54),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tagihan bulan April 2025 telah dibuat. Harap segera melakukan pembayaran sebelum 30 April 2025.',
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '20 April 2025, 08:30',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
