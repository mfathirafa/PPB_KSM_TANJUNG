import 'package:flutter/material.dart';
import '../screens/pembayaran_screen.dart';

class CekTagihanTab extends StatefulWidget {
  final List<dynamic> bills;
  const CekTagihanTab({required this.bills, super.key});

  @override
  State<CekTagihanTab> createState() => _CekTagihanTabState();
}

class _CekTagihanTabState extends State<CekTagihanTab> {
  String selectedStatus = 'Semua';
  String selectedTanggal = 'Terbaru';

  bool _isBelumDibayar(String status) =>
      status == 'belum_dibayar' || status == 'pending';

  bool _isSudahDibayar(String status) =>
      status == 'dibayar' || status == 'lunas';

  @override
  Widget build(BuildContext context) {
    final belumDibayar =
        widget.bills.where((b) => _isBelumDibayar(b['status'])).toList();

    final sudahDibayar =
        widget.bills.where((b) => _isSudahDibayar(b['status'])).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        /* ================= SUMMARY ================= */
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Summary",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                title: "Tagihan yang\nbelum dibayar",
                count: "${belumDibayar.length} Tagihan",
                total:
                    "Rp ${_sum(belumDibayar)}",
                color: Colors.green[700]!,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _summaryCard(
                title: "Tagihan yang\nsudah dibayar",
                count: "${sudahDibayar.length} Tagihan",
                total:
                    "Rp ${_sum(sudahDibayar)}",
                color: Colors.black87,
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
                items: ['Semua', 'Belum Dibayar', 'Sudah Dibayar']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => selectedStatus = v!),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedTanggal,
                items: ['Terbaru', 'Terlama']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => selectedTanggal = v!),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        /* ================= LIST ================= */
        ..._filteredBills().map((b) => _billCard(context, b)).toList(),
      ],
    );
  }

  /* ================= HELPERS ================= */
  String _sum(List<dynamic> bills) {
    final total =
        bills.fold<int>(0, (s, b) => s + (b['jumlah'] as int));
    return total.toString();
  }

  List<dynamic> _filteredBills() {
    List<dynamic> data = List.from(widget.bills);

    if (selectedStatus == 'Belum Dibayar') {
      data = data.where((b) => _isBelumDibayar(b['status'])).toList();
    } else if (selectedStatus == 'Sudah Dibayar') {
      data = data.where((b) => _isSudahDibayar(b['status'])).toList();
    }

    if (selectedTanggal == 'Terbaru') {
      data = data.reversed.toList();
    }

    return data;
  }

  /* ================= UI ================= */
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
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4)
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title),
        const SizedBox(height: 8),
        Text(count, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(total,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _billCard(BuildContext context, Map<String, dynamic> b) {
    final bool isPaid = _isSudahDibayar(b['status']);
    final Color badgeColor = isPaid ? Colors.green : Colors.amber;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 6)
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            b['pelanggan']['nama'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isPaid ? 'Sudah Dibayar' : 'Belum Dibayar',
              style: TextStyle(color: badgeColor),
            ),
          ),
        ]),
        Text(b['pelanggan']['no_hp']),
        Text('Tagihan #${b['id']}'),
        const SizedBox(height: 6),
        Text('Tanggal: ${b['tanggal']}'),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Rp ${b['jumlah']}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          if (!isPaid)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PembayaranScreen(bill: b),
                  ),
                );
              },
              child: const Text("Bayar Sekarang"),
            )
        ]),
      ]),
    );
  }
}