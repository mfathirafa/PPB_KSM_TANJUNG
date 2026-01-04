<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Tagihan;

class CustomerTagihanController extends Controller
{
    /**
     * =====================================================
     * LIST TAGIHAN CUSTOMER
     * GET /tagihan
     * =====================================================
     */
    public function index(Request $request)
    {
        $user = $request->user();

        // 🔒 VALIDASI ROLE & RELASI
        if ($user->role !== 'customer' || !$user->pelanggan) {
            return response()->json([
                'tagihan' => [],
                'summary' => [
                    'total' => 0,
                    'belum_dibayar' => 0,
                    'menunggu_verifikasi' => 0,
                    'lunas' => 0,
                ]
            ]);
        }

        $tagihans = Tagihan::with('pembayarans')
            ->where('pelanggan_id', $user->pelanggan->id)
            ->orderByDesc('tanggal')
            ->get();

        $data = $tagihans->map(function ($t) {
            $status = $t->statusAktif(); // sumber kebenaran

            return [
                'id'       => $t->id,
                'tanggal'  => $t->tanggal->format('Y-m-d'),
                'jumlah'   => $t->jumlah,
                'status'   => $status, // belum_dibayar | menunggu_verifikasi | lunas
            ];
        });

        return response()->json([
            'tagihan' => $data,
            'summary' => [
                'total'                => $data->count(),
                'belum_dibayar'        => $data->where('status', 'belum_dibayar')->count(),
                'menunggu_verifikasi'  => $data->where('status', 'menunggu_verifikasi')->count(),
                'lunas'                => $data->where('status', 'lunas')->count(),
            ]
        ]);
    }

    /**
     * =====================================================
     * TAGIHAN AKTIF (UNTUK HOME)
     * GET /tagihan/aktif
     * =====================================================
     */
    public function aktif(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'customer' || !$user->pelanggan) {
            return response()->json(null);
        }

        // 🔥 PRIORITAS:
        // 1. belum_dibayar
        // 2. menunggu_verifikasi
        $tagihan = Tagihan::with('pembayarans')
            ->where('pelanggan_id', $user->pelanggan->id)
            ->orderByDesc('tanggal')
            ->get()
            ->first(function ($t) {
                return in_array(
                    $t->statusAktif(),
                    ['belum_dibayar', 'menunggu_verifikasi']
                );
            });

        if (!$tagihan) {
            return response()->json(null);
        }

        return response()->json([
            'id'      => $tagihan->id,
            'tanggal' => $tagihan->tanggal->format('Y-m-d'),
            'jumlah'  => $tagihan->jumlah,
            'status'  => $tagihan->statusAktif(),
        ]);
    }
}