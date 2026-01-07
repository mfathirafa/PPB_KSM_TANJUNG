<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
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
        $today = Carbon::today();

        /* =========================
         | PELANGGAN
         ========================= */
        $totalPelanggan = Pelanggan::count();
        $pelangganAktif3Bulan = Pelanggan::where(
            'created_at',
            '>=',
            now()->subMonths(3)
        )->count();

        /* =========================
         | TAGIHAN BULAN INI
         ========================= */
        $tagihanQuery = Tagihan::whereMonth('tanggal', now()->month)
            ->whereYear('tanggal', now()->year);

        $totalTagihanBulanIniRp = (int) $tagihanQuery->sum('jumlah');
        $totalTagihanBulanIniCount = (int) $tagihanQuery->count();

        /* =========================
         | PEMBAYARAN HARI INI
         ========================= */
        $pembayaranHariIniRp = (int) Pembayaran::whereDate('created_at', $today)
            ->where('status', 'confirmed')
            ->sum('jumlah_bayar');

        $pembayaranHariIniTransaksi = (int) Pembayaran::whereDate('created_at', $today)
            ->count();

        /* =========================
         | MENUNGGU VERIFIKASI
         ========================= */
        $menungguVerifikasi = (int) Pembayaran::where('status', 'pending')->count();

        /* =========================
         | TAGIHAN TERBARU
         ========================= */
        $tagihanTerbaru = Tagihan::with(['pelanggan', 'pembayarans'])
            ->orderByDesc('created_at')
            ->limit(5)
            ->get()
            ->map(function ($t) {
                return [
                    'id'      => $t->id,
                    'nama'    => $t->pelanggan->nama ?? '-',
                    'tanggal' => $t->tanggal->format('Y-m-d'),
                    'jumlah'  => (int) $t->jumlah,
                    'status'  => $t->statusAktif(),
                ];
            });

        return response()->json([
            'tanggal' => now()->format('Y-m-d'),

            'stats' => [
                'pelanggan' => [
                    'total' => $totalPelanggan,
                    'aktif_3_bulan' => $pelangganAktif3Bulan,
                ],
                'tagihan' => [
                    'total_rp_bulan_ini' => $totalTagihanBulanIniRp,
                    'total_tagihan_bulan_ini' => $totalTagihanBulanIniCount,
                ],
                'pembayaran_hari_ini' => [
                    'total_rp' => $pembayaranHariIniRp,
                    'total_transaksi' => $pembayaranHariIniTransaksi,
                ],
                'menunggu_verifikasi' => $menungguVerifikasi,
            ],

            'tagihan_terbaru' => $tagihanTerbaru,
        ]);
    }
}