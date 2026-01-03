<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Pembayaran;
use App\Models\Tagihan;
use Carbon\Carbon;

class LaporanKeuanganController extends Controller
{
    /**
     * =====================================================
     * GET /admin/laporan-keuangan
     * Dashboard laporan (7 hari terakhir)
     * =====================================================
     */
    public function index(Request $request)
    {
        // 🔒 Security (defensive, walau sudah ada middleware)
        if ($request->user()->role !== 'admin') {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        /* ======================
         * SUMMARY
         * ====================== */
        $totalPendapatan = Pembayaran::where('status', 'approved')
            ->sum('jumlah_bayar');

        $totalTagihan = Tagihan::count();

        /* ======================
         * CHART (7 hari terakhir)
         * ====================== */
        $chart = collect(range(6, 0))->map(function ($i) {
            $date = Carbon::now()->subDays($i)->toDateString();

            return [
                'tanggal' => $date,
                'total' => Pembayaran::whereDate('created_at', $date)
                    ->where('status', 'approved')
                    ->sum('jumlah_bayar'),
            ];
        });

        /* ======================
         * TRANSAKSI TERBARU
         * ====================== */
        $transactions = Pembayaran::with('tagihan.pelanggan')
            ->where('status', 'approved')
            ->latest()
            ->limit(5)
            ->get()
            ->map(function ($p) {
                return [
                    'tanggal' => $p->created_at->format('d M Y'),
                    'tagihan_id' => $p->tagihan_id,
                    'nama' => optional($p->tagihan->pelanggan)->nama,
                    'jumlah' => $p->jumlah_bayar,
                ];
            });

        return response()->json([
            'summary' => [
                'total_pendapatan' => $totalPendapatan,
                'total_tagihan' => $totalTagihan,
            ],
            'chart' => $chart,
            'transactions' => $transactions,
        ]);
    }

    /**
     * =====================================================
     * GET /admin/laporan-keuangan/{periode}
     * Laporan berdasarkan bulan (YYYY-MM)
     * =====================================================
     */
    public function show(Request $request, string $periode)
    {
        // 🔒 Security
        if ($request->user()->role !== 'admin') {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        /* ======================
         * VALIDASI PERIODE
         * ====================== */
        try {
            $start = Carbon::createFromFormat('Y-m', $periode)->startOfMonth();
            $end   = Carbon::createFromFormat('Y-m', $periode)->endOfMonth();
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Format periode tidak valid. Gunakan YYYY-MM'
            ], 422);
        }

        /* ======================
         * SUMMARY
         * ====================== */
        $totalPendapatan = Pembayaran::whereBetween('created_at', [$start, $end])
            ->where('status', 'approved')
            ->sum('jumlah_bayar');

        $totalTagihan = Tagihan::whereBetween('created_at', [$start, $end])
            ->count();

        /* ======================
         * CHART (per hari dalam bulan)
         * ====================== */
        $chart = [];
        $cursor = $start->copy();

        while ($cursor <= $end) {
            $chart[] = [
                'tanggal' => $cursor->toDateString(),
                'total' => Pembayaran::whereDate('created_at', $cursor)
                    ->where('status', 'approved')
                    ->sum('jumlah_bayar'),
            ];
            $cursor->addDay();
        }

        /* ======================
         * TRANSAKSI BULAN TERPILIH
         * ====================== */
        $transactions = Pembayaran::with('tagihan.pelanggan')
            ->whereBetween('created_at', [$start, $end])
            ->where('status', 'approved')
            ->orderByDesc('created_at')
            ->get()
            ->map(function ($p) {
                return [
                    'tanggal' => $p->created_at->format('d M Y'),
                    'tagihan_id' => $p->tagihan_id,
                    'nama' => optional($p->tagihan->pelanggan)->nama,
                    'jumlah' => $p->jumlah_bayar,
                ];
            });

        return response()->json([
            'periode' => $periode,
            'summary' => [
                'total_pendapatan' => $totalPendapatan,
                'total_tagihan' => $totalTagihan,
            ],
            'chart' => $chart,
            'transactions' => $transactions,
        ]);
    }
}