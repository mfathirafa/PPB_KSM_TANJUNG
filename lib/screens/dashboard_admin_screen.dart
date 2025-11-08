import 'package:flutter/material.dart';
import 'manage_customer_screen.dart';
import 'payment_history_screen.dart';
import '../widgets/dialogs.dart';
import '../widgets/admin_sidebar.dart';
import 'payment_confirmation_screen.dart';

class DashboardAdminScreen extends StatelessWidget {
  const DashboardAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminSidebar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _stats(),
                  const SizedBox(height: 16),
                  _tagihanTable(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =================== HEADER =====================
  Widget _header(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF4CAF50)),
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 10,
        16,
        16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (context) {
                  return IconButton(
                    icon:
                        const Icon(Icons.menu, color: Colors.white, size: 28),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              const Text(
                "KSM Tanjung",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => LogoutConfirmationDialog(),
                  );
                },
                child: Row(
                  children: const [
                    Text(
                      "Keluar",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.logout, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Selamat datang, Oscar Piastri!",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            "Minggu, 20 April 2025",
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // =================== STATISTIK GRID =====================
  Widget _stats() {
    final items = [
      {
        "icon": Icons.person,
        "title": "Total Pelanggan",
        "value": "50",
        "subtitle": "3 Bulan ini",
        "color": Colors.green
      },
      {
        "icon": Icons.receipt_long,
        "title": "Total Tagihan Bulan ini",
        "value": "Rp 50.000",
        "subtitle": "Dari 10 Tagihan",
        "color": Colors.orange
      },
      {
        "icon": Icons.payment,
        "title": "Pembayaran hari ini",
        "value": "Rp 15.000",
        "subtitle": "3 Transaksi",
        "color": Colors.green
      },
      {
        "icon": Icons.history,
        "title": "Menunggu Verifikasi",
        "value": "7",
        "subtitle": "Perlu ditindak lanjuti",
        "color": Colors.red
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _statCard(
          item["icon"] as IconData,
          item["title"] as String,
          item["value"] as String,
          item["subtitle"] as String,
          item["color"] as Color,
        );
      },
    );
  }

  Widget _statCard(
    IconData icon,
    String title,
    String value,
    String subtitle,
    Color subtitleColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.grey[700]),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(subtitle, style: TextStyle(fontSize: 12, color: subtitleColor)),
        ],
      ),
    );
  }

  // =================== TABEL TAGIHAN =====================
  Widget _tagihanTable(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Data Tagihan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaymentHistoryScreen()),
                );
              },
              child: const Text(
                "Lihat Semua >",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _tagihanRow("Lando Norris", "April 2025", "Rp. 5.000", "Belum Dibayar",
            const Color(0xFFFFCC80)),
        _tagihanRow("Charles Leclerc", "April 2025", "Rp. 5.000", "Lunas",
            const Color(0xFFA5D6A7)),
        _tagihanRow("Ace Anthem", "April 2025", "Rp. 5.000", "Terlambat",
            const Color(0xFFEF9A9A)),
      ],
    );
  }

  Widget _tagihanRow(
    String nama,
    String bulan,
    String jumlah,
    String status,
    Color tagBgColor,
  ) {
    Color tagTextColor;

    if (tagBgColor == const Color(0xFFFFCC80)) {
      tagTextColor = Colors.orange.shade800;
    } else if (tagBgColor == const Color(0xFFA5D6A7)) {
      tagTextColor = Colors.green.shade800;
    } else {
      tagTextColor = Colors.red.shade800;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(bulan,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ]),
          Text(jumlah),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: tagBgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                color: tagTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
