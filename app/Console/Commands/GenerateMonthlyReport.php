<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Pembayaran;
use App\Models\LaporanKeuangan;
use Carbon\Carbon;

class GenerateMonthlyReport extends Command
{
    protected $signature = 'report:generate-monthly {--month=}';
    protected $description = 'Generate laporan keuangan bulanan dari data pembayaran';

    public function handle(): int
    {
        $month = $this->option('month')
            ?? now()->subMonth()->format('Y-m');

        $start = Carbon::parse($month . '-01')->startOfMonth();
        $end   = Carbon::parse($month . '-01')->endOfMonth();

        $totalPemasukan = Pembayaran::whereBetween('tanggal', [$start, $end])
            ->sum('jumlah_bayar');

        $totalTransaksi = Pembayaran::whereBetween('tanggal', [$start, $end])
            ->count();

        LaporanKeuangan::updateOrCreate(
            ['periode' => $month],
            [
                'total_pemasukan' => $totalPemasukan,
                'total_transaksi' => $totalTransaksi,
                'generated_at' => now(),
            ]
        );

        $this->info("Laporan {$month} berhasil dibuat");
        $this->info("Total pemasukan : Rp {$totalPemasukan}");
        $this->info("Total transaksi : {$totalTransaksi}");

        return Command::SUCCESS;
    }
}
