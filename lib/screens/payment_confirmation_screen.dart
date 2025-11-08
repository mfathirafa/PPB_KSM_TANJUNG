import 'package:flutter/material.dart';
import '../widgets/admin_sidebar.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  String filterStatus = "Semua";
  String filterMethod = "Semua";

  final List<Map<String, dynamic>> allPayments = [
    {
      "name": "Agus Darmawan",
      "phone": "+62 812-3456-7890",
      "id": "#67878",
      "amount": "5.000",
      "date": "26 April 2025, 09.18",
      "method": "QRIS",
      "status": "Menunggu Konfirmasi"
    },
    {
      "name": "Mbah Kakung",
      "phone": "+62 812-3456-0987",
      "id": "#97078",
      "amount": "5.000",
      "date": "23 April 2025, 08.10",
      "method": "Transfer Bank",
      "status": "Terkonfirmasi"
    },
    {
      "name": "Asep Racing",
      "phone": "+62 812-6543-0867",
      "id": "#07076",
      "amount": "5.000",
      "date": "1 Juni 2025, 06.10",
      "method": "QRIS",
      "status": "Ditolak"
    }
  ];

  List<Map<String, dynamic>> get filteredPayments {
    return allPayments.where((p) {
      final matchStatus =
          (filterStatus == "Semua" || p["status"] == filterStatus);
      final matchMethod =
          (filterMethod == "Semua" || p["method"] == filterMethod);

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

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Filter Pembayaran",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),

          _filterDropdown(
            "Status",
            filterStatus,
            ["Semua", "Terkonfirmasi", "Menunggu Konfirmasi", "Ditolak"],
            (v) => setState(() => filterStatus = v!),
          ),

          const SizedBox(height: 10),

          _filterDropdown(
            "Metode Pembayaran",
            filterMethod,
            ["Semua", "QRIS", "Transfer Bank"],
            (v) => setState(() => filterMethod = v!),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(child: _dateInput("Dari Tanggal")),
              const SizedBox(width: 8),
              Expanded(child: _dateInput("Sampai Tanggal")),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    filterStatus = "Semua";
                    filterMethod = "Semua";
                  });
                },
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child:
                    const Text("Simpan", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),

          const Divider(height: 30),

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
            ),
        ],
      ),
    );
  }

  // ------------------------ WIDGETS ------------------------

  Widget _filterDropdown(String label, String value,
      List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: options
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateInput(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        const TextField(
          decoration: InputDecoration(
            hintText: "dd/mm/yy",
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          ),
        ),
      ],
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
                decoration: BoxDecoration(
                    color: tagBg, borderRadius: BorderRadius.circular(4)),
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

          Text("Tagihan $tagihanId", style: TextStyle(color: Colors.grey[600])),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rp $amount",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(date,
                      style:
                          TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Terima",
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
