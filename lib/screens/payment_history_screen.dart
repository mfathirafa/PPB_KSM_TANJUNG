import 'package:flutter/material.dart';
import '../widgets/admin_sidebar.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  String filterStatus = "Semua";

  final List<Map<String, dynamic>> allBills = [
    {
      "id": "00123",
      "name": "Siti Aminah",
      "phone": "+62 897-9876-9876",
      "amount": "7.500",
      "due": "30 April 2025",
      "status": "Belum Dibayar",
      "color": Colors.orange
    },
    {
      "id": "00124",
      "name": "Siti Aminah",
      "phone": "+62 897-9876-9876",
      "amount": "7.500",
      "due": "30 April 2025",
      "status": "Sudah Dibayar",
      "color": Colors.green
    },
    {
      "id": "00125",
      "name": "Siti Aminah",
      "phone": "+62 897-9876-9876",
      "amount": "7.500",
      "due": "30 April 2025",
      "status": "Belum Dibayar",
      "color": Colors.orange
    },
  ];

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
        onApply: (value) {
          setState(() => filterStatus = value);
        },
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

      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (var bill in filteredBills)
                _paymentHistoryCard(
                  context,
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

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: FloatingActionButton.extended(
                onPressed: () => _showNewBillPopup(context),
                label: const Text("Tagihan Baru"),
                icon: const Icon(Icons.add),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* ------------------------- POPUP TAGIHAN BARU ------------------------- */
  void _showNewBillPopup(BuildContext context) {
    String? selectedCustomer;
    String? selectedStatus = "Belum Dibayar";
    final TextEditingController totalController =
        TextEditingController(text: "Rp 5.000");
    final TextEditingController dueDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tagihan Baru",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: selectedCustomer,
                        items: const [
                          DropdownMenuItem(
                              value: "Siti Aminah", child: Text("Siti Aminah")),
                          DropdownMenuItem(
                              value: "Budi Santoso", child: Text("Budi Santoso")),
                        ],
                        onChanged: (v) => setState(() => selectedCustomer = v),
                        decoration: InputDecoration(
                          hintText: "Nama Pelanggan",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                          Text(totalController.text,
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: dueDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "dd/mm/yy",
                          labelText: "Tanggal jatuh tempo",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          suffixIcon:
                              const Icon(Icons.calendar_today, size: 18),
                        ),
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2030),
                          );
                          if (selectedDate != null) {
                            dueDateController.text =
                                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: selectedStatus,
                        items: const [
                          DropdownMenuItem(
                              value: "Belum Dibayar",
                              child: Text("Belum Dibayar")),
                          DropdownMenuItem(
                              value: "Sudah Dibayar",
                              child: Text("Sudah Dibayar")),
                        ],
                        onChanged: (v) => setState(() => selectedStatus = v),
                        decoration: InputDecoration(
                          labelText: "Status",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Simpan",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /* ------------------------- CARD TAGIHAN ------------------------- */
  Widget _paymentHistoryCard(
    BuildContext context,
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

/* ------------------------- SIDEBAR FILTER ------------------------- */
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

  final TextEditingController dateFrom = TextEditingController();
  final TextEditingController dateTo = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Filter",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text("Status"),
              const SizedBox(height: 8),

              DropdownButtonFormField(
                value: selectedStatus,
                decoration: InputDecoration(
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: "Semua", child: Text("Status Pembayaran")),
                  DropdownMenuItem(value: "Sudah Dibayar", child: Text("Sudah Dibayar")),
                  DropdownMenuItem(value: "Belum Dibayar", child: Text("Belum Dibayar")),
                ],
                onChanged: (v) => setState(() => selectedStatus = v!),
              ),

              const SizedBox(height: 20),

              const Text("Periode"),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dateFrom,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "dd/mm/yy",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        suffixIcon: const Icon(Icons.calendar_today, size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: dateTo,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "dd/mm/yy",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        suffixIcon: const Icon(Icons.calendar_today, size: 18),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text("Cari Pelanggan"),
              const SizedBox(height: 8),

              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Cari nama atau No. WA",
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const Spacer(),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child:
                          const Text("Cancel", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApply(selectedStatus);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child:
                          const Text("Simpan", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
