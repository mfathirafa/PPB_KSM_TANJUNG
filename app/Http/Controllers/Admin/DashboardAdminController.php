<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Tagihan;
use App\Models\Pembayaran;
use Carbon\Carbon;

class DashboardAdminController extends Controller
{
    public function index()
    {
        $bulanIni = Carbon::now()->format('Y-m');

        return response()->json([
            'total_pelanggan' => User::where('role', 'customer')->count(),
            'total_tagihan' => Tagihan::count(),
            'pembayaran_pending' => Pembayaran::where('status', 'pending')->count(),
            'total_pemasukan_bulan_ini' => Pembayaran::where('status', 'confirmed')
                ->where('tanggal', 'like', "$bulanIni%")
                ->sum('jumlah_bayar'),
        ]);
    }
}