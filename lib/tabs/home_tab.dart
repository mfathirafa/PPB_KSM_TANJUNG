import 'package:flutter/material.dart';
import '../widgets/info_row.dart';
import '../screens/pembayaran_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTab extends StatelessWidget {
  final Map<String, dynamic> member;
  final List<Map<String, dynamic>> bills;

  const HomeTab({
    required this.member,
    required this.bills,
    super.key,
  });

  bool _isPending(String s) => s == 'pending';
  bool _isWaiting(String s) => s == 'menunggu_verifikasi';
  bool _isLunas(String s) => s == 'lunas';

  @override
  Widget build(BuildContext context) {
    final activeBills = bills.where((b) {
      final s = b['status'];
      return _isPending(s) || _isWaiting(s);
    }).toList();

    final nextBill = activeBills.isNotEmpty ? activeBills.first : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Selamat datang, ${member['name'] ?? '-'}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        const Text('Informasi Pelanggan',
            style: TextStyle(fontWeight: FontWeight.bold)),
        _card(Column(children: [
          InfoRow(title: 'Nama', value: member['name'] ?? '-'),
          InfoRow(title: 'No HP', value: member['phone'] ?? '-'),
        ])),

        const SizedBox(height: 16),

        const Text('Informasi Tagihan',
            style: TextStyle(fontWeight: FontWeight.bold)),
        _card(
          nextBill == null
              ? const Text('Tidak ada tagihan aktif')
              : Column(children: [
                  InfoRow(
                      title: 'Tanggal', value: nextBill['tanggal'] ?? '-'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status'),
                      _statusBadge(nextBill['status']),
                    ],
                  ),
                  InfoRow(
                      title: 'Jumlah',
                      value: 'Rp ${nextBill['jumlah']}'),
                  if (_isPending(nextBill['status']))
                    ElevatedButton(
                      onPressed: () async {
                        final prefs =
                            await SharedPreferences.getInstance();
                        final token =
                            prefs.getString('token') ?? '';

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PembayaranScreen(
                              bill: nextBill,
                              token: token,
                            ),
                          ),
                        );
                      },
                      child: const Text('Bayar Sekarang'),
                    ),
                ]),
        ),

        if (nextBill != null && _isWaiting(nextBill['status']))
          _card(const Text(
            'Pembayaran Anda sedang menunggu verifikasi admin',
            style: TextStyle(color: Colors.orange),
          )),
      ]),
    );
  }

  Widget _statusBadge(String s) {
    if (_isLunas(s)) return _badge('Lunas', Colors.green);
    if (_isWaiting(s))
      return _badge('Menunggu Verifikasi', Colors.orange);
    return _badge('Belum Dibayar', Colors.red);
  }

  Widget _badge(String t, Color c) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration:
            BoxDecoration(color: c, borderRadius: BorderRadius.circular(6)),
        child: Text(t, style: const TextStyle(color: Colors.white)),
      );

  Widget _card(Widget child) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
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