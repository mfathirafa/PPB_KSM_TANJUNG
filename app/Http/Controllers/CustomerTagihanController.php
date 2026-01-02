<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Tagihan;

class CustomerTagihanController extends Controller
{
    /**
     * =========================
     * GET /tagihan
     * =========================
     * List tagihan customer login
     */
    public function index(Request $request)
    {
        $user = $request->user();

        // Pastikan user adalah customer
        if ($user->role !== 'customer') {
            return response()->json([
                'message' => 'Forbidden'
            ], 403);
        }

        // Pastikan customer punya data pelanggan
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

        $tagihans = Tagihan::where('pelanggan_id', $user->pelanggan->id)
            ->orderBy('tanggal', 'desc')
            ->get();

        // Summary untuk dashboard
        $summary = [
            'total' => $tagihans->count(),
            'belum_dibayar' => $tagihans->where('status', 'belum_dibayar')->count(),
            'lunas' => $tagihans->whereIn('status', ['dibayar', 'lunas'])->count(),
        ];

        // Mapping data untuk UI Flutter
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
}