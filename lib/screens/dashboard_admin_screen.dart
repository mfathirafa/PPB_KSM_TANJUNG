import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        throw Exception('Token tidak ditemukan, silakan login ulang');
      }

      final data = await AdminDashboardService.get(token);

      if (!mounted) return;

      setState(() {
        stats = Map<String, dynamic>.from(data['stats'] ?? {});
        tagihanTerbaru =
            List<Map<String, dynamic>>.from(data['tagihan_terbaru'] ?? []);
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
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
                  const SizedBox(height: 16),
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
        MediaQuery.of(context).padding.top + 10,
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
          const Text(
            "Dashboard Admin",
            style: TextStyle(
              fontSize: 18,
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
            child: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ================= STAT GRID =================
  Widget _statsGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _statCard("Total Pelanggan", stats['total_pelanggan'] ?? 0),
        _statCard("Total Tagihan", stats['total_tagihan'] ?? 0),
        _statCard("Total Pembayaran", stats['total_pembayaran'] ?? 0),
        _statCard("Menunggu Verifikasi", stats['pending_pembayaran'] ?? 0),
      ],
    );
  }

  Widget _statCard(String label, dynamic value) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ================= TAGIHAN TERBARU =================
  Widget _tagihanTerbaruSection() {
    if (tagihanTerbaru.isEmpty) {
      return const Text(
        "Belum ada tagihan terbaru",
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tagihan Terbaru",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...tagihanTerbaru.map((t) {
          return ListTile(
            title: Text(t['nama'] ?? '-'),
            subtitle: Text(t['tanggal'] ?? '-'),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Rp ${t['jumlah'] ?? 0}"),
                Text(
                  t['status'] ?? '-',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}