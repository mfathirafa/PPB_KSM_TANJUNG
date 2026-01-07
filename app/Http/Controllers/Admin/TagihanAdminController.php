<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Tagihan;
use App\Models\Pelanggan;
use App\Models\Notifikasi;
use App\Models\Pembayaran;
use Carbon\Carbon;

class TagihanAdminController extends Controller
{
    /**
     * GET /admin/tagihan
     */
    public function index(Request $request)
    {
        $this->ensureAdmin($request);

        $tagihans = Tagihan::with(['pelanggan', 'pembayarans'])
            ->orderBy('tanggal', 'desc')
            ->get()
            ->map(function ($t) {
                return [
                    'id'      => $t->id,
                    'nama'    => $t->pelanggan->nama ?? '-',
                    'jumlah'  => (int) $t->jumlah,
                    'tanggal' => $t->tanggal->format('Y-m-d'),
                    'status'  => $t->statusAktif(),
                ];
            });

        return response()->json($tagihans);
    }

    /**
     * POST /admin/tagihan
     */
    public function store(Request $request)
    {
        $this->ensureAdmin($request);

        $request->validate([
            'pelanggan_id' => 'required|exists:pelanggans,id',
            'jumlah'       => 'required|integer|min:1000',
            'tanggal'      => 'required|date',
        ]);

        $pelanggan = Pelanggan::with('user')->findOrFail($request->pelanggan_id);

        $tagihan = Tagihan::create([
            'pelanggan_id' => $pelanggan->id,
            'jumlah'       => $request->jumlah,
            'tanggal'      => $request->tanggal,
        ]);

        Notifikasi::create([
            'user_id' => $pelanggan->user_id,
            'pesan'   => "Tagihan baru sebesar Rp {$tagihan->jumlah} telah dibuat.",
            'tipe'    => 'tagihan',
            'channel' => 'system',
            'status'  => 'sent',
            'sent_at' => Carbon::now(),
        ]);

        return response()->json([
            'message' => 'Tagihan berhasil dibuat',
            'data'    => $tagihan
        ], 201);
    }

    /**
     * GUARD
     */
    private function ensureAdmin(Request $request): void
    {
        if ($request->user()->role !== 'admin') {
            abort(403, 'Forbidden');
        }
    }
}