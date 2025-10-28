import 'dart:math';

// Data Member
const Map<String, dynamic> member = {
  'name': 'Fathi Setiawan',
  'id': 'KSM-00123',
  'address': 'Jl. Tanjung No.12',
};

// Data Bills
final List<Map<String, dynamic>> bills = [
  {
    'id': 'TAG202504',
    'title': 'Tagihan saat ini',
    'amount': 15000.0,
    'due': '30 April 2025',
    'status': 'Belum Dibayar',
  },
  {
    'id': 'TAG202503',
    'title': 'Tagihan Maret 2025',
    'amount': 12000.0,
    'due': '31 Maret 2025',
    'status': 'Lunas',
  },
  {
    'id': 'TAG202502',
    'title': 'Tagihan Februari 2025',
    'amount': 11000.0,
    'due': '28 Februari 2025',
    'status': 'Sudah Dibayar',
  },
];

// Data History
final List<Map<String, dynamic>> history = [
  {
    'id': '#TRX001',
    'title': 'Pembayaran Tagihan #TAG202503',
    'amount': 12000,
    'method': 'QRIS',
    'date': '25 Apr 2025',
    'status': 'Terkonfirmasi',
  },
  {
    'id': '#TRX002',
    'title': 'Pembayaran Tagihan #TAG202502',
    'amount': 11000,
    'method': 'Transfer Bank',
    'date': '01 Mar 2025',
    'status': 'Terkonfirmasi',
  },
];

// Fungsi Utility
String generateOtp() {
  return (Random().nextInt(900000) + 100000).toString();
}
