import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/tagihan_service.dart';
import '../services/pembayaran_service.dart';

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
  List<Map<String, dynamic>> bills = [];
  List<Map<String, dynamic>> history = [];

  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedToken = prefs.getString('token');
      final rawUser = prefs.getString('user');

      if (savedToken == null || rawUser == null) {
        throw Exception('Data login tidak ditemukan');
      }

      token = savedToken;
      member = Map<String, dynamic>.from(jsonDecode(rawUser));

      final tagihan = await TagihanService.list(token);
      final riwayat = await PembayaranService.riwayat(token);

      setState(() {
        bills = List<Map<String, dynamic>>.from(tagihan);
        history = List<Map<String, dynamic>>.from(riwayat);
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

    if (member == null) {
      return const Scaffold(
        body: Center(child: Text('Data pengguna tidak ditemukan')),
      );
    }

    final pages = [
      HomeTab(member: member!, bills: bills),
      CekTagihanTab(bills: bills, token: token),
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