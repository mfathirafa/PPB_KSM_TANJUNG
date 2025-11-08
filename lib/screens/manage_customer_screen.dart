import 'package:flutter/material.dart';
import '../widgets/admin_sidebar.dart';

class ManageCustomerScreen extends StatefulWidget {
  const ManageCustomerScreen({super.key});

  @override
  State<ManageCustomerScreen> createState() => _ManageCustomerScreenState();
}

class _ManageCustomerScreenState extends State<ManageCustomerScreen> {
  String filterStatus = "Aktif";
  String searchQuery = "";

  List<Map<String, dynamic>> allCustomers = [
    {
      "name": "Budi Santoso",
      "phone": "+62 812-4890-9888",
      "isActive": true,
      "lastPay": "20 April 2025"
    },
    {
      "name": "Fathi Setiawan",
      "phone": "+62 123-4567-890",
      "isActive": false,
      "lastPay": "15 April 2025"
    },
  ];

  // ✅ FILTER + SEARCH
  List<Map<String, dynamic>> getFilteredCustomers() {
    List<Map<String, dynamic>> data = allCustomers;

    // FILTER STATUS
    if (filterStatus == "Aktif") {
      data = data.where((c) => c["isActive"] == true).toList();
    } else if (filterStatus == "Tidak Aktif") {
      data = data.where((c) => c["isActive"] == false).toList();
    }

    // FILTER SEARCH
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
          const SizedBox(width: 10),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => searchQuery = v),
                    decoration: const InputDecoration(
                      hintText: "Cari nama atau WA",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: filterStatus,
                      items: ["Aktif", "Tidak Aktif", "Semua"]
                          .map((v) => DropdownMenuItem(
                                value: v,
                                child: Text(v),
                              ))
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          filterStatus = v!;
                        });
                      },
                    ),
                  ),
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
                  c["name"],
                  c["phone"],
                  c["isActive"],
                  "Pembayaran Terakhir:",
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
    String name,
    String phone,
    bool isActive,
    String lastPaymentLabel,
    String lastPaymentDate,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style:
                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(phone, style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isActive ? "Aktif" : "Tidak Aktif",
                        style: TextStyle(
                          color: isActive
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lastPaymentLabel,
                            style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                        Text(lastPaymentDate,
                            style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          Column(
            children: [
              const Icon(Icons.edit, size: 20, color: Colors.grey),
              const SizedBox(height: 10),

              GestureDetector(
                onTap: () => _showDeletePopup(context, name),
                child: Icon(Icons.delete, size: 20, color: Colors.red.shade400),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showDeletePopup(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete, color: Colors.red, size: 32),
                ),

                const SizedBox(height: 16),
                const Text("Hapus Pelanggan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(
                  "Apa anda yakin ingin menghapus pelanggan ini?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            allCustomers.removeWhere((c) => c["name"] == name);
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Hapus"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddCustomerPopup(BuildContext context) {
    TextEditingController nameC = TextEditingController();
    TextEditingController phoneC = TextEditingController();
    TextEditingController amountC = TextEditingController(text: "0");

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tambah Pelanggan",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    )
                  ],
                ),

                const SizedBox(height: 20),

                const Text("Nama Pelanggan"),
                const SizedBox(height: 6),
                TextField(
                  controller: nameC,
                  decoration: InputDecoration(
                    hintText: "Masukkan Nama Pelanggan",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),

                const SizedBox(height: 16),

                const Text("Nomor WhatsApp"),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text("+62"),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: phoneC,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "812-3456-7890",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                const Text("Jumlah Tagihan"),
                const SizedBox(height: 6),
                TextField(
                  controller: amountC,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: "Rp ",
                    border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            allCustomers.add({
                              "name": nameC.text,
                              "phone": "+62 ${phoneC.text}",
                              "isActive": true,
                              "lastPay": "-",
                            });
                          });

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Simpan"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
