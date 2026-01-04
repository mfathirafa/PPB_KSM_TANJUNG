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

  List<Map<String, dynamic>> allPayments = [];

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
        allPayments = res.map<Map<String, dynamic>>((p) {
          final rawStatus = p['status'];

          String statusLabel;
          Color statusColor;

          if (rawStatus == 'pending') {
            statusLabel = 'Menunggu Konfirmasi';
            statusColor = Colors.orange;
          } else if (rawStatus == 'confirmed') {
            statusLabel = 'Terkonfirmasi';
            statusColor = Colors.green;
          } else {
            statusLabel = 'Ditolak';
            statusColor = Colors.red;
          }

          return {
            "id": p['id'],
            "user_name": p['user']?['name'] ?? '-',
            "user_phone": p['user']?['phone'] ?? '-',
            "amount": p['jumlah_bayar'].toString(),
            "date": p['created_at'],
            "method": p['metode'],
            "status_raw": rawStatus,
            "status_label": statusLabel,
            "status_color": statusColor,
          };
        }).toList();

        loading = false;
      });
    } catch (_) {
      setState(() => loading = false);
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
        title: const Text("Konfirmasi Pembayaran"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (var p in allPayments)
                  _paymentCard(context, p),
              ],
            ),
    );
  }

  Widget _paymentCard(BuildContext context, Map<String, dynamic> p) {
    final bool canProcess = p['status_raw'] == 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
                p['user_name'],
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
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
          Text(p['user_phone'],
              style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text("Pembayaran #${p['id']}",
              style: TextStyle(color: Colors.grey[600])),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rp ${p['amount']}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(p['date'],
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 12)),
                  ]),
              Text(p['method'],
                  style:
                      const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),

          if (canProcess) ...[
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final token = await _getToken();
                    await PaymentAdminService.approve(token, p['id']);
                    _loadPayments();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green),
                  child: const Text("Terima",
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final token = await _getToken();
                    await PaymentAdminService.reject(token, p['id']);
                    _loadPayments();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red),
                  child: const Text("Tolak",
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