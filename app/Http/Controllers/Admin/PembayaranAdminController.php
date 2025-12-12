<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class PembayaranAdminController extends Controller
{
    public function index()
    {
        // list semua pembayaran + filter
    }

    public function approve($id)
    {
        // ubah status menjadi 'Terkonfirmasi'
        // update tagihan menjadi Lunas
        // kirim notifikasi ke pelanggan
    }

    public function reject($id)
    {
        // ubah status menjadi 'Ditolak'
    }
}
