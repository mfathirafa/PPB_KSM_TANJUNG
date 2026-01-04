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
     * ============================
     * CUSTOMER MEMBUAT PEMBAYARAN
     * POST /pembayaran/create
     * ============================
     */
    public function store(Request $request)
    {
        $request->validate([
            'tagihan_id' => 'required|exists:tagihans,id',
            'metode'     => 'required|in:QRIS,TRANSFER,CASH',
        ]);

        $user = $request->user();

        if ($user->role !== 'customer' || !$user->pelanggan) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        // Pastikan tagihan milik customer
        $tagihan = Tagihan::where('id', $request->tagihan_id)
            ->where('pelanggan_id', $user->pelanggan->id)
            ->firstOrFail();

        // ❗ BLOK JIKA ADA PEMBAYARAN PENDING
        $pending = Pembayaran::where('tagihan_id', $tagihan->id)
            ->where('status', 'pending')
            ->first();

        if ($pending) {
            return response()->json([
                'message' => 'Masih ada pembayaran menunggu verifikasi'
            ], 409);
        }

        // ❗ CEGAH BAYAR TAGIHAN YANG SUDAH LUNAS
        $confirmed = Pembayaran::where('tagihan_id', $tagihan->id)
            ->where('status', 'confirmed')
            ->exists();

        if ($confirmed) {
            return response()->json([
                'message' => 'Tagihan sudah lunas'
            ], 409);
        }

        // ✅ BUAT PEMBAYARAN BARU
        $pembayaran = Pembayaran::create([
            'user_id'      => $user->id,
            'tagihan_id'   => $tagihan->id,
            'tanggal'      => now(),
            'jumlah_bayar' => $tagihan->jumlah,
            'metode'       => $request->metode,
            'status'       => 'pending',
        ]);

        // 🔔 NOTIFIKASI KE ADMIN
        $adminIds = User::where('role', 'admin')->pluck('id');
        foreach ($adminIds as $adminId) {
            NotifikasiController::createPembayaranNotif(
                $adminId,
                'Pembayaran baru menunggu verifikasi'
            );
        }

        return response()->json([
            'message' => 'Pembayaran berhasil dibuat',
            'status'  => 'menunggu_verifikasi',
            'pembayaran_id' => $pembayaran->id
        ], 201);
    }

    /**
     * ============================
     * UPLOAD BUKTI PEMBAYARAN
     * POST /pembayaran/upload-bukti
     * ============================
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
            'message' => 'Bukti pembayaran berhasil diupload'
        ]);
    }

    /**
     * ============================
     * RIWAYAT PEMBAYARAN CUSTOMER
     * GET /pembayaran/riwayat
     * ============================
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
                    'status' => match ($p->status) {
                        'pending'   => 'menunggu_verifikasi',
                        'confirmed' => 'lunas',
                        'rejected'  => 'ditolak',
                        default     => $p->status,
                    },
                ];
            });

        return response()->json(['riwayat' => $data]);
    }
}