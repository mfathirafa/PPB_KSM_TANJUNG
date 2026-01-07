import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../widgets/admin_sidebar.dart';
import '../services/pelanggan_admin_service.dart';
import '../services/base_service.dart';

class ManageCustomerScreen extends StatefulWidget {
  const ManageCustomerScreen({super.key});

  @override
  State<ManageCustomerScreen> createState() => _ManageCustomerScreenState();
}

class _ManageCustomerScreenState extends State<ManageCustomerScreen> {
  bool loading = true;
  String searchQuery = '';
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
      loading = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  List<Map<String, dynamic>> get filtered {
    if (searchQuery.isEmpty) return customers;
    final q = searchQuery.toLowerCase();
    return customers.where((c) {
      return (c['nama'] ?? '').toLowerCase().contains(q) ||
          (c['phone'] ?? '').toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminSidebar(),
      appBar: AppBar(
        title: const Text("Kelola Pelanggan"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (v) => setState(() => searchQuery = v),
                    decoration: const InputDecoration(
                      hintText: "Cari nama atau WhatsApp",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(
                          child: Text("Belum ada pelanggan",
                              style: TextStyle(color: Colors.grey)),
                        )
                      : ListView.builder(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) =>
                              _customerCard(filtered[i]),
                        ),
                )
              ],
            ),
    );
  }

  // ================= CARD =================

  Widget _customerCard(Map<String, dynamic> c) {
    final bool aktif = c['status'] == 'aktif';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          Text(c['nama'] ?? '-',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(c['phone'] ?? '-',
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),

          Row(
            children: [
              _statusBadge(aktif),
              const SizedBox(width: 10),
              Text(
                c['last_payment'] != null
                    ? "Bayar terakhir: ${c['last_payment']}"
                    : "Belum pernah bayar",
                style:
                    const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),

          const Divider(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.receipt_long),
                label: const Text("Tagihan"),
                onPressed: () => _showCreateBillDialog(c),
              ),
              TextButton.icon(
                icon: const Icon(Icons.edit, size: 18),
                label: const Text("Edit"),
                onPressed: () => _showEditDialog(c),
              ),
              TextButton.icon(
                icon:
                    const Icon(Icons.delete, color: Colors.red, size: 18),
                label:
                    const Text("Hapus", style: TextStyle(color: Colors.red)),
                onPressed: () => _confirmDelete(c['id']),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _statusBadge(bool aktif) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: aktif ? Colors.green.shade100 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        aktif ? 'AKTIF' : 'NONAKTIF',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: aktif ? Colors.green.shade800 : Colors.grey.shade800,
        ),
      ),
    );
  }

  // ================= TAGIHAN =================

  void _showCreateBillDialog(Map<String, dynamic> c) {
    final jumlahCtrl = TextEditingController();
    final tanggalCtrl = TextEditingController(
      text: DateTime.now().toString().substring(0, 10),
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Buat Tagihan - ${c['nama']}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: jumlahCtrl,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: "Jumlah Tagihan"),
            ),
            TextField(
              controller: tanggalCtrl,
              decoration: const InputDecoration(
                labelText: "Tanggal (YYYY-MM-DD)",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            child: const Text("Simpan"),
            onPressed: () async {
              final token = await _getToken();

              await http.post(
                Uri.parse('${BaseService.baseUrl}/admin/tagihan'),
                headers: BaseService.headers(token),
                body: jsonEncode({
                  'pelanggan_id': c['id'],
                  'jumlah': int.parse(jumlahCtrl.text),
                  'tanggal': tanggalCtrl.text,
                }),
              );

              Navigator.pop(context);
              _loadCustomers();
            },
          ),
        ],
      ),
    );
  }

  // ================= EDIT =================

  void _showEditDialog(Map<String, dynamic> c) {
    final nameC = TextEditingController(text: c['nama']);
    final alamatC = TextEditingController(text: c['alamat']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Pelanggan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameC),
            TextField(controller: alamatC),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal")),
          ElevatedButton(
            child: const Text("Simpan"),
            onPressed: () async {
              final token = await _getToken();
              await PelangganAdminService.update(
                token,
                c['id'],
                nameC.text,
                alamatC.text,
              );
              Navigator.pop(context);
              _loadCustomers();
            },
          ),
        ],
      ),
    );
  }

  // ================= DELETE =================

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Pelanggan"),
        content: const Text("Yakin ingin menghapus pelanggan ini?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red),
            child: const Text("Hapus",
                style: TextStyle(color: Colors.white)),
            onPressed: () async {
              Navigator.pop(context);
              final token = await _getToken();
              await PelangganAdminService.delete(token, id);
              _loadCustomers();
            },
          ),
        ],
      ),
    );
  }
}