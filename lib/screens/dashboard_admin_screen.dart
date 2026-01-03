import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../widgets/dialogs.dart';
import '../widgets/admin_sidebar.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  Map<String, dynamic>? admin;
  Map<String, dynamic>? dashboard;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception("Token tidak ditemukan, silakan login ulang");
      }

      final me = await ApiService.getMe(token);
      final dash = await ApiService.getAdminDashboard(token);

      setState(() {
        admin = me;
        dashboard = dash;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            error!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    final stats = dashboard!['stats'];
    final List tagihan = dashboard!['tagihan_terbaru'];

    return Scaffold(
      drawer: const AdminSidebar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _stats(stats),
                  const SizedBox(height: 16),
                  _tagihanTable(tagihan),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
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
                    builder: (_) => LogoutConfirmationDialog(),
                  );
                },
                child: Row(
                  children: const [
                    Text("Keluar",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                    SizedBox(width: 4),
                    Icon(Icons.logout, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Selamat datang, ${admin!['name'] ?? 'Admin'}!",
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            dashboard!['tanggal'],
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // =================== STATISTIK =====================
  Widget _stats(Map<String, dynamic> s) {
    final items = [
      {
        "icon": Icons.person,
        "title": "Total Pelanggan",
        "value": s['total_pelanggan'].toString(),
        "subtitle": "Aktif",
        "color": Colors.green
      },
      {
        "icon": Icons.receipt_long,
        "title": "Tagihan Bulan Ini",
        "value": "Rp ${s['total_tagihan_bulan_ini']}",
        "subtitle": "${s['total_tagihan']} Tagihan",
        "color": Colors.orange
      },
      {
        "icon": Icons.payment,
        "title": "Total Pembayaran",
        "value": s['total_pembayaran'].toString(),
        "subtitle": "Transaksi",
        "color": Colors.green
      },
      {
        "icon": Icons.history,
        "title": "Menunggu Verifikasi",
        "value": s['pending_pembayaran'].toString(),
        "subtitle": "Pending",
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
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(subtitle,
              style: TextStyle(fontSize: 12, color: subtitleColor)),
        ],
      ),
    );
  }

  // =================== TAGIHAN =====================
  Widget _tagihanTable(List tagihan) {
    if (tagihan.isEmpty) {
      return const Text("Belum ada tagihan");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Data Tagihan",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...tagihan.take(3).map((t) {
          final status = t['status'];
          Color bg = status == 'lunas'
              ? const Color(0xFFA5D6A7)
              : status == 'belum_dibayar'
                  ? const Color(0xFFFFCC80)
                  : const Color(0xFFEF9A9A);

          return _tagihanRow(
            t['nama'],
            t['tanggal'],
            "Rp ${t['jumlah']}",
            status,
            bg,
          );
        }).toList(),
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
    Color tagTextColor = tagBgColor == const Color(0xFFA5D6A7)
        ? Colors.green.shade800
        : tagBgColor == const Color(0xFFFFCC80)
            ? Colors.orange.shade800
            : Colors.red.shade800;

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
            Text(nama,
                style:
                    const TextStyle(fontWeight: FontWeight.bold)),
            Text(bulan,
                style:
                    const TextStyle(fontSize: 12, color: Colors.grey)),
          ]),
          Text(jumlah),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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