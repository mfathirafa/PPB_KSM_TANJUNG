import 'package:flutter/material.dart';

class RiwayatScreen extends StatelessWidget {
  final List<dynamic> history;
  const RiwayatScreen({required this.history, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'KSM Tanjung',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Tagihan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
      body: RiwayatTab(history: history),
    );
  }
}

// =======================================================
// ======================= TAB ===========================
// =======================================================

class RiwayatTab extends StatefulWidget {
  final List<dynamic> history;
  const RiwayatTab({required this.history, super.key});

  @override
  _RiwayatTabState createState() => _RiwayatTabState();
}

class _RiwayatTabState extends State<RiwayatTab> {
  String selectedStatus = 'Semua';
  String selectedTanggal = 'Terbaru';

  bool _isConfirmed(String status) => status == 'confirmed';

  List<dynamic> _filteredHistory() {
    List<dynamic> data = List.from(widget.history);

    if (selectedStatus != 'Semua') {
      data = data.where((h) {
        if (selectedStatus == 'Sudah Dibayar') {
          return h['status'] == 'confirmed';
        }
        return h['status'] == 'pending';
      }).toList();
    }

    data.sort((a, b) {
      final aDate = DateTime.parse(a['created_at']);
      final bDate = DateTime.parse(b['created_at']);
      return selectedTanggal == 'Terbaru'
          ? bDate.compareTo(aDate)
          : aDate.compareTo(bDate);
    });

    return data;
  }

  String _formatDate(String raw) {
    final d = DateTime.parse(raw);
    return '${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
  }

  Widget _statusChip(String status) {
    final isConfirmed = status == 'confirmed';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isConfirmed
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFFFFDE7),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isConfirmed
              ? Colors.green.shade200
              : Colors.amber.shade200,
        ),
      ),
      child: Text(
        isConfirmed ? 'Terkonfirmasi' : 'Menunggu Pembayaran',
        style: TextStyle(
          color: isConfirmed
              ? Colors.green.shade800
              : Colors.amber.shade800,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _filteredHistory();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lihat Transaksi Pembayaran Anda',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items: ['Semua', 'Sudah Dibayar', 'Belum Dibayar']
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => selectedStatus = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedTanggal,
                  items: ['Terbaru', 'Terlama']
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => selectedTanggal = v!),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Expanded(
            child: data.isEmpty
                ? const Center(
                    child: Text('Belum ada riwayat pembayaran'),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (_, i) {
                      final h = data[i];
                      final isConfirmed =
                          _isConfirmed(h['status']);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tagihan #${h['tagihan_id']}',
                                    style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold),
                                  ),
                                  _statusChip(h['status']),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(h['created_at']),
                                style: TextStyle(
                                    color: Colors.grey[600]),
                              ),
                              Divider(
                                  height: 24,
                                  color: Colors.grey.shade200),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(h['metode']),
                                  Text(
                                    'Rp ${h['jumlah_bayar']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isConfirmed
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}