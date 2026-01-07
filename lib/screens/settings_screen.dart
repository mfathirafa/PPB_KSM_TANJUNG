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
  bool saving = false;

  // =========================
  // LOAD SETTINGS
  // =========================
  Future<void> _load() async {
    try {
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
    } catch (_) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memuat pengaturan")),
      );
    }
  }

  // =========================
  // SAVE SETTINGS (MANUAL)
  // =========================
  Future<void> _save() async {
    try {
      setState(() => saving = true);

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
        const SnackBar(content: Text("Pengaturan berhasil disimpan")),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyimpan pengaturan")),
      );
    } finally {
      setState(() => saving = false);
    }
  }

  // =========================
  // REGENERATE JWT
  // =========================
  Future<void> _regenJwt() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      await SettingsService.regenerateJwt(token);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("JWT berhasil diregenerate")),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal regenerate JWT")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    timeoutCtrl.dispose();
    midtransKeyCtrl.dispose();
    super.dispose();
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
        title: const Text("Pengaturan"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= NOTIFICATION =================
            const Text(
              "Notification Setting",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            SwitchListTile(
              title: const Text("WhatsApp Notification"),
              value: waNotif,
              onChanged: (v) => setState(() => waNotif = v),
            ),

            const SizedBox(height: 10),
            const Text("Notification Timeout (detik)"),
            const SizedBox(height: 6),

            TextField(
              controller: timeoutCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            // ================= SECURITY =================
            const Text(
              "Security Setting",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            SwitchListTile(
              title: const Text("Enforce HTTPS"),
              value: enforceHttps,
              onChanged: (v) => setState(() => enforceHttps = v),
            ),

            ListTile(
              title: const Text("Regenerate JWT Secret"),
              trailing: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _regenJwt,
              ),
            ),

            const SizedBox(height: 25),

            // ================= API =================
            const Text(
              "API Integrations",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            SwitchListTile(
              title: const Text("Midtrans Enabled"),
              value: midtransEnabled,
              onChanged: (v) => setState(() => midtransEnabled = v),
            ),

            TextField(
              controller: midtransKeyCtrl,
              readOnly: true,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Midtrans API Key",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // ================= SAVE BUTTON =================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: saving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(saving ? "Menyimpan..." : "Simpan Perubahan"),
                onPressed: saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}