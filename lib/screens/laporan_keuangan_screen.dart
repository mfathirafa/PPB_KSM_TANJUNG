import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/admin_sidebar.dart';
import '../services/api_service.dart';

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

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> _loadFinanceData() async {
    final token = await _getToken();

    final summary = await ApiService.getFinanceSummary(token);
    final chart = await ApiService.getFinanceChart(token);
    final tx = await ApiService.getRecentTransactions(token);

    setState(() {
      totalIncome = summary['total_income'];
      totalBills = summary['total_bills'];
      chartData = List<Map<String, dynamic>>.from(chart);
      transactions = List<Map<String, dynamic>>.from(tx);
      loading = false;
    });
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _summaryCard('Total Pendapatan', 'Rp $totalIncome'),
                      _summaryCard('Total Tagihan dibuat', '$totalBills Tagihan'),
                    ],
                  ),
                  const SizedBox(height: 25),

                  const Text('Financial Overview',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _overviewChart(),
                  const SizedBox(height: 25),

                  const Text('Transaksi Terbaru',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _transactionTable(),
                ],
              ),
            ),
    );
  }

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
            Text(title,
                style:
                    const TextStyle(fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 6),
            Text(value,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _overviewChart() {
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
          maxY: 30,
          barGroups: List.generate(chartData.length, (i) {
            final d = chartData[i];
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(toY: d['paid'].toDouble(), color: Colors.green),
                BarChartRodData(
                    toY: d['unpaid'].toDouble(), color: Colors.blue),
                BarChartRodData(
                    toY: d['pending'].toDouble(), color: Colors.orange),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _transactionTable() {
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
                  child: Text('Tanggal',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  child: Text('ID Tagihan',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  child: Text('Pelanggan',
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 8),
          for (var tx in transactions)
            Row(
              children: [
                Expanded(child: Text(tx['date'])),
                Expanded(child: Text(tx['bill_id'])),
                Expanded(child: Text('${tx['name']}\n+${tx['phone']}')),
              ],
            ),
        ],
      ),
    );
  }
}