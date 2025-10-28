import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/dialogs.dart';
import 'pembayaran_berhasil_page.dart';
import 'qris_payment_page.dart';

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
                  onPressed: () async {
                    _showProcessingDialog(context);

                    await Future.delayed(const Duration(seconds: 2));

                    Navigator.pop(context);

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

  void _showProcessingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(height: 16),
                CircularProgressIndicator(),
                SizedBox(height: 24),
                Text(
                  'Memproses Pembayaran',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'harap tunggu proses transaksi anda',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
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
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QrisPaymentPage(bill: bill),
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
