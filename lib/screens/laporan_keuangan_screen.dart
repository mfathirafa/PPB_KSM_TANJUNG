import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/admin_sidebar.dart';

class LaporanKeuanganScreen extends StatelessWidget {
  const LaporanKeuanganScreen({super.key});

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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _summaryCard('Total Pendapatan', 'Rp 150.000'),
                _summaryCard('Total Tagihan dibuat', '30 Tagihan'),
              ],
            ),
            const SizedBox(height: 25),

            const Text(
              'Financial Overview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _overviewChart(),
            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Transaksi Terbaru',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _transactionTable(),
            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download),
                    label: const Text('Download CSV'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.black12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showGeneratePdfPopup(context),
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Generate PDF Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
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
          maxY: 25,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 28),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = [
                    '20 Apr','21 Apr','22 Apr','23 Apr','24 Apr','25 Apr','26 Apr'
                  ];
                  return Text(
                    days[value.toInt() % days.length],
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: List.generate(7, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(toY: (10 + i * 2).toDouble(), color: Colors.green),
                BarChartRodData(toY: (6 + i).toDouble(), color: Colors.blue),
                BarChartRodData(toY: (4 + i * 0.5).toDouble(), color: Colors.orange),
              ],
              barsSpace: 3,
            );
          }),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _transactionTable() {
    final transactions = [
      {'date': '26 April 2025', 'id': '#TAG-008', 'name': 'Fathi Setiawan'},
      {'date': '25 April 2025', 'id': '#TAG-005', 'name': 'Rafa Bagas'},
      {'date': '24 April 2025', 'id': '#TAG-004', 'name': 'Eduardo Julian'},
      {'date': '23 April 2025', 'id': '#TAG-003', 'name': 'Edo James'},
    ];

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
              Expanded(child: Text('Tanggal', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text('ID Tagihan', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text('Pelanggan', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 8),

          for (var tx in transactions)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(child: Text(tx['date']!)),
                  Expanded(child: Text(tx['id']!)),
                  Expanded(child: Text('${tx['name']} \n+62 812-3456-789')),
                ],
              ),
            ),
        ],
      ),
    );
  }


  void _showGeneratePdfPopup(BuildContext context) {
    String reportTitle = "Financial Report";
    bool includeMetrics = false;
    bool includeCharts = false;
    bool includeTransactions = false;
    TextEditingController notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Generate PDF Report",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close, size: 22),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      const Text("Report Title", style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: TextEditingController(text: reportTitle),
                        onChanged: (v) => reportTitle = v,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text("Include Section", style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),

                      CheckboxListTile(
                        value: includeMetrics,
                        onChanged: (v) => setState(() => includeMetrics = v ?? false),
                        title: const Text("Metrics Overview"),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),

                      CheckboxListTile(
                        value: includeCharts,
                        onChanged: (v) => setState(() => includeCharts = v ?? false),
                        title: const Text("Financial Charts"),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),

                      CheckboxListTile(
                        value: includeTransactions,
                        onChanged: (v) => setState(() => includeTransactions = v ?? false),
                        title: const Text("Transaction History"),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),

                      const SizedBox(height: 16),

                      const Text("Additional Notes",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: notesController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Add any notes or comments to include in the report",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("PDF berhasil diunduh")),
                                );
                              },
                              icon: const Icon(Icons.download),
                              label: const Text("Unduh"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.share),
                              label: const Text("Bagikan"),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: const BorderSide(color: Colors.black26),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
