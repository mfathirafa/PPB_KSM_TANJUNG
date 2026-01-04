<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Pembayaran;
use App\Models\Tagihan;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class PembayaranController extends Controller
{
    /**
     * =====================================================
     * CUSTOMER MEMBUAT PEMBAYARAN
     * POST /pembayaran/create
     * =====================================================
     */
    public function store(Request $request)
    {
        $request->validate([
            'tagihan_id' => 'required|exists:tagihans,id',
            'metode'     => 'required|in:QRIS,TRANSFER,CASH',
        ]);

        $user = $request->user();

        // 🔒 ROLE & RELASI CHECK
        if ($user->role !== 'customer' || !$user->pelanggan) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        // 🔒 PASTIKAN TAGIHAN MILIK CUSTOMER
        $tagihan = Tagihan::where('id', $request->tagihan_id)
            ->where('pelanggan_id', $user->pelanggan->id)
            ->firstOrFail();

        // 🔥 BLOK JIKA ADA PEMBAYARAN AKTIF (PENDING / CONFIRMED)
        $exists = Pembayaran::where('tagihan_id', $tagihan->id)
            ->whereIn('status', ['pending', 'confirmed'])
            ->exists();

        if ($exists) {
            return response()->json([
                'message' => 'Pembayaran masih diproses atau tagihan sudah lunas'
            ], 409);
        }

        DB::beginTransaction();

        try {
            // ✅ BUAT PEMBAYARAN BARU
            $pembayaran = Pembayaran::create([
                'user_id'      => $user->id,
                'tagihan_id'   => $tagihan->id,
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

            DB::commit();

            return response()->json([
                'message'        => 'Pembayaran berhasil dibuat',
                'pembayaran_id'  => $pembayaran->id,
                'pembayaran_status' => 'pending'
            ], 201);

        } catch (\Throwable $e) {
            DB::rollBack();
            return response()->json([
                'message' => 'Gagal membuat pembayaran'
            ], 500);
        }
    }

    /**
     * =====================================================
     * UPLOAD BUKTI PEMBAYARAN
     * POST /pembayaran/upload-bukti
     * =====================================================
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
     * =====================================================
     * RIWAYAT PEMBAYARAN CUSTOMER
     * GET /pembayaran/riwayat
     * =====================================================
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
                    'id'          => $p->id,
                    'tagihan_id'  => $p->tagihan_id,
                    'tanggal'     => $p->created_at->format('Y-m-d H:i'),
                    'jumlah'      => $p->jumlah_bayar,
                    'metode'      => $p->metode,
                    'status'      => $p->status, // pending | confirmed | rejected
                    'status_label'=> match ($p->status) {
                        'pending'   => 'Menunggu Verifikasi',
                        'confirmed' => 'Lunas',
                        'rejected'  => 'Ditolak',
                        default     => '-',
                    },
                ];
            });

        return response()->json(['riwayat' => $data]);
    }
}