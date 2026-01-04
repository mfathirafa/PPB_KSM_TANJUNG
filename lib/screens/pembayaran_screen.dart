import 'package:flutter/material.dart';
import 'qris_payment_page.dart';
import 'pembayaran_berhasil_page.dart';
import '../services/pembayaran_service.dart';

class PembayaranScreen extends StatefulWidget {
  final Map<String, dynamic> bill;
  final String token;

  const PembayaranScreen({
    super.key,
    required this.bill,
    required this.token,
  });

  @override
  State<PembayaranScreen> createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  late Map<String, dynamic> bill;
  late String token;

  // METODE PEMBAYARAN
  String metode = 'QRIS';

  @override
  void initState() {
    super.initState();
    bill = widget.bill;
    token = widget.token;
  }

  // =========================
  // STATUS & VALIDASI
  // =========================
  bool get _isPending =>
      bill['pembayaran_status'] == 'pending';

  bool get _dataValid =>
      bill['id'] != null &&
      bill['jumlah'] != null &&
      bill['tanggal'] != null;

  @override
  Widget build(BuildContext context) {
    if (!_dataValid) {
      return Scaffold(
        appBar: _appBar(),
        body: const Center(
          child: Text(
            'Data tagihan tidak valid.\nSilakan kembali dan refresh.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tagihan #${bill['id']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Jumlah: Rp ${bill['jumlah']}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tanggal: ${bill['tanggal']}',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 16),

            // =========================
            // INFO STATUS
            // =========================
            if (_isPending)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber),
                ),
                child: const Text(
                  'Pembayaran sedang menunggu verifikasi.\n'
                  'Anda tidak dapat melakukan pembayaran ulang.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

            const Text(
              'Pilih metode pembayaran',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // =========================
            // PILIH METODE
            // =========================
            RadioListTile<String>(
              value: 'QRIS',
              groupValue: metode,
              title: const Text('QRIS (E-Wallet)'),
              onChanged: _isPending
                  ? null
                  : (v) => setState(() => metode = v!),
            ),
            RadioListTile<String>(
              value: 'TRANSFER',
              groupValue: metode,
              title: const Text('Transfer Bank'),
              onChanged: _isPending
                  ? null
                  : (v) => setState(() => metode = v!),
            ),

            const SizedBox(height: 20),

            Text(
              'Jumlah Dibayarkan: Rp ${bill['jumlah']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // =========================
            // BUTTON BAYAR
            // =========================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isPending ? null : _submitPayment,
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
    );
  }

  // =========================
  // SUBMIT PEMBAYARAN
  // =========================
  Future<void> _submitPayment() async {
    _showProcessingDialog();

    try {
      await PembayaranService.create(
        token: token,
        tagihanId: bill['id'],
        metode: metode,
      );

      Navigator.pop(context);

      setState(() {
        bill['pembayaran_status'] = 'pending';
      });

      if (metode == 'QRIS') {
        _showQrisConfirmationDialog();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PembayaranBerhasilPage(
              bill: bill,
              method: metode,
            ),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      _showError('Pembayaran gagal. Silakan coba lagi.');
    }
  }

  // =========================
  // UI HELPERS
  // =========================
  AppBar _appBar() {
    return AppBar(
      title: const Text('Pembayaran Tagihan'),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    );
  }

  void _showProcessingDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Memproses Pembayaran'),
            ],
          ),
        ),
      ),
    );
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Gagal'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showQrisConfirmationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Transaksi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _infoRow('Tagihan', '#${bill['id']}'),
            _infoRow('Jumlah', 'Rp ${bill['jumlah']}'),
            _infoRow('Metode', metode),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => QrisPaymentPage(bill: bill),
                ),
              );
            },
            child: const Text('Bayar dengan QRIS'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}