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

        $tagihans = Tagihan::with('pelanggan.user')
            ->orderBy('tanggal', 'desc')
            ->get()
            ->map(function ($t) {
                return [
                    'id'      => $t->id,
                    'nama'    => $t->pelanggan->nama ?? '-',
                    'jumlah'  => $t->jumlah,
                    'status'  => $t->status,
                    'tanggal' => $t->tanggal->format('Y-m-d'),
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
            'status'       => 'belum_dibayar',
        ]);

        // 🔔 Notifikasi ke customer
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
    public function show(Request $request, $id)
    {
        $this->ensureAdmin($request);

        return response()->json(
            Tagihan::with('pelanggan.user')->findOrFail($id)
        );
    }

    /**
     * PUT /admin/tagihan/{id}
     */
    public function update(Request $request, $id)
    {
        $this->ensureAdmin($request);

        $tagihan = Tagihan::findOrFail($id);

        $request->validate([
            'jumlah'  => 'required|integer|min:1000',
            'tanggal' => 'required|date',
            'status'  => 'required|in:belum_dibayar,pending,lunas',
        ]);

        $tagihan->update(
            $request->only('jumlah', 'tanggal', 'status')
        );

        return response()->json([
            'message' => 'Tagihan berhasil diperbarui'
        ]);
    }

    /**
     * DELETE /admin/tagihan/{id}
     */
    public function destroy(Request $request, $id)
    {
        $this->ensureAdmin($request);

        // 🔒 Cegah hapus jika ada pembayaran
        $hasPayment = Pembayaran::where('tagihan_id', $id)->exists();

        if ($hasPayment) {
            return response()->json([
                'message' => 'Tagihan tidak dapat dihapus karena memiliki pembayaran'
            ], 409);
        }

        Tagihan::findOrFail($id)->delete();

        return response()->json([
            'message' => 'Tagihan berhasil dihapus'
        ]);
    }

    /**
     * ======================
     * GUARD
     * ======================
     */
    private function ensureAdmin(Request $request): void
    {
        if ($request->user()->role !== 'admin') {
            abort(403, 'Forbidden');
        }
    }
}