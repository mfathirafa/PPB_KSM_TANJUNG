import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/admin_sidebar.dart';
import '../services/api_service.dart';

class ManageCustomerScreen extends StatefulWidget {
  const ManageCustomerScreen({super.key});

  @override
  State<ManageCustomerScreen> createState() => _ManageCustomerScreenState();
}

class _ManageCustomerScreenState extends State<ManageCustomerScreen> {
  String filterStatus = "Aktif";
  String searchQuery = "";
  bool loading = true;

  List<Map<String, dynamic>> allCustomers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> _loadCustomers() async {
    final token = await _getToken();
    final res = await ApiService.getCustomers(token);

    setState(() {
      allCustomers = res.map<Map<String, dynamic>>((c) {
        return {
          "id": c["id"],
          "name": c["name"],
          "phone": "+${c["phone"]}",
          "isActive": c["is_active"],
          "lastPay": c["last_payment"] ?? "-",
        };
      }).toList();
      loading = false;
    });
  }

  List<Map<String, dynamic>> getFilteredCustomers() {
    var data = allCustomers;

    if (filterStatus == "Aktif") {
      data = data.where((c) => c["isActive"]).toList();
    } else if (filterStatus == "Tidak Aktif") {
      data = data.where((c) => !c["isActive"]).toList();
    }

    if (searchQuery.isNotEmpty) {
      data = data.where((c) {
        final q = searchQuery.toLowerCase();
        return c["name"].toLowerCase().contains(q) ||
            c["phone"].toLowerCase().contains(q);
      }).toList();
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminSidebar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text("Kelola Pelanggan"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCustomerPopup(context),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (v) =>
                              setState(() => searchQuery = v),
                          decoration: const InputDecoration(
                            hintText: "Cari nama atau WA",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: filterStatus,
                        items: ["Aktif", "Tidak Aktif", "Semua"]
                            .map((v) => DropdownMenuItem(
                                  value: v,
                                  child: Text(v),
                                ))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => filterStatus = v!),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: getFilteredCustomers().map((c) {
                      return _customerCard(
                        context,
                        c["id"],
                        c["name"],
                        c["phone"],
                        c["isActive"],
                        c["lastPay"],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _customerCard(
    BuildContext context,
    int id,
    String name,
    String phone,
    bool isActive,
    String lastPaymentDate,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(phone, style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 8),
                Text("Pembayaran Terakhir: $lastPaymentDate",
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey[600])),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteCustomer(id),
          )
        ],
      ),
    );
  }

  Future<void> _deleteCustomer(int id) async {
    final token = await _getToken();
    await ApiService.deleteCustomer(token, id);
    _loadCustomers();
  }

  void _showAddCustomerPopup(BuildContext context) {
    final nameC = TextEditingController();
    final phoneC = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Pelanggan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameC, decoration: const InputDecoration(labelText: "Nama")),
            TextField(controller: phoneC, decoration: const InputDecoration(labelText: "No WA")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final token = await _getToken();
              await ApiService.addCustomer(token, {
                "name": nameC.text,
                "phone": phoneC.text,
              });
              Navigator.pop(context);
              _loadCustomers();
            },
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }
}
