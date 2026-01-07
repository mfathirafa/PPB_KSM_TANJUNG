import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/admin_sidebar.dart';
import '../services/payment_admin_service.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  String filterStatus = "Semua";
  List<Map<String, dynamic>> allPayments = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> _loadData() async {
    try {
      final token = await _getToken();
      if (token.isEmpty) {
        throw Exception("Token tidak ditemukan");
      }

      final res = await PaymentAdminService.list(token);
      final list = List<Map<String, dynamic>>.from(res);

      setState(() {
        allPayments = list.map((p) {
          final status = p['status'];

          final bool isPaid = status == 'confirmed';

          return {
            "id": p['id'].toString(),
            "name": p['nama'] ?? '-',
            "amount": (p['jumlah'] ?? 0).toString(),
            "date": p['tanggal'] ?? '-',
            "status": isPaid
                ? "Sudah Dibayar"
                : status == 'rejected'
                    ? "Ditolak"
                    : "Menunggu Verifikasi",
            "color": isPaid
                ? Colors.green
                : status == 'rejected'
                    ? Colors.red
                    : Colors.orange,
          };
        }).toList();

        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  List<Map<String, dynamic>> get filteredPayments {
    if (filterStatus == "Semua") return allPayments;
    return allPayments.where((p) => p["status"] == filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminSidebar(),
      endDrawer: _FilterSidebar(
        selectedStatus: filterStatus,
        onApply: (v) => setState(() => filterStatus = v),
      ),
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
        title: const Text("Riwayat Pembayaran"),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (var p in filteredPayments)
                      _paymentCard(
                        p['id'],
                        p['name'],
                        p['amount'],
                        p['date'],
                        p['status'],
                        p['color'],
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
    );
  }

  Widget _paymentCard(
    String id,
    String name,
    String amount,
    String date,
    String status,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Pembayaran #$id",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tanggal : $date",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              Text(
                "Rp $amount",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          )
        ],
      ),
    );
  }
}

/* ================= FILTER ================= */

class _FilterSidebar extends StatefulWidget {
  final String selectedStatus;
  final Function(String) onApply;

  const _FilterSidebar({
    required this.selectedStatus,
    required this.onApply,
  });

  @override
  State<_FilterSidebar> createState() => _FilterSidebarState();
}

class _FilterSidebarState extends State<_FilterSidebar> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField(
              value: selectedStatus,
              items: const [
                DropdownMenuItem(value: "Semua", child: Text("Semua")),
                DropdownMenuItem(
                  value: "Sudah Dibayar",
                  child: Text("Sudah Dibayar"),
                ),
                DropdownMenuItem(
                  value: "Menunggu Verifikasi",
                  child: Text("Menunggu Verifikasi"),
                ),
                DropdownMenuItem(
                  value: "Ditolak",
                  child: Text("Ditolak"),
                ),
              ],
              onChanged: (v) => setState(() => selectedStatus = v!),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                widget.onApply(selectedStatus);
                Navigator.pop(context);
              },
              child: const Text("Terapkan"),
            )
          ],
        ),
      ),
    );
  }
}