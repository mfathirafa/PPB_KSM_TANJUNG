import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/admin_sidebar.dart';
import '../services/laporan_service.dart';

class LaporanKeuanganScreen extends StatefulWidget {
  const LaporanKeuanganScreen({super.key});

  @override
  State<LaporanKeuanganScreen> createState() => _LaporanKeuanganScreenState();
}

class _LaporanKeuanganScreenState extends State<LaporanKeuanganScreen> {
  bool loading = true;

  int totalIncome = 0;
  int totalBills = 0;

  List<Map<String, dynamic>> chartData = [];
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadFinanceData();
  }

  Future<void> _loadFinanceData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        throw Exception('Token tidak ditemukan, silakan login ulang');
      }

      final data = await LaporanService.getDashboard(token);

      if (!mounted) return;

      setState(() {
        totalIncome =
            (data['summary']?['total_pendapatan'] ?? 0) as int;
        totalBills = (data['summary']?['total_tagihan'] ?? 0) as int;

        chartData = List<Map<String, dynamic>>.from(
          data['chart'] ?? [],
        );

        transactions = List<Map<String, dynamic>>.from(
          data['transactions'] ?? [],
        );

        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminSidebar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Financial Report'),
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : chartData.isEmpty && transactions.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada data laporan',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _summaryCard(
                            'Total Pendapatan',
                            'Rp $totalIncome',
                          ),
                          _summaryCard(
                            'Total Tagihan Dibuat',
                            '$totalBills Tagihan',
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      const Text(
                        'Financial Overview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _overviewChart(),
                      const SizedBox(height: 25),

                      const Text(
                        'Transaksi Terbaru',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _transactionTable(),
                    ],
                  ),
                ),
    );
  }

  // ================= UI (TIDAK DIUBAH) =================

  Widget _summaryCard(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style:
                  const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _overviewChart() {
    if (chartData.isEmpty) {
      return const Text('Tidak ada data grafik');
    }

    final maxValue = chartData
        .map((e) => (e['total'] ?? 0) as int)
        .fold<int>(0, (a, b) => a > b ? a : b);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxValue == 0 ? 10 : maxValue.toDouble() + 5,
          barGroups: chartData.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: ((e.value['total'] ?? 0) as int).toDouble(),
                  color: Colors.green,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _transactionTable() {
    if (transactions.isEmpty) {
      return const Text('Belum ada transaksi');
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Tanggal',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  'ID Tagihan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  'Pelanggan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...transactions.map((tx) {
            return Row(
              children: [
                Expanded(child: Text(tx['tanggal'] ?? '-')),
                Expanded(
                    child: Text(tx['tagihan_id']?.toString() ?? '-')),
                Expanded(child: Text(tx['nama'] ?? '-')),
              ],
            );
          }),
        ],
      ),
    );
  }
}