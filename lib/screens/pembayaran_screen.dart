import 'package:flutter/material.dart';
import 'qris_payment_page.dart';
import 'pembayaran_berhasil_page.dart';
import '../services/api_service.dart';

class PembayaranScreen extends StatefulWidget {
  final Map<String, dynamic> bill;

  const PembayaranScreen({super.key, required this.bill});

  @override
  State<PembayaranScreen> createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  String _method = 'QRIS';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tagihan #${b['id']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Jumlah: Rp ${b['jumlah']}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Jatuh Tempo: ${b['tanggal']}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),

              const Text(
                'Pilih metode pembayaran',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              RadioListTile<String>(
                value: 'qris',
                groupValue: _method,
                title: const Text('QRIS (E-Wallet)'),
                onChanged: (v) => setState(() => _method = v!),
              ),
              RadioListTile<String>(
                value: 'transfer',
                groupValue: _method,
                title: const Text('Transfer Bank'),
                onChanged: (v) => setState(() => _method = v!),
              ),

              const SizedBox(height: 20),

              Text(
                'Jumlah Dibayarkan: Rp ${b['jumlah']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    _showProcessingDialog(context);

                    await ApiService.bayarTagihan(
                      b['token'],
                      b['id'],
                      _method,
                    );

                    Navigator.pop(context);

                    if (_method == 'qris') {
                      _showQrisConfirmationDialog(context, b);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PembayaranBerhasilPage(
                            bill: b,
                            method: _method,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
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

  // =======================
  // LOADING DIALOG
  // =======================
  void _showProcessingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 24),
                Text(
                  'Memproses Pembayaran',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Harap tunggu proses transaksi Anda'),
              ],
            ),
          ),
        );
      },
    );
  }

  // =======================
  // KONFIRMASI QRIS
  // =======================
  void _showQrisConfirmationDialog(
    BuildContext context,
    Map<String, dynamic> bill,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Konfirmasi Transaksi',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _infoRow('Nama Pelanggan', bill['nama']),
              _infoRow('Nomor Tagihan', '#${bill['id']}'),
              _infoRow('Tanggal', bill['tanggal']),
              _infoRow('Jumlah', 'Rp ${bill['jumlah']}'),
              _infoRow('Metode', 'QRIS'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QrisPaymentPage(bill: bill),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Bayar dengan QRIS',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
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