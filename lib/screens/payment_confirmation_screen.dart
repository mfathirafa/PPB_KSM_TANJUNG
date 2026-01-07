import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/admin_sidebar.dart';
import '../services/payment_admin_service.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  bool loading = true;
  List<Map<String, dynamic>> payments = [];

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> _loadPayments() async {
    try {
      final token = await _getToken();
      final res = await PaymentAdminService.list(token);

      setState(() {
        payments = res.map<Map<String, dynamic>>((p) {
          final status = p['status'];

          return {
            'id': p['id'],
            'nama': p['nama'] ?? '-',
            'tanggal': p['tanggal'] ?? '-',
            'jumlah': p['jumlah']?.toString() ?? '0',
            'metode': p['metode'] ?? '-',
            'status': status,
            'status_label': _statusLabel(status),
            'status_color': _statusColor(status),
          };
        }).toList();

        loading = false;
      });
    } catch (e) {
      loading = false;
      setState(() {});
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Menunggu Konfirmasi';
      case 'confirmed':
        return 'Terkonfirmasi';
      case 'rejected':
        return 'Ditolak';
      default:
        return '-';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminSidebar(),
      appBar: AppBar(
        title: const Text('Konfirmasi Pembayaran'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: payments.length,
              itemBuilder: (_, i) => _paymentCard(payments[i]),
            ),
    );
  }

  Widget _paymentCard(Map<String, dynamic> p) {
    final bool canProcess = p['status'] == 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: canProcess ? Colors.orange : Colors.grey.shade300,
          width: canProcess ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                p['nama'],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: p['status_color'].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  p['status_label'],
                  style: TextStyle(
                    color: p['status_color'],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('Tanggal: ${p['tanggal']}',
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Text('Metode: ${p['metode']}'),
          const SizedBox(height: 6),
          Text(
            'Rp ${p['jumlah']}',
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          if (canProcess) ...[
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green),
                  onPressed: () async {
                    final token = await _getToken();
                    await PaymentAdminService.approve(token, p['id']);
                    _loadPayments();
                  },
                  child: const Text('Terima',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    final token = await _getToken();
                    await PaymentAdminService.reject(token, p['id']);
                    _loadPayments();
                  },
                  child: const Text('Tolak',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }
}