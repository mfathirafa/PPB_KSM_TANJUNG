import 'package:flutter/material.dart';
import '../services/admin_dashboard_service.dart';
import '../widgets/admin_sidebar.dart';
import '../widgets/dialogs.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  bool loading = true;
  String? error;

  Map<String, dynamic> stats = {};
  List<Map<String, dynamic>> tagihanTerbaru = [];
  String tanggal = '';

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final data = await AdminDashboardService.fetch();

      setState(() {
        tanggal = data['tanggal'] ?? '-';
        stats = Map<String, dynamic>.from(data['stats'] ?? {});
        tagihanTerbaru =
            List<Map<String, dynamic>>.from(data['tagihan_terbaru'] ?? []);
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Text(error!, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    return Scaffold(
      drawer: const AdminSidebar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(context),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _statsGrid(),
                  const SizedBox(height: 20),
                  _tagihanTerbaruSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header(BuildContext context) {
    return Container(
      color: const Color(0xFF4CAF50),
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 12,
        16,
        16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          Column(
            children: [
              const Text(
                "KSM Tanjung",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                tanggal,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
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
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                SizedBox(width: 4),
                Icon(Icons.logout, color: Colors.white, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= STAT GRID =================
  Widget _statsGrid() {
    final pelanggan =
        Map<String, dynamic>.from(stats['pelanggan'] ?? {});
    final tagihan =
        Map<String, dynamic>.from(stats['tagihan'] ?? {});
    final pembayaran =
        Map<String, dynamic>.from(stats['pembayaran_hari_ini'] ?? {});
    final menunggu = stats['menunggu_verifikasi'] ?? 0;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _statCard(
          Icons.person,
          "Total Pelanggan",
          pelanggan['total']?.toString() ?? '0',
          "${pelanggan['aktif_3_bulan'] ?? 0} aktif 3 bulan ini",
        ),
        _statCard(
          Icons.receipt_long,
          "Total Tagihan Bulan Ini",
          "Rp ${tagihan['total_rp_bulan_ini'] ?? 0}",
          "Dari ${tagihan['total_tagihan_bulan_ini'] ?? 0} tagihan",
        ),
        _statCard(
          Icons.payments,
          "Pembayaran Hari Ini",
          "Rp ${pembayaran['total_rp'] ?? 0}",
          "${pembayaran['total_transaksi'] ?? 0} transaksi",
        ),
        _statCard(
          Icons.history,
          "Menunggu Verifikasi",
          menunggu.toString(),
          "Perlu ditindaklanjuti",
          warning: true,
        ),
      ],
    );
  }

  Widget _statCard(
    IconData icon,
    String title,
    String value,
    String subtitle, {
    bool warning = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[700]),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: warning ? Colors.red : Colors.black,
            ),
          ),
          const Spacer(),
          Text(subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  // ================= TAGIHAN TERBARU =================
  Widget _tagihanTerbaruSection() {
    if (tagihanTerbaru.isEmpty) {
      return const Text(
        "Belum ada data tagihan",
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Data Tagihan",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...tagihanTerbaru.map((t) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 3),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t['nama'] ?? '-',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(t['tanggal'] ?? '-',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Text("Rp ${t['jumlah'] ?? 0}"),
                _statusBadge(t['status'] ?? '-'),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case 'lunas':
        bg = Colors.green.shade100;
        text = Colors.green.shade800;
        label = 'LUNAS';
        break;

      case 'pending':
        bg = Colors.blue.shade100;
        text = Colors.blue.shade800;
        label = 'MENUNGGU VERIFIKASI';
        break;

      case 'belum_dibayar':
        bg = Colors.orange.shade100;
        text = Colors.orange.shade800;
        label = 'BELUM DIBAYAR';
        break;

      default:
        bg = Colors.grey.shade300;
        text = Colors.grey.shade800;
        label = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: text, fontWeight: FontWeight.bold),
      ),
    );
  }
}