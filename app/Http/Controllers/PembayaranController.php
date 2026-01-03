<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Pembayaran;
use App\Models\Tagihan;
use App\Models\User;
use App\Http\Controllers\NotifikasiController;

class PembayaranController extends Controller
{
    /**
     * POST /pembayaran/create
     * Customer membuat pembayaran
     */
    public function store(Request $request)
    {
        $request->validate([
            'tagihan_id' => 'required|exists:tagihans,id',
            'metode'     => 'required|in:QRIS,TRANSFER,CASH',
        ]);

        $user = $request->user();

        // 🔒 Role check
        if ($user->role !== 'customer') {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        // 🔒 Ambil tagihan & pastikan milik customer
        $tagihan = Tagihan::where('id', $request->tagihan_id)
            ->where('pelanggan_id', optional($user->pelanggan)->id)
            ->firstOrFail();

        // 🔒 Cegah double payment (pending / paid)
        $existing = Pembayaran::where('tagihan_id', $tagihan->id)
            ->whereIn('status', ['pending', 'approved'])
            ->first();

        if ($existing) {
            return response()->json([
                'message' => 'Pembayaran sudah ada',
                'pembayaran' => $existing
            ], 409);
        }

        // ✅ Buat pembayaran
        $pembayaran = Pembayaran::create([
            'user_id'      => $user->id,
            'tagihan_id'   => $tagihan->id,
            'tanggal'      => now(),
            'jumlah_bayar' => $tagihan->jumlah,
            'metode'       => $request->metode,
            'status'       => 'pending',
        ]);

        // 🔔 Kirim notifikasi ke admin
        $adminIds = User::where('role', 'admin')->pluck('id');
        foreach ($adminIds as $adminId) {
            NotifikasiController::createPembayaranNotif(
                $adminId,
                "Pembayaran baru menunggu verifikasi"
            );
        }

        return response()->json([
            'message' => 'Pembayaran berhasil dibuat',
            'pembayaran' => $pembayaran
        ], 201);
    }

    /**
     * POST /pembayaran/upload-bukti
     */
    public function uploadBukti(Request $request)
    {
        $request->validate([
            'pembayaran_id' => 'required|exists:pembayarans,id',
            'bukti' => 'required|file|mimes:jpg,jpeg,png,pdf|max:2048'
        ]);

        $user = $request->user();

        $pembayaran = Pembayaran::where('id', $request->pembayaran_id)
            ->where('user_id', $user->id)
            ->where('status', 'pending')
            ->firstOrFail();

        $path = $request->file('bukti')
            ->store('bukti_pembayaran', 'public');

        $pembayaran->update([
            'bukti_path' => $path
        ]);

        return response()->json([
            'message' => 'Bukti pembayaran berhasil diupload',
            'path' => $path
        ]);
    }

    /**
     * GET /pembayaran/riwayat
     */
    public function riwayatCustomer(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'customer') {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $data = Pembayaran::with('tagihan')
            ->where('user_id', $user->id)
            ->orderByDesc('created_at')
            ->get()
            ->map(function ($p) {
                return [
                    'id' => $p->id,
                    'tagihan_id' => $p->tagihan_id,
                    'tanggal' => $p->created_at->format('Y-m-d H:i'),
                    'jumlah' => $p->jumlah_bayar,
                    'metode' => $p->metode,
                    'status' => $p->status,
                ];
            });

        return response()->json([
            'riwayat' => $data
        ]);
    }
}