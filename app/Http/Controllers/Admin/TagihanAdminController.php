<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Tagihan;
use App\Models\Pelanggan;
use App\Http\Controllers\NotifikasiController;
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
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function ($t) {
                return [
                    'id'          => $t->id,
                    'pelanggan'   => $t->pelanggan->nama,
                    'phone'       => $t->pelanggan->no_hp,
                    'tanggal'     => $t->tanggal,
                    'jumlah'      => $t->jumlah,
                    'status'      => $t->status,
                    'created_at'  => $t->created_at->format('Y-m-d'),
                ];
            });

        return response()->json($tagihans);
    }

    /**
     * POST /admin/tagihan
     * Admin membuat tagihan baru
     */
    public function store(Request $request)
    {
        $request->validate([
            'pelanggan_id' => 'required|exists:pelanggans,id',
            'tanggal'      => 'required|date',
            'jumlah'       => 'required|integer|min:1000',
        ]);

        $pelanggan = Pelanggan::with('user')->find($request->pelanggan_id);

        if (!$pelanggan) {
            return response()->json(['message' => 'Pelanggan tidak ditemukan'], 404);
        }

        // 1️⃣ Buat tagihan
        $tagihan = Tagihan::create([
            'pelanggan_id' => $pelanggan->id,
            'tanggal'      => $request->tanggal,
            'jumlah'       => $request->jumlah,
            'status'       => 'belum_dibayar',
        ]);

        // 2️⃣ KIRIM NOTIFIKASI (INI PENTING)
        // ⬇️ Ini adalah IMPLEMENTASI NYATA FLOW BISNIS
        NotifikasiController::create([
            'user_id' => $pelanggan->user_id,
            'pesan'   => "Tagihan baru sebesar Rp " . number_format($tagihan->jumlah) .
                         " telah dibuat. Jatuh tempo: " .
                         Carbon::parse($tagihan->tanggal)->format('d M Y'),
            'tipe'    => 'tagihan',
            'channel' => 'whatsapp',
            'status'  => 'pending',
        ]);

        return response()->json([
            'message' => 'Tagihan berhasil dibuat',
            'tagihan' => $tagihan
        ], 201);
    }

    /**
     * GET /admin/tagihan/{id}
     */
    public function show($id)
    {
        $tagihan = Tagihan::with('pelanggan.user')->find($id);

        if (!$tagihan) {
            return response()->json(['message' => 'Tagihan tidak ditemukan'], 404);
        }

        return response()->json($tagihan);
    }

    /**
     * PUT /admin/tagihan/{id}
     */
    public function update(Request $request, $id)
    {
        $tagihan = Tagihan::find($id);

        if (!$tagihan) {
            return response()->json(['message' => 'Tagihan tidak ditemukan'], 404);
        }

        $request->validate([
            'tanggal' => 'required|date',
            'jumlah'  => 'required|integer|min:1000',
            'status'  => 'required|in:belum_dibayar,dibayar,lunas',
        ]);

        $tagihan->update($request->only(['tanggal', 'jumlah', 'status']));

        return response()->json([
            'message' => 'Tagihan berhasil diperbarui'
        ]);
    }

    /**
     * DELETE /admin/tagihan/{id}
     */
    public function destroy($id)
    {
        $tagihan = Tagihan::find($id);

        if (!$tagihan) {
            return response()->json(['message' => 'Tagihan tidak ditemukan'], 404);
        }

        $tagihan->delete();

        return response()->json([
            'message' => 'Tagihan berhasil dihapus'
        ]);
    }
}