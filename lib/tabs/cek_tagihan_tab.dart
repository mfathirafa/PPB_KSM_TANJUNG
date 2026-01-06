import 'package:flutter/material.dart';
import '../screens/pembayaran_screen.dart';

class CekTagihanTab extends StatefulWidget {
  final List<Map<String, dynamic>> bills;
  final String token;

  const CekTagihanTab({
    super.key,
    required this.bills,
    required this.token,
  });

  @override
  State<CekTagihanTab> createState() => _CekTagihanTabState();
}

class _CekTagihanTabState extends State<CekTagihanTab> {
  String selectedStatus = 'Semua';
  String selectedTanggal = 'Terbaru';

  // ================= STATUS BACKEND (FINAL) =================
  bool _belumDibayar(Map<String, dynamic> b) =>
      b['status'] == 'belum_dibayar';

  bool _lunas(Map<String, dynamic> b) =>
      b['status'] == 'lunas';

  bool _menungguVerifikasi(Map<String, dynamic> b) =>
      b['is_waiting'] == true;

  @override
  Widget build(BuildContext context) {
    final belumBayar =
        widget.bills.where(_belumDibayar).toList();

    final lunas =
        widget.bills.where(_lunas).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        /* ================= SUMMARY ================= */
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Ringkasan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              DateTime.now().year.toString(),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                title: "Belum Dibayar",
                count: "${belumBayar.length} Tagihan",
                total: "Rp ${_sum(belumBayar)}",
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _summaryCard(
                title: "Sudah Dibayar",
                count: "${lunas.length} Tagihan",
                total: "Rp ${_sum(lunas)}",
                color: Colors.green,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /* ================= FILTER ================= */
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedStatus,
                items: const [
                  DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                  DropdownMenuItem(
                      value: 'Belum Dibayar', child: Text('Belum Dibayar')),
                  DropdownMenuItem(
                      value: 'Sudah Dibayar', child: Text('Sudah Dibayar')),
                ],
                onChanged: (v) => setState(() => selectedStatus = v!),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedTanggal,
                items: const [
                  DropdownMenuItem(value: 'Terbaru', child: Text('Terbaru')),
                  DropdownMenuItem(value: 'Terlama', child: Text('Terlama')),
                ],
                onChanged: (v) => setState(() => selectedTanggal = v!),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        /* ================= LIST ================= */
        ..._filteredBills()
            .map((b) => _billCard(context, b))
            .toList(),
      ],
    );
  }

  // ================= HELPERS =================
  int _sum(List<Map<String, dynamic>> bills) {
    return bills.fold<int>(
      0,
      (s, b) => s + (b['jumlah'] as int? ?? 0),
    );
  }

  List<Map<String, dynamic>> _filteredBills() {
    var data = List<Map<String, dynamic>>.from(widget.bills);

    if (selectedStatus == 'Belum Dibayar') {
      data = data.where(_belumDibayar).toList();
    } else if (selectedStatus == 'Sudah Dibayar') {
      data = data.where(_lunas).toList();
    }

    data.sort((a, b) {
      final da = DateTime.tryParse(a['tanggal']) ?? DateTime(2000);
      final db = DateTime.tryParse(b['tanggal']) ?? DateTime(2000);
      return selectedTanggal == 'Terbaru'
          ? db.compareTo(da)
          : da.compareTo(db);
    });

    return data;
  }

  // ================= UI =================
  Widget _summaryCard({
    required String title,
    required String count,
    required String total,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 8),
          Text(count, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            total,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _billCard(BuildContext context, Map<String, dynamic> b) {
    final canPay = b['can_pay'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            'Tagihan #${b['id']}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          _statusBadge(b),
        ]),
        const SizedBox(height: 6),
        Text('Tanggal: ${b['tanggal']}'),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            'Rp ${b['jumlah']}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (canPay)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PembayaranScreen(
                      bill: b,
                      token: widget.token,
                    ),
                  ),
                );
              },
              child: const Text("Bayar Sekarang"),
            ),
        ]),
      ]),
    );
  }

  Widget _statusBadge(Map<String, dynamic> b) {
    if (_lunas(b)) {
      return _badge('Sudah Dibayar', Colors.green);
    }

    if (_menungguVerifikasi(b)) {
      return _badge('Menunggu Verifikasi', Colors.amber);
    }

    return _badge('Belum Dibayar', Colors.orange);
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(color: color)),
    );
  }
}