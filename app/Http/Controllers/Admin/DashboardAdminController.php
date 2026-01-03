<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Pelanggan;
use App\Models\Tagihan;
use App\Models\Pembayaran;
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
        $totalPembayaran = Pembayaran::count();

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
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get()
            ->map(function ($t) {
                return [
                    'id'       => $t->id,
                    'nama'     => $t->pelanggan->nama ?? '-',
                    'tanggal'  => $t->tanggal,
                    'jumlah'   => $t->jumlah,
                    'status'   => $t->status,
                ];
            });

        return response()->json([
            'stats' => [
                'total_pelanggan'        => $totalPelanggan,
                'total_tagihan'          => $totalTagihan,
                'total_pembayaran'       => $totalPembayaran,
                'pending_pembayaran'     => $pendingPembayaran,
                'total_tagihan_bulan_ini'=> $totalTagihanBulanIni,
            ],
            'tagihan_terbaru' => $tagihanTerbaru,
            'tanggal' => now()->format('Y-m-d'),
        ]);
    }
}