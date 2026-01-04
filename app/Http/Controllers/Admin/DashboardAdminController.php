<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Pelanggan;
use App\Models\Tagihan;
use App\Models\Pembayaran;
use Illuminate\Http\Request;
use Carbon\Carbon;

class DashboardAdminController extends Controller
{
    /**
     * GET /api/admin/dashboard
     */
    public function index()
    {
        // =========================
        // STATISTIK UTAMA
        // =========================
        $totalPelanggan = Pelanggan::count();
        $totalTagihan   = Tagihan::count();

        // TOTAL TRANSAKSI PEMBAYARAN
        $totalTransaksi = Pembayaran::count();

        // TOTAL UANG MASUK (CONFIRMED SAJA)
        $totalPembayaran = Pembayaran::where('status', 'confirmed')
            ->sum('jumlah_bayar');

        // PEMBAYARAN PENDING
        $pendingPembayaran = Pembayaran::where('status', 'pending')->count();

        // =========================
        // TOTAL TAGIHAN BULAN INI
        // =========================
        $totalTagihanBulanIni = Tagihan::whereMonth('tanggal', now()->month)
            ->whereYear('tanggal', now()->year)
            ->sum('jumlah');

        // =========================
        // TAGIHAN TERBARU (5 DATA)
        // =========================
        $tagihanTerbaru = Tagihan::with('pelanggan.user')
            ->orderByDesc('created_at')
            ->limit(5)
            ->get()
            ->map(function ($t) {
                return [
                    'id'      => $t->id,
                    'nama'    => $t->pelanggan->nama ?? '-',
                    'tanggal' => $t->tanggal->format('Y-m-d'),
                    'jumlah'  => $t->jumlah,
                    'status'  => $t->status,
                ];
            });

        return response()->json([
            'stats' => [
                'total_pelanggan'          => $totalPelanggan,
                'total_tagihan'            => $totalTagihan,
                'total_transaksi'          => $totalTransaksi,
                'total_pembayaran'         => $totalPembayaran,
                'pending_pembayaran'       => $pendingPembayaran,
                'total_tagihan_bulan_ini'  => $totalTagihanBulanIni,
            ],
            'tagihan_terbaru' => $tagihanTerbaru,
            'tanggal' => now()->format('Y-m-d'),
        ]);
    }
}