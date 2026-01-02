<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Tagihan;
use App\Models\Pelanggan;
use App\Models\Notifikasi;
use Carbon\Carbon;

class TagihanAdminController extends Controller
{
    /**
     * GET /admin/tagihan
     * List semua tagihan
     */
    public function index()
    {
        $tagihans = Tagihan::with('pelanggan.user')
            ->orderBy('tanggal', 'desc')
            ->get()
            ->map(function ($t) {
                return [
                    'id'       => $t->id,
                    'nama'     => $t->pelanggan->nama,
                    'jumlah'   => $t->jumlah,
                    'status'   => $t->status,
                    'tanggal'  => $t->tanggal->format('Y-m-d'),
                ];
            });

        return response()->json($tagihans);
    }

    /**
     * POST /admin/tagihan
     * Admin membuat tagihan
     */
    public function store(Request $request)
    {
        $request->validate([
            'pelanggan_id' => 'required|exists:pelanggans,id',
            'jumlah'       => 'required|integer|min:1000',
            'tanggal'      => 'required|date',
        ]);

        $pelanggan = Pelanggan::with('user')->findOrFail($request->pelanggan_id);

        // 1️⃣ Simpan tagihan
        $tagihan = Tagihan::create([
            'pelanggan_id' => $pelanggan->id,
            'jumlah'       => $request->jumlah,
            'tanggal'      => $request->tanggal,
            'status'       => 'belum_dibayar',
        ]);

        // 2️⃣ Kirim notifikasi ke customer
        Notifikasi::create([
            'user_id' => $pelanggan->user_id,
            'pesan'   => "Tagihan baru sebesar Rp {$tagihan->jumlah} telah dibuat.",
            'tipe'    => 'tagihan',
            'channel' => 'system',
            'status'  => 'sent',
            'sent_at' => Carbon::now(),
        ]);

        return response()->json([
            'message' => 'Tagihan berhasil dibuat & notifikasi dikirim',
            'data'    => $tagihan
        ], 201);
    }

    /**
     * GET /admin/tagihan/{id}
     */
    public function show($id)
    {
        $tagihan = Tagihan::with('pelanggan.user')->findOrFail($id);
        return response()->json($tagihan);
    }

    /**
     * PUT /admin/tagihan/{id}
     */
    public function update(Request $request, $id)
    {
        $tagihan = Tagihan::findOrFail($id);

        $request->validate([
            'jumlah'  => 'required|integer|min:1000',
            'tanggal' => 'required|date',
            'status'  => 'required|in:belum_dibayar,dibayar,lunas',
        ]);

        $tagihan->update($request->only('jumlah', 'tanggal', 'status'));

        return response()->json([
            'message' => 'Tagihan berhasil diperbarui'
        ]);
    }

    /**
     * DELETE /admin/tagihan/{id}
     */
    public function destroy($id)
    {
        Tagihan::findOrFail($id)->delete();

        return response()->json([
            'message' => 'Tagihan berhasil dihapus'
        ]);
    }
}