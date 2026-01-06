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
                'bulan'    => $t->tanggal->translatedFormat('F Y'),
                'jumlah'   => $t->jumlah,

                // ================= STATUS =================
                'status'        => $status, // belum_dibayar | menunggu_verifikasi | lunas
                'status_label'  => match ($status) {
                    'belum_dibayar'        => 'Belum Dibayar',
                    'menunggu_verifikasi' => 'Menunggu Verifikasi',
                    'lunas'                => 'Lunas',
                    default                => '-',
                },

                // ================= FLAG UI =================
                'can_pay'    => $status === 'belum_dibayar',
                'is_waiting' => $status === 'menunggu_verifikasi',
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
     * TAGIHAN AKTIF (UNTUK HOME TAB)
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

        $status = $tagihan->statusAktif();

        return response()->json([
            'id'       => $tagihan->id,
            'tanggal'  => $tagihan->tanggal->format('Y-m-d'),
            'bulan'    => $tagihan->tanggal->translatedFormat('F Y'),
            'jumlah'   => $tagihan->jumlah,

            // ================= STATUS =================
            'status'        => $status,
            'status_label'  => match ($status) {
                'belum_dibayar'        => 'Belum Dibayar',
                'menunggu_verifikasi' => 'Menunggu Verifikasi',
                default                => '-',
            },

            // ================= FLAG UI =================
            'can_pay'    => $status === 'belum_dibayar',
            'is_waiting' => $status === 'menunggu_verifikasi',
        ]);
    }
}