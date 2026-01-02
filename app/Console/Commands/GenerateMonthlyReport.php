<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Pembayaran;
use App\Models\LaporanKeuangan;
use Carbon\Carbon;

class GenerateMonthlyReport extends Command
{
    protected $signature = 'report:generate-monthly {--periode=}';
    protected $description = 'Generate laporan keuangan bulanan';

    public function handle()
    {
        $periode = $this->option('periode')
            ?? Carbon::now()->subMonth()->format('Y-m');

        $start = Carbon::createFromFormat('Y-m', $periode)->startOfMonth();
        $end   = Carbon::createFromFormat('Y-m', $periode)->endOfMonth();

        $totalPemasukan = Pembayaran::where('status', 'confirmed')
            ->whereBetween('tanggal', [$start, $end])
            ->sum('jumlah_bayar');

        $totalTransaksi = Pembayaran::where('status', 'confirmed')
            ->whereBetween('tanggal', [$start, $end])
            ->count();

        LaporanKeuangan::updateOrCreate(
            ['periode' => $periode],
            [
                'total_pemasukan' => $totalPemasukan,
                'total_transaksi' => $totalTransaksi,
                'generated_at' => now(),
            ]
        );

        $this->info("Laporan {$periode} berhasil dibuat");
        $this->info("Total pemasukan : Rp {$totalPemasukan}");
        $this->info("Total transaksi : {$totalTransaksi}");
    }
}