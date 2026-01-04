import 'package:flutter/material.dart';

class RiwayatTab extends StatefulWidget {
  final List<Map<String, dynamic>> history;
  const RiwayatTab({required this.history, super.key});

  @override
  State<RiwayatTab> createState() => _RiwayatTabState();
}

class _RiwayatTabState extends State<RiwayatTab> {
  String selectedStatus = 'Semua';
  String selectedTanggal = 'Terbaru';

  // =========================
  // STATUS CHECKER (FINAL - BACKEND BASED)
  // =========================
  bool _isLunas(String? status) => status == 'confirmed';
  bool _isPending(String? status) => status == 'pending';
  bool _isWaiting(String? status) => status == 'waiting';
  bool _isRejected(String? status) => status == 'rejected';

  // =========================
  // FILTER DATA
  // =========================
  List<Map<String, dynamic>> _filteredHistory() {
    List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(widget.history);

    if (selectedStatus != 'Semua') {
      data = data.where((h) {
        final status = h['status'];
        if (selectedStatus == 'Sudah Dibayar') {
          return _isLunas(status);
        }
        if (selectedStatus == 'Belum Dibayar') {
          return _isPending(status) || _isWaiting(status);
        }
        return true;
      }).toList();
    }

    data.sort((a, b) {
      final aDate = DateTime.tryParse(a['tanggal'] ?? '') ?? DateTime(2000);
      final bDate = DateTime.tryParse(b['tanggal'] ?? '') ?? DateTime(2000);

      return selectedTanggal == 'Terbaru'
          ? bDate.compareTo(aDate)
          : aDate.compareTo(bDate);
    });

    return data;
  }

  // =========================
  // FORMAT TANGGAL
  // =========================
  String _formatDate(String? raw) {
    if (raw == null) return '-';
    final d = DateTime.tryParse(raw);
    if (d == null) return '-';

    return '${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
  }

  // =========================
  // STATUS CHIP (FINAL)
  // =========================
  Widget _statusChip(String? status) {
    if (_isLunas(status)) {
      return _chip(
        label: 'Sudah Dibayar',
        bg: const Color(0xFFE8F5E9),
        border: Colors.green.shade200,
        text: Colors.green.shade800,
      );
    }

    if (_isRejected(status)) {
      return _chip(
        label: 'Ditolak',
        bg: const Color(0xFFFFEBEE),
        border: Colors.red.shade200,
        text: Colors.red.shade800,
      );
    }

    if (_isWaiting(status)) {
      return _chip(
        label: 'Menunggu Verifikasi',
        bg: const Color(0xFFFFFDE7),
        border: Colors.amber.shade200,
        text: Colors.amber.shade800,
      );
    }

    return _chip(
      label: 'Belum Dibayar',
      bg: const Color(0xFFFFF3E0),
      border: Colors.orange.shade200,
      text: Colors.orange.shade800,
    );
  }

  Widget _chip({
    required String label,
    required Color bg,
    required Color border,
    required Color text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
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

          // ================= FILTER =================
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items: ['Semua', 'Sudah Dibayar', 'Belum Dibayar']
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedStatus = v!),
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
                  onChanged: (v) => setState(() => selectedTanggal = v!),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ================= LIST =================
          Expanded(
            child: data.isEmpty
                ? const Center(child: Text('Belum ada riwayat pembayaran'))
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (_, i) {
                      final h = data[i];
                      final isLunas = _isLunas(h['status']);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tagihan #${h['tagihan_id'] ?? '-'}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  _statusChip(h['status']),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(h['tanggal']),
                                style:
                                    TextStyle(color: Colors.grey[600]),
                              ),
                              Divider(
                                  height: 24,
                                  color: Colors.grey.shade200),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(h['metode'] ?? '-'),
                                  Text(
                                    'Rp ${h['jumlah'] ?? 0}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isLunas
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