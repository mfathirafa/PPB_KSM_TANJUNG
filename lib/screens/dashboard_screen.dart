import 'package:flutter/material.dart';

import '../services/tagihan_service.dart';
import '../services/pembayaran_service.dart';
import '../services/notifikasi_service.dart';
import '../services/user_service.dart';

import '../tabs/home_tab.dart';
import '../tabs/cek_tagihan_tab.dart';
import '../tabs/riwayat_tab.dart';
import '../tabs/profile_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _index = 0;
  String token = '';

  Map<String, dynamic>? member;
  Map<String, dynamic>? tagihanAktif;
  Map<String, dynamic>? summary;

  List<Map<String, dynamic>> bills = [];
  List<Map<String, dynamic>> history = [];
  List<Map<String, dynamic>> notifikasi = [];

  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      token = await UserService.getToken(); // pastikan method ini ada

      final user = await UserService.me(token);
      final tagihanData = await TagihanService.list(token);
      final riwayat = await PembayaranService.riwayat(token);
      final notif = await NotifikasiService.list(token);

      final tagihanList =
          List<Map<String, dynamic>>.from(tagihanData['tagihan']);

      Map<String, dynamic>? aktif;
      for (final t in tagihanList) {
        if (t['status'] == 'belum_dibayar' ||
            t['status'] == 'menunggu_verifikasi') {
          aktif = t;
          break;
        }
      }

      setState(() {
        member = user;
        bills = tagihanList;
        summary = tagihanData['summary'];
        history = List<Map<String, dynamic>>.from(riwayat);
        notifikasi = List<Map<String, dynamic>>.from(notif);
        tagihanAktif = aktif;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Text(error!, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    final unreadCount =
        notifikasi.where((n) => n['dibaca'] == null).length;

    final pages = [
      HomeTab(
        member: member!,
        tagihanAktif: tagihanAktif,
        notifikasi: notifikasi,
        unreadCount: unreadCount,
        onRefresh: _loadDashboard,
      ),
      CekTagihanTab(
        bills: bills,
        token: token,
      ),
      RiwayatTab(history: history),
      ProfileTab(member: member!),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('KSM Tanjung'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Tagihan'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}