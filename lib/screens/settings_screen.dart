import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/admin_sidebar.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool waNotif = true;
  bool enforceHttps = true;
  bool midtransEnabled = true;

  final TextEditingController timeoutCtrl =
      TextEditingController(text: "30");
  final TextEditingController midtransKeyCtrl =
      TextEditingController(text: "");

  bool loading = true;

  // =========================
  // LOAD SETTINGS (BACKEND)
  // =========================
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final data = await SettingsService.getSettings(token);

    setState(() {
      waNotif = data['wa_notification'] ?? true;
      enforceHttps = data['enforce_https'] ?? true;
      midtransEnabled = data['midtrans_enabled'] ?? true;

      timeoutCtrl.text =
          (data['notification_timeout'] ?? 30).toString();
      midtransKeyCtrl.text =
          data['midtrans_key']?.toString() ?? '';

      loading = false;
    });
  }

  // =========================
  // SAVE SETTINGS
  // =========================
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    await SettingsService.updateSettings(
      token,
      waNotif: waNotif,
      timeout: int.tryParse(timeoutCtrl.text) ?? 30,
      enforceHttps: enforceHttps,
      midtransEnabled: midtransEnabled,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pengaturan disimpan")),
    );
  }

  // =========================
  // REGENERATE JWT
  // =========================
  Future<void> _regenJwt() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    await SettingsService.regenerateJwt(token);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("JWT Secret regenerated")),
    );
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                const Text("WhatsApp Notification",
                    style: TextStyle(fontSize: 14)),
                Switch(
                  value: waNotif,
                  onChanged: (v) {
                    setState(() => waNotif = v);
                    _save();
                  },
                )
              ],
            ),

            const SizedBox(height: 10),
            const Text("Notification Timeout",
                style: TextStyle(fontSize: 14)),
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
                      onSubmitted: (_) => _save(),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Text("sec",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Security Setting",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Regenerate JWT Secret",
                      style: TextStyle(fontSize: 14)),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _regenJwt,
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
                  onChanged: (v) {
                    setState(() => enforceHttps = v);
                    _save();
                  },
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
                  onChanged: (v) {
                    setState(() => midtransEnabled = v);
                    _save();
                  },
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