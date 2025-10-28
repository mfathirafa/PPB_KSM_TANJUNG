import 'package:flutter/material.dart';

class RiwayatTab extends StatefulWidget {
  final List<Map<String, dynamic>> history;
  const RiwayatTab({required this.history, super.key});

  @override
  _RiwayatTabState createState() => _RiwayatTabState();
}

class _RiwayatTabState extends State<RiwayatTab> {
  String selectedStatus = 'Semua';
  String selectedTanggal = 'Terbaru';

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filtered = widget.history;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Dropdown Filters
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value:
                      [
                        'Sudah Dibayar',
                        'Belum Dibayar',
                      ].contains(selectedStatus)
                      ? selectedStatus
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Status Pembayaran',
                    labelStyle: TextStyle(color: Colors.green.shade700),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade700),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green.shade700,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  iconEnabledColor: Colors.green.shade700,
                  dropdownColor: Colors.green.shade50,
                  items: ['Semua', 'Sudah Dibayar', 'Belum Dibayar']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedStatus = val;
                      });
                    }
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value:
                      ['Paling Jauh', 'Paling Dekat'].contains(selectedTanggal)
                      ? selectedTanggal
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Tanggal Jatuh Tempo',
                    labelStyle: TextStyle(color: Colors.green.shade700),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade700),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green.shade700,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  iconEnabledColor: Colors.green.shade700,
                  dropdownColor: Colors.green.shade50,
                  items: ['Paling Dekat', 'Paling Jauh']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedTanggal = val;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // List transaksi
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Text('Belum ada riwayat pembayaran'))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final h = filtered[i];
                      Color statusColor = h['status'] == 'Terkonfirmasi'
                          ? Colors.green.shade100
                          : Colors.yellow.shade100;
                      Color borderColor = h['status'] == 'Terkonfirmasi'
                          ? Colors.green.shade400
                          : Colors.yellow.shade700;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: borderColor, width: 1),
                        ),
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      h['title'] ?? 'Tanpa Judul',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade800,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      h['status'] ?? '-',
                                      style: TextStyle(
                                        color: Colors.green.shade800,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // --- DETAIL YANG SUDAH ANDA KEMBALIKAN (TANGGAL & AMOUNT) ---
                              const SizedBox(height: 4),
                              Text(
                                h['date'] ?? '-',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(h['method'] ?? '-'),
                                  Text(
                                    'Rp ${h['amount'] ?? '0'}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
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
