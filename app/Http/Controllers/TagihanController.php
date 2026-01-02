<?php

namespace App\Http\Controllers;

use App\Models\Tagihan;
use App\Models\Pelanggan;
use Illuminate\Http\Request;


class CustomerTagihanController extends Controller
{
    public function index(Request $request)
    {
        $user = auth()->user();

        // Pastikan user punya data pelanggan
        $pelanggan = Pelanggan::where('user_id', $user->user_id)->first();

        if (!$pelanggan) {
            return response()->json([
                'tagihan' => [],
                'summary' => [
                    'total_unpaid' => 0,
                    'nominal_unpaid' => 0,
                    'total_paid' => 0,
                    'nominal_paid' => 0,
                ]
            ]);
        }

        // Ambil semua tagihan user
        $tagihan = Tagihan::where('pelanggan_id', $pelanggan->id_pelanggan)
            ->orderBy('tanggal', 'desc')
            ->get()
            ->map(function ($t) {

                // Mapping status backend → status Flutter UI
                $status = match ($t->status) {
                    'unpaid' => 'Belum Dibayar',
                    'paid'   => 'Sudah Dibayar',
                    'pending' => 'Menunggu Pembayaran',
                    default => 'Belum Dibayar'
                };

                return [
                    'id' => $t->id_tagihan,
                    'name' => $t->pelanggan->user->name,
                    'phone' => $t->pelanggan->no_hp,
                    'amount' => $t->jumlah,
                    'due' => $t->tanggal,
                    'status' => $status,
                    'timestamp' => strtotime($t->tanggal),
                ];
            });

        // Summary untuk UI (bills.fold)
        $unpaid = $tagihan->where('status', 'Belum Dibayar');
        $paid   = $tagihan->whereIn('status', ['Sudah Dibayar','Lunas']);

        $summary = [
            'total_unpaid' => $unpaid->count(),
            'nominal_unpaid' => $unpaid->sum('amount'),

            'total_paid' => $paid->count(),
            'nominal_paid' => $paid->sum('amount'),
        ];

        return response()->json([
            'tagihan' => $tagihan,
            'summary' => $summary,
        ]);
    }
}
