import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/admin_sidebar.dart';
import '../services/api_service.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  String filterStatus = "Semua";
  List<Map<String, dynamic>> allBills = [];
  bool loading = true;

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
    final token = await _getToken();
    final res = await ApiService.getAdminPembayaran(token);

    setState(() {
      allBills = res.map<Map<String, dynamic>>((b) {
        final isPaid = b['status'] == 'lunas' || b['status'] == 'paid';

        return {
          "id": b['id'].toString(),
          "name": b['nama'],
          "phone": b['phone'],
          "amount": b['jumlah'].toString(),
          "due": b['jatuh_tempo'],
          "status": isPaid ? "Sudah Dibayar" : "Belum Dibayar",
          "color": isPaid ? Colors.green : Colors.orange,
        };
      }).toList();

      loading = false;
    });
  }

  List<Map<String, dynamic>> get filteredBills {
    if (filterStatus == "Semua") return allBills;
    return allBills.where((b) => b["status"] == filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminSidebar(),
      endDrawer: _FilterSidebar(
        selectedStatus: filterStatus,
        onApply: (value) => setState(() => filterStatus = value),
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
          const SizedBox(width: 8),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (var bill in filteredBills)
                  _paymentHistoryCard(
                    bill["id"],
                    bill["name"],
                    bill["phone"],
                    bill["amount"],
                    bill["due"],
                    bill["status"],
                    bill["color"],
                  ),
                const SizedBox(height: 80),
              ],
            ),
    );
  }

  Widget _paymentHistoryCard(
    String tagId,
    String name,
    String phone,
    String amount,
    String dueDate,
    String status,
    Color statusColor,
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
              Text("#TAG-$tagId",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(phone, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Jatuh Tempo : $dueDate",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text("Rp $amount",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          )
        ],
      ),
    );
  }
}

/* ================= FILTER SIDEBAR (TIDAK DIUBAH) ================= */

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
                    value: "Sudah Dibayar", child: Text("Sudah Dibayar")),
                DropdownMenuItem(
                    value: "Belum Dibayar", child: Text("Belum Dibayar")),
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