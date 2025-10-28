import 'package:flutter/material.dart';
import '../screens/pembayaran_screen.dart';

class CekTagihanTab extends StatefulWidget {
  final List<Map<String, dynamic>> bills;
  const CekTagihanTab({required this.bills, super.key});

  @override
  State<CekTagihanTab> createState() => _CekTagihanTabState();
}

class _CekTagihanTabState extends State<CekTagihanTab> {
  String selectedStatus = 'Semua';
  String selectedTanggal = 'Terbaru';

  @override
  Widget build(BuildContext context) {
    final belumDibayar = widget.bills
        .where((b) => (b['status'] ?? '') == 'Belum Dibayar')
        .toList();
    final sudahDibayar = widget.bills
        .where(
          (b) =>
              (b['status'] ?? '') == 'Sudah Dibayar' ||
              (b['status'] ?? '') == 'Lunas',
        )
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        /* --------------------------- Summary --------------------------- */
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Summary",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "April 2025",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
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
                    "Rp ${belumDibayar.fold<double>(0.0, (sum, b) => sum + (b['amount'] ?? 0.0)).toStringAsFixed(0)}",
                color: Colors.green[700]!,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _summaryCard(
                title: "Tagihan yang\nsudah dibayar",
                count: "${sudahDibayar.length} Tagihan",
                total:
                    "Rp ${sudahDibayar.fold<double>(0.0, (sum, b) => sum + (b['amount'] ?? 0.0)).toStringAsFixed(0)}",
                color: Colors.black87,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /* --------------------------- Filter Dropdown --------------------------- */
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: ['Semua', 'Belum Dibayar', 'Sudah Dibayar']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedStatus = val!),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedTanggal,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: ['Terbaru', 'Terlama']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedTanggal = val!),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        /* --------------------------- Daftar Tagihan --------------------------- */
        ..._filteredBills().map((b) => _billCard(context, b)).toList(),
      ],
    );
  }

  /* --------------------------- Filter Function --------------------------- */
  List<Map<String, dynamic>> _filteredBills() {
    List<Map<String, dynamic>> filtered = List.from(widget.bills);

    if (selectedStatus != 'Semua') {
      filtered = filtered
          .where((b) => (b['status'] ?? '') == selectedStatus)
          .toList();
    }

    if (selectedTanggal == 'Terbaru') {
      filtered = filtered.reversed.toList();
    }

    return filtered;
  }

  /* --------------------------- Widget: Summary Card --------------------------- */
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
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
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

  /* --------------------------- Widget: Bill Card --------------------------- */
  Widget _billCard(BuildContext context, Map<String, dynamic> b) {
    final bool isPaid =
        (b['status'] ?? '') == 'Sudah Dibayar' ||
        (b['status'] ?? '') == 'Lunas';
    final Color badgeColor = isPaid ? Colors.green : Colors.amber;
    final String badgeText = isPaid ? 'Sudah Dibayar' : 'Belum Dibayar';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* ---------- Header ---------- */
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (b['name'] ?? '').toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 12,
                    color: badgeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            (b['phone'] ?? '').toString(),
            style: TextStyle(color: Colors.grey[700]),
          ),
          Text(
            'Tagihan #${(b['id'] ?? '').toString()}',
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            isPaid
                ? 'Dibayar: ${(b['due'] ?? '').toString()}'
                : 'Jatuh Tempo: ${(b['due'] ?? '').toString()}',
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rp ${(b['amount'] ?? 0.0).toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (!isPaid)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PembayaranScreen(bill: b),
                      ),
                    );
                  },
                  child: const Text("Bayar Sekarang"),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
