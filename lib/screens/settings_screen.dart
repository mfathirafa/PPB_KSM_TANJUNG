import 'package:flutter/material.dart';
import '../widgets/admin_sidebar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool waNotif = true;
  bool enforceHttps = true;
  bool midtransEnabled = true;

  TextEditingController timeoutCtrl = TextEditingController(text: "30");
  TextEditingController midtransKeyCtrl =
      TextEditingController(text: "085710887804");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminSidebar(),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),

        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),

        title: const Text(
          "Pengaturan",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Notification Setting",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("WhatsApp Notification", style: TextStyle(fontSize: 14)),
                Switch(
                  value: waNotif,
                  onChanged: (v) => setState(() => waNotif = v),
                )
              ],
            ),
            const SizedBox(height: 10),

            const Text("Notification Timeout", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: timeoutCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Text("sec", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            const SizedBox(height: 4),
            const Text(
              "Time before notification expires",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),

            const SizedBox(height: 25),


            const Text(
              "Security Setting",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Regenerate JWT Secret", style: TextStyle(fontSize: 14)),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("JWT Secret regenerated (dummy)"),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Enable HTTPS Enforcement",
                    style: TextStyle(fontSize: 14)),
                Switch(
                  value: enforceHttps,
                  onChanged: (v) => setState(() => enforceHttps = v),
                ),
              ],
            ),

            const SizedBox(height: 25),

                      const Text(
              "API Integrations",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Midtrans", style: TextStyle(fontSize: 14)),
                    Text("Payment gateway",
                        style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                Switch(
                  value: midtransEnabled,
                  onChanged: (v) => setState(() => midtransEnabled = v),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: midtransKeyCtrl,
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Edit Midtrans Key"),
                          content: TextField(
                            controller: midtransKeyCtrl,
                            decoration: const InputDecoration(
                              hintText: "Masukkan API Key",
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text("Simpan"),
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {});
                              },
                            )
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
