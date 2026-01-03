import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../tabs/home_tab.dart';
import '../tabs/cek_tagihan_tab.dart';
import '../tabs/riwayat_tab.dart';
import '../tabs/profile_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _index = 0;

  String? token;

  Future<Map<String, dynamic>>? memberFuture;
  Future<List<dynamic>>? billsFuture;
  Future<List<dynamic>>? historyFuture;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchData();
  }

  Future<void> _loadTokenAndFetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');

    if (savedToken == null) {
      // token hilang → harus login ulang
      return;
    }

    setState(() {
      token = savedToken;
      memberFuture = ApiService.getMe(token!);
      billsFuture = ApiService.getTagihan(token!);
      historyFuture = ApiService.getRiwayat(token!);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (token == null ||
        memberFuture == null ||
        billsFuture == null ||
        historyFuture == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return FutureBuilder(
      future: Future.wait([
        memberFuture!,
        billsFuture!,
        historyFuture!,
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final member = snapshot.data![0] as Map<String, dynamic>;
        final bills = snapshot.data![1] as List<dynamic>;
        final history = snapshot.data![2] as List<dynamic>;

        final pages = [
          HomeTab(member: member, bills: bills),
          CekTagihanTab(bills: bills),
          RiwayatTab(history: history),
          ProfileTab(member: member),
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
              BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long), label: 'Tagihan'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: 'Riwayat'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profil'),
            ],
          ),
        );
      },
    );
  }
}