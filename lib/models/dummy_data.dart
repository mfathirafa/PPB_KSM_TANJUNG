import 'dart:math';

// Data Member
const Map<String, dynamic> member = {
  'name': 'Fathi Setiawan',
  'id': 'KSM-00123',
  'address': 'Jl. Tanjung No.12',
  'phone': '+62 812 3456 7890', // <= DITAMBAHKAN
};

// Data Bills
final List<Map<String, dynamic>> bills = [
  {
    'id': 'TAG202504',
    'title': 'Tagihan saat ini',
    'name': 'Fathi Setiawan', // <= DITAMBAHKAN
    'phone': '+62 812 3456 7890', // <= DITAMBAHKAN
    'amount': 15000.0, // Diubah menjadi Double
    'due': '30 April 2025',
    'status': 'Belum Dibayar',
    'timestamp': 1714440000,
  },
  {
    'id': 'TAG202503',
    'title': 'Tagihan Maret 2025',
    'name': 'Fathi Setiawan', // <= DITAMBAHKAN
    'phone': '+62 812 3456 7890', // <= DITAMBAHKAN
    'amount': 12000.0, // Diubah menjadi Double
    'due': '31 Maret 2025',
    'status': 'Sudah Dibayar',
    'timestamp': 1714436400,
  },
  {
    'id': 'TAG202502',
    'title': 'Tagihan Februari 2025',
    'name': 'Fathi Setiawan', // <= DITAMBAHKAN
    'phone': '+62 812 3456 7890', // <= DITAMBAHKAN
    'amount': 11000.0, // Diubah menjadi Double
    'due': '28 Februari 2025',
    'status': 'Lunas',
    'timestamp': 1714432800,
  },
];

// Data History
final List<Map<String, dynamic>> history = [
  {
    'id': '#TRX001',
    'title': 'Tagihan #TAG202503',
    'amount': 12000.0, // Diubah menjadi Double
    'method': 'QRIS',
    'date': '25 Apr 2025, 14:25',
    'status': 'Terkonfirmasi',
    'timestamp': 1714125900,
  },
  {
    'id': '#TRX002',
    'title': 'Tagihan #TAG202502',
    'amount': 11000.0, // Diubah menjadi Double
    'method': 'Transfer Bank',
    'date': '01 Mar 2025, 10:00',
    'status': 'Terkonfirmasi',
    'timestamp': 1709280000,
  },
  {
    'id': '#TRX003',
    'title': 'Tagihan #TAG202504',
    'amount': 15000.0,
    'method': 'Virtual Account',
    'date': '29 Apr 2025, 11:30',
    'status': 'Menunggu Pembayaran',
    'timestamp': 1714361400,
  },
];

// Fungsi Utility
String generateOtp() {
  return (Random().nextInt(900000) + 100000).toString();
}
