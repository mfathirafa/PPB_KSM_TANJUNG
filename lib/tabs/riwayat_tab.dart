import 'package:flutter/material.dart';

class RiwayatScreen extends StatelessWidget {
  final List<Map<String, dynamic>> dummyHistory = const [
    {
      'id': '12345',
      'title': 'Tagihan #12345',
      'date': '26 April 2025, 14:25',
      'status': 'Terkonfirmasi',
      'method': 'QRIS (E-wallet)',
      'amount': '15.000',
      'timestamp': 1714125900,
    },
    {
      'id': '12346',
      'title': 'Tagihan #12346',
      'date': '26 April 2025, 14:26',
      'status': 'Menunggu Pembayaran',
      'method': 'Bank Transfer',
      'amount': '15.000',
      'timestamp': 1714125960,
    },
    {
      'id': '12347',
      'title': 'Tagihan #12347',
      'date': '27 April 2025, 10:00',
      'status': 'Menunggu Pembayaran',
      'method': 'Virtual Account',
      'amount': '50.000',
      'timestamp': 1714208000,
    },
    {
      'id': '12348',
      'title': 'Tagihan #12348',
      'date': '25 April 2025, 12:00',
      'status': 'Terkonfirmasi',
      'method': 'Kartu Kredit',
      'amount': '100.000',
      'timestamp': 1714032000,
    },
  ];

  const RiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        // Hapus leading IconButton jika tidak ada halaman sebelumnya (opsional)
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        // Mengubah judul AppBar agar ringkas, dan memindahkan subjudul panjang ke body.
        title: const Text(
          'KSM Tanjung', // Judul utama
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
      ),
      // Tambahkan BottomNavigationBar seperti pada screenshot
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2, // Riwayat
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
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
          ), // Ikon Riwayat aktif
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
      body: RiwayatTab(history: dummyHistory),
    );
  }
}

// Komponen utama Riwayat Tab
class RiwayatTab extends StatefulWidget {
  final List<Map<String, dynamic>> history;
  const RiwayatTab({required this.history, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RiwayatTabState createState() => _RiwayatTabState();
}

class _RiwayatTabState extends State<RiwayatTab> {
  String selectedStatus = 'Semua';
  String selectedTanggal = 'Terbaru';

  List<Map<String, dynamic>> _getFilteredAndSortedHistory() {
    List<Map<String, dynamic>> filtered = widget.history;

    if (selectedStatus != 'Semua') {
      String statusToFilter = selectedStatus == 'Sudah Dibayar'
          ? 'Terkonfirmasi'
          : 'Menunggu Pembayaran';
      filtered = filtered.where((h) => h['status'] == statusToFilter).toList();
    }

    // Sorting
    if (selectedTanggal == 'Terbaru') {
      filtered.sort((a, b) {
        final tsA = (a['timestamp'] as int?) ?? 0;
        final tsB = (b['timestamp'] as int?) ?? 0;
        return tsB.compareTo(tsA); // Terbaru (descending)
      });
    } else if (selectedTanggal == 'Terlama') {
      filtered.sort((a, b) {
        final tsA = (a['timestamp'] as int?) ?? 0;
        final tsB = (b['timestamp'] as int?) ?? 0;
        return tsA.compareTo(tsB); // Terlama (ascending)
      });
    }

    return filtered;
  }

  Widget _buildStatusChip(String status) {
    bool isConfirmed = status == 'Terkonfirmasi';
    Color bgColor = isConfirmed
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFFDE7);
    Color textColor = isConfirmed
        ? Colors.green.shade800
        : Colors.amber.shade800;
    String displayText = status == 'Terkonfirmasi'
        ? 'Terkonfirmasi'
        : 'Menunggu Pembayaran';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isConfirmed ? Colors.green.shade200 : Colors.amber.shade200,
        ),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  // Menggunakan labelText agar teks pilihan tidak terpotong
  InputDecoration _dropdownDecoration({required String label}) {
    const OutlineInputBorder borderStyle = OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );

    return InputDecoration(
      labelText: label, // Menggunakan labelText untuk nama filter
      labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white,
      filled: true,
      isDense: true,
      // Mengurangi padding vertikal untuk tampilan yang lebih compact
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: borderStyle,
      enabledBorder: borderStyle,
      focusedBorder: borderStyle.copyWith(
        borderSide: const BorderSide(color: Color(0xFFC0C0C0), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFilteredAndSortedHistory();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul yang dipindahkan dari AppBar ke Body
          const Text(
            'Lihat Transaksi Pembayaran Anda',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // Dropdown Filters
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  // Menggunakan nilai yang ada pada daftar (menghindari error saat nilai null/tidak valid)
                  value:
                      [
                        'Semua',
                        'Sudah Dibayar',
                        'Belum Dibayar',
                      ].contains(selectedStatus)
                      ? selectedStatus
                      : 'Semua',
                  decoration: _dropdownDecoration(
                    label: selectedStatus,
                  ), // Label menunjukkan nilai yang dipilih
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                  // Font size disesuaikan agar muat
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                  items: ['Semua', 'Sudah Dibayar', 'Belum Dibayar']
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ), // Pastikan teks item juga aman
                        ),
                      )
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
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: ['Terbaru', 'Terlama'].contains(selectedTanggal)
                      ? selectedTanggal
                      : 'Terbaru',
                  decoration: _dropdownDecoration(
                    label: selectedTanggal,
                  ), // Label menunjukkan nilai yang dipilih
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                  // Font size disesuaikan agar muat
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                  items: ['Terbaru', 'Terlama']
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      )
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
          const SizedBox(height: 16),

          // List transaksi
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('Belum ada riwayat pembayaran'))
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final h = filtered[i];
                      bool isConfirmed = h['status'] == 'Terkonfirmasi';

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Menggunakan Flexible untuk mencegah overflow jika judul terlalu panjang
                                  Flexible(
                                    child: Text(
                                      h['title'] ?? 'Tanpa Judul',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  _buildStatusChip(h['status']),
                                ],
                              ),

                              const SizedBox(height: 4),
                              Text(
                                h['date'] ?? '-',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),

                              Divider(height: 24, color: Colors.grey.shade200),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    h['method'] ?? '-',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'Rp ${h['amount'] ?? '0'}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: isConfirmed
                                          ? Colors.green.shade700
                                          : Colors.black87,
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
