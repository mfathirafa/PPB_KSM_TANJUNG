import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/admin_sidebar.dart';
import '../services/api_service.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  String filterStatus = "Semua";
  String filterMethod = "Semua";
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
    final token = await _getToken();
    final res = await ApiService.getAdminPembayaran(token);

    setState(() {
      allPayments = res.map<Map<String, dynamic>>((p) {
        String statusUI;
        if (p['status'] == 'approved') {
          statusUI = "Terkonfirmasi";
        } else if (p['status'] == 'rejected') {
          statusUI = "Ditolak";
        } else {
          statusUI = "Menunggu Konfirmasi";
        }

        return {
          "id": "#${p['id']}",
          "raw_id": p['id'],
          "name": p['nama'],
          "phone": p['phone'],
          "amount": p['jumlah'].toString(),
          "date": p['created_at'],
          "method": p['metode'],
          "status": statusUI,
        };
      }).toList();

      loading = false;
    });
  }

  List<Map<String, dynamic>> get filteredPayments {
    return allPayments.where((p) {
      final matchStatus =
          filterStatus == "Semua" || p["status"] == filterStatus;
      final matchMethod =
          filterMethod == "Semua" || p["method"] == filterMethod;
      return matchStatus && matchMethod;
    }).toList();
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
                for (var p in filteredPayments)
                  _confirmationCard(
                    context,
                    p["name"],
                    p["phone"],
                    p["id"],
                    p["amount"],
                    p["date"],
                    p["method"],
                    p["status"],
                    p["raw_id"],
                  ),
              ],
            ),
    );
  }

  Widget _confirmationCard(
    BuildContext context,
    String name,
    String phone,
    String tagihanId,
    String amount,
    String date,
    String method,
    String status,
    int rawId,
  ) {
    Color tagColor;
    Color tagBg;

    if (status == "Menunggu Konfirmasi") {
      tagColor = Colors.orange.shade800;
      tagBg = Colors.orange.withOpacity(0.2);
    } else if (status == "Terkonfirmasi") {
      tagColor = Colors.green.shade800;
      tagBg = Colors.green.withOpacity(0.2);
    } else {
      tagColor = Colors.red.shade800;
      tagBg = Colors.red.withOpacity(0.2);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: status == "Menunggu Konfirmasi"
              ? Colors.blue.shade400
              : Colors.grey.shade300,
          width: status == "Menunggu Konfirmasi" ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration:
                    BoxDecoration(color: tagBg, borderRadius: BorderRadius.circular(4)),
                child: Text(status,
                    style: TextStyle(
                        color: tagColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Text(phone, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text("Tagihan $tagihanId",
              style: TextStyle(color: Colors.grey[600])),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Rp $amount",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(date,
                    style:
                        TextStyle(color: Colors.grey[600], fontSize: 12)),
              ]),
              Text(method,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          if (status == "Menunggu Konfirmasi") ...[
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final token = await _getToken();
                    await ApiService.approvePembayaran(token, rawId);
                    _loadPayments();
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Terima",
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final token = await _getToken();
                    await ApiService.rejectPembayaran(token, rawId);
                    _loadPayments();
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.red),
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