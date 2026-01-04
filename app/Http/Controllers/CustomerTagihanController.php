<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Tagihan;

class CustomerTagihanController extends Controller
{
    /**
     * GET /tagihan
     */
    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'customer' || !$user->pelanggan) {
            return response()->json([
                'tagihan' => [],
                'summary' => [
                    'total' => 0,
                    'belum_dibayar' => 0,
                    'lunas' => 0,
                ]
            ]);
        }

        $tagihans = Tagihan::with('pembayarans')
            ->where('pelanggan_id', $user->pelanggan->id)
            ->orderByDesc('tanggal')
            ->get();

        $data = $tagihans->map(function ($t) {
            return [
                'id' => $t->id,
                'tanggal' => $t->tanggal->format('Y-m-d'),
                'jumlah' => $t->jumlah,
                'status' => $t->statusAktif(),
            ];
        });

        return response()->json([
            'tagihan' => $data,
            'summary' => [
                'total' => $data->count(),
                'belum_dibayar' => $data->whereIn('status', ['belum_dibayar','pending'])->count(),
                'lunas' => $data->where('status','lunas')->count(),
            ]
        ]);
    }

    /**
     * GET /tagihan/aktif
     */
    public function aktif(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'customer' || !$user->pelanggan) {
            return response()->json(null);
        }

        // 🔥 HANYA YANG PERLU DITINDAK
        $tagihan = Tagihan::with('pembayarans')
            ->where('pelanggan_id', $user->pelanggan->id)
            ->get()
            ->first(fn ($t) => in_array($t->statusAktif(), ['belum_dibayar','pending']));

        if (!$tagihan) return response()->json(null);

        return response()->json([
            'id' => $tagihan->id,
            'tanggal' => $tagihan->tanggal->format('Y-m-d'),
            'jumlah' => $tagihan->jumlah,
            'status' => $tagihan->statusAktif(),
        ]);
    }
}