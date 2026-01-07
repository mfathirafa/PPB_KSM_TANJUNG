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
        throw Exception('Token tidak ditemukan');
      }

      final data = await LaporanService.getDashboard(token);

      if (!mounted) return;

      setState(() {
        totalIncome = int.tryParse(
              data['summary']?['total_pendapatan'].toString() ?? '0',
            ) ??
            0;

        totalBills = int.tryParse(
              data['summary']?['total_tagihan'].toString() ?? '0',
            ) ??
            0;

        chartData =
            List<Map<String, dynamic>>.from(data['chart'] ?? []);
        transactions =
            List<Map<String, dynamic>>.from(data['transactions'] ?? []);

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
        title: const Text('Laporan Keuangan'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _summaryCard(
                        'Total Pendapatan',
                        'Rp $totalIncome',
                      ),
                      const SizedBox(width: 10),
                      _summaryCard(
                        'Total Tagihan',
                        '$totalBills Tagihan',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Grafik Pendapatan 7 Hari Terakhir',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _overviewChart(),

                  const SizedBox(height: 24),

                  const Text(
                    'Transaksi Terbaru',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _transactionTable(),
                ],
              ),
            ),
    );
  }

  // ================= UI =================

  Widget _summaryCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _overviewChart() {
    if (chartData.isEmpty) {
      return const Text('Tidak ada data grafik');
    }

    final values = chartData
        .map((e) => int.tryParse(e['total'].toString()) ?? 0)
        .toList();

    final maxValue = values.reduce((a, b) => a > b ? a : b);

    return Container(
      height: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxValue == 0 ? 1000 : (maxValue * 1.2),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),

          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

            // === Y AXIS (RUPIAH) ===
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: maxValue <= 5000 ? 1000 : 5000,
                getTitlesWidget: (value, _) {
                  if (value == 0) return const Text('0');
                  return Text('${(value ~/ 1000)}K');
                },
              ),
            ),

            // === X AXIS (TANGGAL) ===
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final index = value.toInt();
                  if (index < 0 || index >= chartData.length) {
                    return const SizedBox.shrink();
                  }
                  final date = chartData[index]['tanggal'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      date.substring(8), // ambil tanggal (DD)
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),

          barGroups: chartData.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY:
                      (int.tryParse(e.value['total'].toString()) ?? 0).toDouble(),
                  width: 14,
                  borderRadius: BorderRadius.circular(4),
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
      padding: const EdgeInsets.all(14),
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
                  child: Text('Tanggal',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  child: Text('Tagihan',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  child: Text('Pelanggan',
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          const Divider(),
          ...transactions.map((tx) {
            return Row(
              children: [
                Expanded(child: Text(tx['tanggal'] ?? '-')),
                Expanded(child: Text(tx['tagihan_id'].toString())),
                Expanded(child: Text(tx['nama'] ?? '-')),
              ],
            );
          }),
        ],
      ),
    );
  }
}