import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/info_row.dart';
import '../screens/pembayaran_screen.dart';
import '../services/notifikasi_service.dart';

class HomeTab extends StatelessWidget {
  final Map<String, dynamic> member;
  final Map<String, dynamic>? tagihanAktif;
  final List<Map<String, dynamic>> notifikasi;
  final int unreadCount;
  final VoidCallback onRefresh;

  const HomeTab({
    super.key,
    required this.member,
    required this.tagihanAktif,
    required this.notifikasi,
    required this.unreadCount,
    required this.onRefresh,
  });

  bool _isWaiting(String? s) => s == 'menunggu_verifikasi';
  bool _isLunas(String? s) => s == 'lunas';

  @override
  Widget build(BuildContext context) {
    final bill = tagihanAktif;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ================= HEADER =================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Selamat datang, ${member['name']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            if (unreadCount > 0)
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.red,
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),

        const SizedBox(height: 16),

        // ================= INFORMASI PELANGGAN =================
        const Text('Informasi Pelanggan',
            style: TextStyle(fontWeight: FontWeight.bold)),
        _card(Column(children: [
          InfoRow(title: 'Nama', value: member['name'] ?? '-'),
          InfoRow(title: 'No. WhatsApp', value: member['phone'] ?? '-'),
          InfoRow(title: 'Alamat', value: member['alamat'] ?? '-'),
          InfoRow(title: 'Role', value: member['role'] ?? '-'),
        ])),

        const SizedBox(height: 16),

        // ================= INFORMASI TAGIHAN =================
        const Text('Informasi Tagihan',
            style: TextStyle(fontWeight: FontWeight.bold)),
        _card(
          bill == null
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: Text('Tidak ada tagihan aktif')),
                )
              : Column(children: [
                  InfoRow(title: 'Tanggal', value: bill['tanggal']),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status'),
                      _statusBadge(bill['status']),
                    ],
                  ),
                  InfoRow(
                      title: 'Jumlah',
                      value: 'Rp ${bill['jumlah']}'),
                  const SizedBox(height: 12),

                  if (!_isWaiting(bill['status']) &&
                      !_isLunas(bill['status']))
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final prefs =
                              await SharedPreferences.getInstance();
                          final token =
                              prefs.getString('token') ?? '';

                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PembayaranScreen(
                                bill: bill,
                                token: token,
                              ),
                            ),
                          );

                          if (result == true) onRefresh();
                        },
                        child: const Text('Bayar Sekarang'),
                      ),
                    ),
                ]),
        ),

        const SizedBox(height: 16),

        // ================= NOTIFIKASI =================
        if (notifikasi.isNotEmpty) ...[
          const Text('Notifikasi',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final n in notifikasi)
            GestureDetector(
              onTap: () async {
                await NotifikasiService.markRead(n['id']);
                onRefresh();
              },
              child: _card(Text(n['pesan'])),
            ),
        ],
      ]),
    );
  }

  Widget _statusBadge(String? status) {
    if (status == 'lunas') {
      return _badge('Lunas', Colors.green);
    }
    if (status == 'menunggu_verifikasi') {
      return _badge('Menunggu Verifikasi', Colors.orange);
    }
    return _badge('Belum Dibayar', Colors.red);
  }

  Widget _badge(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      );

  Widget _card(Widget child) => Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4),
          ],
        ),
        child: child,
      );
}