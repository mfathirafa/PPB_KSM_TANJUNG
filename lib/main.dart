// lib/main.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

/* --------------------------- MyApp --------------------------- */
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const whatsappGreen = Color(0xFF25D366);

    return MaterialApp(
      title: 'KSM Tanjung Demo',
      theme: ThemeData(
        primaryColor: whatsappGreen,
        colorScheme: ColorScheme.fromSeed(
          seedColor: whatsappGreen,
          primary: whatsappGreen,
          secondary: whatsappGreen,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: whatsappGreen,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: whatsappGreen,
            side: const BorderSide(color: whatsappGreen),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: whatsappGreen,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: WelcomeScreen(),
    );
  }
}

/* --------------------------- Welcome --------------------------- */
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 360,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 62,
                width: 62,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text('KSM')),
              ),
              SizedBox(height: 12),
              Text(
                'Ohayou\nWelcome to\nKSM Tanjung App',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 18),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => WhatsAppLogin()),
                ),
                child: Text('Continue With WhatsApp'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(48),
                ),
              ),
              SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterScreen()),
                ),
                child: Text('Not yet a member?'),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* --------------------------- Register --------------------------- */
class RegisterScreen extends StatelessWidget {
  final _fn = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _pwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Started'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      // [OK] Sudah menggunakan SingleChildScrollView
      body: SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            Text(
              'Silakan isi data diri Anda.',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _fn,
              decoration: InputDecoration(hintText: 'Nama Lengkap'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _email,
              decoration: InputDecoration(hintText: 'Email valid'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _phone,
              decoration: InputDecoration(hintText: 'Nomor Telepon'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _pwd,
              decoration: InputDecoration(hintText: 'Password yang kuat'),
              obscureText: true,
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_fn.text.isEmpty) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Isi nama')));
                    return;
                  }
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Dummy registered')));
                  Navigator.pop(context);
                },
                child: Text('Next ►'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* --------------------------- WhatsApp Login --------------------------- */
class WhatsAppLogin extends StatefulWidget {
  @override
  _WhatsAppLoginState createState() => _WhatsAppLoginState();
}

class _WhatsAppLoginState extends State<WhatsAppLogin> {
  final _country = TextEditingController(text: '+62');
  final _phone = TextEditingController();

  void _sendOtp() {
    if (_phone.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Isi nomor')));
      return;
    }
    final otp = (Random().nextInt(900000) + 100000).toString();
    // show dialog with OTP (dummy)
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Dummy OTP'),
        content: Text('Kode verifikasi: $otp\n(Ini cuma simulasi)'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // go to verification screen, pass otp and phone
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VerificationScreen(
                    phone: '${_country.text} ${_phone.text}',
                    otp: otp,
                  ),
                ),
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login dengan WhatsApp'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      // [OK] Sudah menggunakan SingleChildScrollView
      body: SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            Text(
              'Masuk Menggunakan Nomor WhatsApp Anda',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                SizedBox(width: 90, child: TextField(controller: _country)),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _phone,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Nomor WhatsApp Anda',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendOtp,
                child: Text('Kirim Kode Verifikasi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* --------------------------- Verification (OTP) --------------------------- */
class VerificationScreen extends StatefulWidget {
  final String phone;
  final String otp;
  VerificationScreen({required this.phone, required this.otp});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // **Lokasi ini sudah benar untuk inisialisasi.**
  final controllers = List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var c in controllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
  }

  void _verify() {
    final code = controllers.map((c) => c.text).join();
    if (code == widget.otp) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Verified! (dummy)')));
      // Navigate to Dashboard and remove all previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Kode salah')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification Code'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      // PERBAIKAN UTAMA untuk mengatasi overflow keyboard: Pastikan ini ada.**
      body: SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            SizedBox(height: 8),
            Text(
              'Please enter the 6-digit code sent to ${widget.phone}',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) {
                return Container(
                  width: 44,
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  child: TextField(
                    controller: controllers[i],
                    focusNode: focusNodes[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: InputDecoration(counterText: ''),
                    onChanged: (value) {
                      if (value.isNotEmpty && i < 5)
                        focusNodes[i + 1].requestFocus();
                      if (value.isEmpty && i > 0)
                        focusNodes[i - 1].requestFocus();
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _verify, child: Text('Verify')),
            ),
            TextButton(
              onPressed: () {
                final newOtp = (Random().nextInt(900000) + 100000).toString();
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text('Resent (dummy) OTP: $newOtp'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Resend'),
            ),
          ],
        ),
      ),
    );
  }
}

/* --------------------------- Dashboard (Bottom Navigation) --------------------------- */
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _index = 0;

  // Dummy data
  final Map<String, dynamic> member = {
    'name': 'Fathi Setiawan',
    'id': 'KSM-00123',
    'address': 'Jl. Tanjung No.12',
  };

  final List<Map<String, dynamic>> bills = [
    {
      'id': 'TAG202504',
      'title': 'Tagihan saat ini',
      'amount': 15000,
      'due': '30 April 2025',
      'status': 'Belum Dibayar',
    },
    {
      'id': 'TAG202503',
      'title': 'Tagihan Maret 2025',
      'amount': 12000,
      'due': '31 Maret 2025',
      'status': 'Lunas',
    },
  ];

  final List<Map<String, dynamic>> history = [
    {
      'id': '#TRX001',
      'title': 'Pembayaran Tagihan #TAG202503',
      'amount': 12000,
      'method': 'QRIS',
      'date': '25 Apr 2025',
    },
    {
      'id': '#TRX002',
      'title': 'Pembayaran Tagihan #TAG202502',
      'amount': 11000,
      'method': 'Transfer Bank',
      'date': '01 Mar 2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeTab(member: member, bills: bills),
      CekTagihanTab(bills: bills),
      RiwayatTab(history: history),
      ProfileTab(member: member),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('KSM Tanjung'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Tagihan',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

/* --------------------------- Home Tab --------------------------- */
class HomeTab extends StatelessWidget {
  final Map<String, dynamic> member;
  final List<Map<String, dynamic>> bills;
  const HomeTab({required this.member, required this.bills});

  @override
  Widget build(BuildContext context) {
    final nextBill = bills.firstWhere(
      (b) => b['status'] != 'Lunas',
      orElse: () => {},
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(radius: 28, child: Text(member['name'][0])),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          member['address'],
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'ID: ${member['id']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Informasi Tagihan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          if (nextBill.isNotEmpty)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nextBill['title'],
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jatuh Tempo',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              nextBill['due'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Rp ${nextBill['amount']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                // navigate to pembayaran screen with bill data
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PembayaranScreen(bill: nextBill),
                                  ),
                                );
                              },
                              child: Text('Bayar Sekarang'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else
            Text(
              'Tidak ada tagihan aktif',
              style: TextStyle(color: Colors.grey),
            ),
          SizedBox(height: 18),
          Text('Navigasi Cepat', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CekTagihanTab(bills: bills),
                  ),
                ),
                icon: Icon(Icons.receipt_long),
                label: Text('Cek Tagihan'),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RiwayatTab(
                      history: [
                        {
                          'id': '#TRX001',
                          'title': 'Pembayaran',
                          'amount': 12000,
                          'method': 'QRIS',
                          'date': '25 Apr 2025',
                        },
                      ],
                    ),
                  ),
                ),
                icon: Icon(Icons.history),
                label: Text('Riwayat'),
              ),
            ],
          ),
          SizedBox(height: 18),
          Text('Notifikasi', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Tagihan bulan April 2025 belum dibayar. Harap melakukan pembayaran sebelum 30 April 2025.',
              ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

/* --------------------------- Cek Tagihan Tab (Perbaikan Overflow) --------------------------- */
class CekTagihanTab extends StatelessWidget {
  final List<Map<String, dynamic>> bills;
  const CekTagihanTab({required this.bills});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: bills.length,
      itemBuilder: (_, i) {
        final b = bills[i];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            // Mengurangi padding vertikal agar konten lebih rapat
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(b['title']),
            subtitle: Text('Jatuh Tempo: ${b['due']}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              // Memastikan Column mengambil tinggi seminimal mungkin
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rp ${b['amount']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                // Menetapkan tinggi tetap dan ukuran teks kecil untuk tombol
                SizedBox(
                  height: 32, // Tinggi yang lebih ringkas
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                      ), // Padding horizontal lebih kecil
                    ),
                    onPressed: b['status'] == 'Lunas'
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PembayaranScreen(bill: b),
                              ),
                            );
                          },
                    child: Text(
                      b['status'] == 'Lunas' ? 'Lunas' : 'Bayar Sekarang',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/* --------------------------- Pembayaran Screen --------------------------- */
class PembayaranScreen extends StatefulWidget {
  final Map<String, dynamic> bill;
  PembayaranScreen({required this.bill});

  @override
  _PembayaranScreenState createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  String _method = 'QRIS';

  @override
  Widget build(BuildContext context) {
    final b = widget.bill;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran Tagihan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(b['title'], style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                'Jumlah: Rp ${b['amount']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'Jatuh Tempo: ${b['due']}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                'Pilih metode pembayaran',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              RadioListTile<String>(
                value: 'QRIS',
                groupValue: _method,
                title: Text('QRIS (E-Wallet)'),
                onChanged: (v) => setState(() => _method = v ?? 'QRIS'),
              ),
              RadioListTile<String>(
                value: 'Transfer Bank',
                groupValue: _method,
                title: Text('Transfer Bank'),
                onChanged: (v) =>
                    setState(() => _method = v ?? 'Transfer Bank'),
              ),
              SizedBox(height: 20),
              Text(
                'Jumlah Dibayarkan: Rp ${b['amount']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_method == 'QRIS') {
                      _showQrisConfirmationDialog(context, b);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PembayaranBerhasilPage(bill: b, method: _method),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Bayar Sekarang',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ⬇️ Tambahan: Fungsi Popup QRIS
  void _showQrisConfirmationDialog(
    BuildContext context,
    Map<String, dynamic> bill,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Konfirmasi Transaksi',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cek kembali rincian transaksi',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              _infoRow('Nama Pelanggan', 'Fathi Setiawan'),
              _infoRow('Nomor Tagihan', '#${bill['id']}'),
              _infoRow('Bulan', bill['title'].toString().split(' ').last),
              _infoRow('Jumlah', 'Rp ${bill['amount']}'),
              _infoRow('Metode Pembayaran', 'QRIS'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Tutup popup
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            QrisPaymentPage(bill: bill), // ⬅️ ke halaman QRIS
                      ),
                    );
                  },
                  child: const Text(
                    'Bayar dengan Qris',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/* --------------------------- Halaman Pembayaran QRIS --------------------------- */
class QrisPaymentPage extends StatefulWidget {
  final Map<String, dynamic> bill;

  const QrisPaymentPage({required this.bill});

  @override
  _QrisPaymentPageState createState() => _QrisPaymentPageState();
}

class _QrisPaymentPageState extends State<QrisPaymentPage> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = 10 * 60; // 10 menit countdown
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return; // <- penting! biar gak error kalau halaman ditutup

      if (_remainingSeconds <= 0) {
        timer.cancel();
        setState(() {
          _remainingSeconds = 0;
        });
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.bill;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran Tagihan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Selesaikan Pembayaran QRIS\nSebelum Waktu Habis',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),

            // 🔵 Timer Bulat
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  '$_formattedTime\nMenit',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Jumlah tagihan',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Rp ${b['amount']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🟩 QR Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Ganti ini pakai qr_flutter kalau mau QR dinamis
                  Image.asset(
                    'assets/QRsample.jpg',
                    height: 160,
                    width: 160,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  const Text('Powered by QRIS'),
                  const SizedBox(height: 4),
                  Text(
                    'Nomor Tagihan: #${b['id']}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Unduh QRIS'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('QRIS diunduh (dummy)')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.share),
                label: const Text('Bagikan QRIS'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bagikan QRIS (dummy)')),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

/* --------------------------- Riwayat Tab --------------------------- */
class RiwayatTab extends StatefulWidget {
  final List<Map<String, dynamic>> history;
  const RiwayatTab({required this.history, super.key});

  @override
  _RiwayatTabState createState() => _RiwayatTabState();
}

class _RiwayatTabState extends State<RiwayatTab> {
  String selectedStatus = 'Semua';
  String selectedTanggal = 'Terbaru';

  @override
  Widget build(BuildContext context) {
    // Filter history (opsional, bisa dikembangkan)
    List<Map<String, dynamic>> filtered = widget.history;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Dropdown Filters
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value:
                      [
                        'Semua',
                        'Terkonfirmasi',
                        'Menunggu Pembayaran',
                      ].contains(selectedStatus)
                      ? selectedStatus
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle: TextStyle(color: Colors.green.shade700),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade700),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green.shade700,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  iconEnabledColor: Colors.green.shade700,
                  dropdownColor: Colors.green.shade50,
                  items: ['Semua', 'Terkonfirmasi', 'Menunggu Pembayaran']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedStatus = val;
                      });
                    }
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: ['Terbaru', 'Terlama'].contains(selectedTanggal)
                      ? selectedTanggal
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Urutkan',
                    labelStyle: TextStyle(color: Colors.green.shade700),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade700),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green.shade700,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  iconEnabledColor: Colors.green.shade700,
                  dropdownColor: Colors.green.shade50,
                  items: ['Terbaru', 'Terlama']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedTanggal = val;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // List transaksi
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Text('Belum ada riwayat pembayaran'))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final h = filtered[i];
                      Color statusColor = h['status'] == 'Terkonfirmasi'
                          ? Colors.green.shade100
                          : Colors.yellow.shade100;
                      Color borderColor = h['status'] == 'Terkonfirmasi'
                          ? Colors.green.shade400
                          : Colors.yellow.shade700;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: borderColor, width: 1),
                        ),
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    h['title'] ?? 'Tanpa Judul',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      h['status'] ?? '-',
                                      style: TextStyle(
                                        color: Colors.green.shade800,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                h['date'] ?? '-',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(h['method'] ?? '-'),
                                  Text(
                                    'Rp ${h['amount'] ?? '0'}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/* --------------------------- Contoh Data --------------------------- */
final List<Map<String, dynamic>> exampleHistory = [
  {
    'title': 'Tagihan #12345',
    'date': '26 April 2025, 14:25',
    'method': 'QRIS (E-wallet)',
    'amount': '15.000',
    'status': 'Terkonfirmasi',
  },
  {
    'title': 'Tagihan #12346',
    'date': '26 April 2025, 14:25',
    'method': 'Bank Transfer',
    'amount': '15.000',
    'status': 'Menunggu Pembayaran',
  },
];

/* --------------------------- Profile Tab --------------------------- */
class ProfileTab extends StatelessWidget {
  final Map<String, dynamic> member;
  const ProfileTab({required this.member});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(radius: 28, child: Text(member['name'][0])),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          member['id'],
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Informasi Pelanggan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama Lengkap: ${member['name']}'),
                  SizedBox(height: 6),
                  Text('Alamat: ${member['address']}'),
                  SizedBox(height: 6),
                  Text('ID: ${member['id']}'),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => LogoutConfirmationDialog(),
                );
              },
              child: Text('Logout'),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

/* --------------------------- Pembayaran Berhasil Page --------------------------- */
class PembayaranBerhasilPage extends StatelessWidget {
  final Map<String, dynamic> bill;
  final String method;

  const PembayaranBerhasilPage({required this.bill, required this.method});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran Berhasil'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 16),
            const Text(
              'Pembayaran Berhasil!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tagihan ${bill['title']} telah dibayar via $method.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.download),
                label: const Text('Unduh Bukti Pembayaran'),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) =>
                        BuktiPembayaranBottomSheet(bill: bill, method: method),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => DashboardScreen()),
                  (route) => false,
                );
              },
              child: const Text('Kembali ke Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}

/* --------------------------- Bukti Pembayaran Bottom Sheet --------------------------- */
class BuktiPembayaranBottomSheet extends StatelessWidget {
  final Map<String, dynamic> bill;
  final String method;

  const BuktiPembayaranBottomSheet({required this.bill, required this.method});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 330,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Bukti Pembayaran',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(bill['title']),
            subtitle: Text('Metode: $method'),
            trailing: Text(
              'Rp ${bill['amount']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tanggal Pembayaran:'),
              Text(
                '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ID Transaksi:'),
              Text('#TRX${Random().nextInt(99999).toString().padLeft(5, '0')}'),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bukti pembayaran telah diunduh (dummy)'),
                  ),
                );
              },
              child: const Text('Simpan ke Galeri'),
            ),
          ),
        ],
      ),
    );
  }
}

/* --------------------------- Logout Confirmation --------------------------- */
class LogoutConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        'Konfirmasi Logout',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Apakah Anda yakin ingin keluar?'),
          SizedBox(height: 8),
          Text(
            'Pastikan Anda telah menyelesaikan pembayaran dan menyimpan bukti pembayaran sebelum keluar',
            style: TextStyle(color: Colors.grey, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => WelcomeScreen()),
                      (route) => false,
                    );
                  },
                  child: const Text('Keluar'),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Akun Anda akan keluar dan kembali ke halaman login',
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
