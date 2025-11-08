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
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Icon(Icons.person, size: 40, color: Colors.black),
          ),

          _menuItem(context, Icons.home, 'Dashboard', const DashboardAdminScreen()),
          _menuItem(context, Icons.people, 'Kelola Pelanggan', const ManageCustomerScreen()),
          _menuItem(context, Icons.history, 'Riwayat Pembayaran', const PaymentHistoryScreen()),
          _menuItem(context, Icons.verified, 'Konfirmasi Tagihan', const PaymentConfirmationScreen()),
          _menuItem(context, Icons.bar_chart, 'Laporan Keuangan', const LaporanKeuanganScreen()),

          _menuItem(context, Icons.settings, 'Pengaturan', const SettingsScreen()),

          _logoutItem(context),
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget? targetScreen,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      onTap: () {
        Navigator.pop(context);
        if (targetScreen != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => targetScreen),
            (route) => false,
          );
        }
      },
    );
  }

  Widget _logoutItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.black),
      title: const Text('Keluar', style: TextStyle(color: Colors.black)),
      onTap: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) => LogoutConfirmationDialog(),
        );
      },
    );
  }
}
