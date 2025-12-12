<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class PembayaranController extends Controller
{
    public function bayar(Request $request, $tagihanId)
    {
        // cek tagihan valid
        // validasi metode pembayaran
        // buat record pembayaran (status pending)
        // jika transfer -> langsung success
        // jika QRIS -> return data untuk halaman QR
    }

    public function riwayat(Request $request)
    {
        // ambil semua pembayaran milik customer
        // return list
    }
}
