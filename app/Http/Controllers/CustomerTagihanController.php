<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Tagihan;

class CustomerTagihanController extends Controller
{
    /**
     * GET /tagihan
     * List tagihan customer
     */
    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'customer') {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        if (!$user->pelanggan) {
            return response()->json([
                'tagihan' => [],
                'summary' => [
                    'total' => 0,
                    'belum_dibayar' => 0,
                    'lunas' => 0,
                ]
            ]);
        }

        // 🔥 FIX UTAMA: urutkan belum dibayar ke atas
        $tagihans = Tagihan::where('pelanggan_id', $user->pelanggan->id)
            ->orderByRaw("
                CASE 
                    WHEN status IN ('belum_dibayar','pending') THEN 0
                    ELSE 1
                END
            ")
            ->orderByDesc('tanggal')
            ->get();

        $summary = [
            'total' => $tagihans->count(),
            'belum_dibayar' => $tagihans->whereIn('status', ['belum_dibayar','pending'])->count(),
            'lunas' => $tagihans->whereIn('status', ['dibayar','lunas'])->count(),
        ];

        $data = $tagihans->map(function ($t) {
            return [
                'id' => $t->id,
                'tanggal' => $t->tanggal->format('Y-m-d'),
                'jumlah' => $t->jumlah,
                'status' => $t->status,
            ];
        });

        return response()->json([
            'tagihan' => $data,
            'summary' => $summary,
        ]);
    }

    /**
     * GET /tagihan/aktif
     * Dipakai HomeTab
     */
    public function aktif(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'customer' || !$user->pelanggan) {
            return response()->json(null);
        }

        $t = Tagihan::where('pelanggan_id', $user->pelanggan->id)
            ->whereIn('status', ['belum_dibayar', 'pending'])
            ->orderByDesc('tanggal')
            ->first();

        if (!$t) {
            return response()->json(null);
        }

        return response()->json([
            'id' => $t->id,
            'tanggal' => $t->tanggal->format('Y-m-d'),
            'jumlah' => $t->jumlah,
            'status' => $t->status,
        ]);
    }


}
