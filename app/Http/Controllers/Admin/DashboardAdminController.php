<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Pembayaran;
use App\Models\Tagihan;
use Illuminate\Http\Request;

class DashboardAdminController extends Controller
{
    public function index()
    {
        // 1. Total pemasukan bulan ini
        $monthIncome = Pembayaran::where('status', 'approved')
            ->whereMonth('created_at', now()->month)
            ->whereYear('created_at', now()->year)
            ->sum('nominal');

        // 2. Total tagihan bulan ini
        $monthBills = Tagihan::whereMonth('tanggal', now()->month)
            ->whereYear('tanggal', now()->year)
            ->sum('jumlah');

        // 3. Total tagihan belum dibayar
        $unpaidTotal = Tagihan::where('status', 'unpaid')->sum('jumlah');

        // 4. Pembayaran pending
        $pendingPayments = Pembayaran::where('status', 'pending')->count();

        // 5. Grafik pemasukan per bulan
        $chartMonthly = Pembayaran::selectRaw('MONTH(created_at) as month, SUM(nominal) as total')
            ->where('status', 'approved')
            ->whereYear('created_at', now()->year)
            ->groupBy('month')
            ->orderBy('month')
            ->get();

        // 6. Pemasukan harian bulan ini
        $chartDaily = Pembayaran::selectRaw('DAY(created_at) as day, SUM(nominal) as total')
            ->where('status', 'approved')
            ->whereMonth('created_at', now()->month)
            ->groupBy('day')
            ->orderBy('day')
            ->get();

        return response()->json([
            'month_income' => $monthIncome,
            'month_bills' => $monthBills,
            'unpaid_total' => $unpaidTotal,
            'pending_payments' => $pendingPayments,
            'chart_monthly' => $chartMonthly,
            'chart_daily' => $chartDaily,
        ]);
    }
}
