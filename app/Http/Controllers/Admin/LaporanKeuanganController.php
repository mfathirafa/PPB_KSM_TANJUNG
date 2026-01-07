<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Pembayaran;
use App\Models\Tagihan;
use Carbon\Carbon;
use Barryvdh\DomPDF\Facade\Pdf;
use Illuminate\Http\Request;

class LaporanKeuanganController extends Controller
{
    /* =====================================================
     * GET /admin/laporan-keuangan
     * Dashboard 7 hari terakhir
     * ===================================================== */
    public function index()
    {
        $totalPendapatan = (int) Pembayaran::where('status', 'confirmed')
            ->sum('jumlah_bayar');

        $totalTagihan = (int) Tagihan::count();

        $chart = collect();

        for ($i = 6; $i >= 0; $i--) {
            $date = Carbon::today()->subDays($i);

            $chart->push([
                'tanggal' => $date->toDateString(),
                'total' => (int) Pembayaran::whereDate('created_at', $date)
                    ->where('status', 'confirmed')
                    ->sum('jumlah_bayar'),
            ]);
        }

        $transactions = Pembayaran::with('tagihan.pelanggan')
            ->where('status', 'confirmed')
            ->latest()
            ->limit(10)
            ->get()
            ->map(fn ($p) => [
                'tanggal'    => $p->created_at->format('d M Y'),
                'tagihan_id' => (int) $p->tagihan_id,
                'nama'       => $p->tagihan->pelanggan->nama ?? '-',
                'jumlah'     => (int) $p->jumlah_bayar,
            ]);

        return response()->json([
            'summary' => [
                'total_pendapatan' => $totalPendapatan,
                'total_tagihan'    => $totalTagihan,
            ],
            'chart' => $chart,
            'transactions' => $transactions,
        ]);
    }

    /* =====================================================
     * GET /admin/laporan-keuangan/{periode}
     * JSON laporan bulanan
     * ===================================================== */
    public function show(string $periode)
    {
        [$start, $end] = $this->parsePeriode($periode);

        return response()->json(
            $this->buildLaporanData($start, $end, $periode)
        );
    }

    /* =====================================================
     * GET /admin/laporan-keuangan/pdf/{periode}
     * EXPORT PDF
     * ===================================================== */
    public function pdf(string $periode)
    {
        [$start, $end] = $this->parsePeriode($periode);

        $data = $this->buildLaporanData($start, $end, $periode);

        $pdf = Pdf::loadView('pdf.laporan_keuangan', $data);

        return $pdf->download("laporan-keuangan-$periode.pdf");
    }

    /* =====================================================
     * UTILITIES
     * ===================================================== */

    private function parsePeriode(string $periode): array
    {
        try {
            $start = Carbon::createFromFormat('Y-m', $periode)->startOfMonth();
            $end   = Carbon::createFromFormat('Y-m', $periode)->endOfMonth();
            return [$start, $end];
        } catch (\Exception) {
            abort(422, 'Format periode harus YYYY-MM');
        }
    }

    private function buildLaporanData(Carbon $start, Carbon $end, string $periode): array
    {
        $totalPendapatan = (int) Pembayaran::whereBetween('created_at', [$start, $end])
            ->where('status', 'confirmed')
            ->sum('jumlah_bayar');

        $totalTagihan = (int) Tagihan::whereBetween('tanggal', [$start, $end])->count();

        $chart = [];
        $cursor = $start->copy();

        while ($cursor <= $end) {
            $chart[] = [
                'tanggal' => $cursor->toDateString(),
                'total' => (int) Pembayaran::whereDate('created_at', $cursor)
                    ->where('status', 'confirmed')
                    ->sum('jumlah_bayar'),
            ];
            $cursor->addDay();
        }

        $transactions = Pembayaran::with('tagihan.pelanggan')
            ->whereBetween('created_at', [$start, $end])
            ->where('status', 'confirmed')
            ->latest()
            ->get()
            ->map(fn ($p) => [
                'tanggal' => $p->created_at->format('d M Y'),
                'tagihan_id' => $p->tagihan_id,
                'nama' => $p->tagihan->pelanggan->nama ?? '-',
                'jumlah' => (int) $p->jumlah_bayar,
            ]);

        return [
            'periode' => $periode,
            'summary' => [
                'total_pendapatan' => $totalPendapatan,
                'total_tagihan' => $totalTagihan,
            ],
            'chart' => $chart,
            'transactions' => $transactions,
        ];
    }
}