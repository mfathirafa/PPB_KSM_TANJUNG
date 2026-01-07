import 'package:flutter/material.dart';

import '../screens/dashboard_admin_screen.dart';
import '../screens/manage_customer_screen.dart';
import '../screens/payment_history_screen.dart';
import '../screens/payment_confirmation_screen.dart';
import '../screens/laporan_keuangan_screen.dart';
import '../screens/settings_screen.dart';

import 'dialogs.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _header(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _menuItem(
                  context,
                  icon: Icons.home,
                  title: 'Dashboard',
                  screen: const DashboardAdminScreen(),
                ),
                _menuItem(
                  context,
                  icon: Icons.people,
                  title: 'Kelola Pelanggan',
                  screen: const ManageCustomerScreen(),
                ),
                _menuItem(
                  context,
                  icon: Icons.history,
                  title: 'Riwayat Pembayaran',
                  screen: const PaymentHistoryScreen(),
                ),
                _menuItem(
                  context,
                  icon: Icons.verified,
                  title: 'Konfirmasi Pembayaran',
                  screen: PaymentConfirmationScreen(), // ❗ TANPA const
                ),
                _menuItem(
                  context,
                  icon: Icons.bar_chart,
                  title: 'Laporan Keuangan',
                  screen: const LaporanKeuanganScreen(),
                ),
                const Divider(),
                _menuItem(
                  context,
                  icon: Icons.settings,
                  title: 'Pengaturan',
                  screen: const SettingsScreen(),
                ),
                const Divider(),
                _logoutItem(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      alignment: Alignment.centerLeft,
      child: Row(
        children: const [
          CircleAvatar(
            radius: 22,
            child: Icon(Icons.admin_panel_settings),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin KSM',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'KSM Tanjung',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= MENU ITEM =================
  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget screen,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
    );
  }

  // ================= LOGOUT =================
  Widget _logoutItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Keluar'),
      onTap: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => LogoutConfirmationDialog(),
        );
      },
    );
  }
}