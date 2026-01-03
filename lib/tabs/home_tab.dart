import 'package:flutter/material.dart';
import '../widgets/info_row.dart';
import '../screens/pembayaran_screen.dart';

class HomeTab extends StatelessWidget {
  final Map<String, dynamic> member;
  final List<dynamic> bills;

  const HomeTab({
    required this.member,
    required this.bills,
    super.key,
  });

  bool _isPaid(String status) =>
      status == 'dibayar' || status == 'lunas';

  @override
  Widget build(BuildContext context) {
    final nextBill = bills.firstWhere(
      (b) => !_isPaid(b['status']),
      orElse: () => null,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* ================= HEADER ================= */
          Text(
            'Selamat datang, ${member['name'] ?? '-'}!',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            DateTime.now().toLocal().toString().substring(0, 10),
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),

          const SizedBox(height: 16),

          /* ================= INFORMASI PELANGGAN ================= */
          const Text(
            'Informasi Pelanggan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          _card(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRow(
                  title: 'Nama Lengkap',
                  value: member['name'] ?? '-',
                ),
                InfoRow(
                  title: 'No. WhatsApp',
                  value: member['phone'] ?? '-',
                ),
                InfoRow(
                  title: 'Alamat',
                  value: member['pelanggan']?['alamat'] ?? '-',
                ),
                InfoRow(
                  title: 'Role',
                  value: member['role'] ?? '-',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /* ================= INFORMASI TAGIHAN ================= */
          const Text(
            'Informasi Tagihan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),

          _card(
            nextBill == null
                ? const Text('Tidak ada tagihan aktif')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const InfoRow(
                        title: 'Bulan',
                        value: '-',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(color: Colors.black54),
                          ),
                          _statusBadge(nextBill['status']),
                        ],
                      ),
                      const SizedBox(height: 6),
                      InfoRow(
                        title: 'Jumlah',
                        value: 'Rp ${nextBill['jumlah']}',
                      ),
                      InfoRow(
                        title: 'Tanggal',
                        value: nextBill['tanggal'],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PembayaranScreen(bill: nextBill),
                              ),
                            );
                          },
                          child: const Text('Bayar Sekarang'),
                        ),
                      ),
                    ],
                  ),
          ),

          const SizedBox(height: 20),

          /* ================= NOTIFIKASI ================= */
          const Text(
            'Notifikasi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          _card(
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.notifications, color: Colors.black54),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Notifikasi akan muncul di sini.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            bgColor: const Color(0xFFFFF7E5),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /* ================= HELPER UI ================= */

  Widget _card(Widget child, {Color bgColor = Colors.white}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: child,
    );
  }

  Widget _statusBadge(String status) {
    final label =
        status == 'belum_dibayar' ? 'Belum Dibayar' : 'Lunas';
    final color =
        status == 'belum_dibayar' ? Colors.amber : Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}