import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/admin_sidebar.dart';
import '../services/pelanggan_admin_service.dart';

class ManageCustomerScreen extends StatefulWidget {
  const ManageCustomerScreen({super.key});

  @override
  State<ManageCustomerScreen> createState() => _ManageCustomerScreenState();
}

class _ManageCustomerScreenState extends State<ManageCustomerScreen> {
  String searchQuery = "";
  bool loading = true;

  List<Map<String, dynamic>> customers = [];

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
    try {
      final token = await _getToken();
      final res = await PelangganAdminService.list(token);

      setState(() {
        customers = List<Map<String, dynamic>>.from(res);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  List<Map<String, dynamic>> getFilteredCustomers() {
    if (searchQuery.isEmpty) return customers;

    final q = searchQuery.toLowerCase();
    return customers.where((c) {
      final nama = (c['nama'] ?? '').toString().toLowerCase();
      final phone = (c['phone'] ?? '').toString().toLowerCase();
      return nama.contains(q) || phone.contains(q);
    }).toList();
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
          : customers.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada pelanggan",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        onChanged: (v) =>
                            setState(() => searchQuery = v),
                        decoration: const InputDecoration(
                          hintText: "Cari nama atau WhatsApp",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        children: getFilteredCustomers().map((c) {
                          return _customerCard(
                            context,
                            c['id'],
                            c['nama'] ?? '-',
                            c['phone'] ?? '-',
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
                Text(phone,
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmDelete(id),
          )
        ],
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Pelanggan"),
        content:
            const Text("Apakah Anda yakin ingin menghapus pelanggan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final token = await _getToken();
              await PelangganAdminService.delete(token, id);
              _loadCustomers();
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddCustomerPopup(BuildContext context) {
    final nameC = TextEditingController();
    final phoneC = TextEditingController();
    final alamatC = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Pelanggan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameC,
                decoration:
                    const InputDecoration(labelText: "Nama")),
            TextField(
                controller: phoneC,
                decoration:
                    const InputDecoration(labelText: "No WhatsApp")),
            TextField(
                controller: alamatC,
                decoration:
                    const InputDecoration(labelText: "Alamat")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              final token = await _getToken();
              await PelangganAdminService.create(
                token,
                nameC.text,
                phoneC.text,
                alamatC.text,
              );
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