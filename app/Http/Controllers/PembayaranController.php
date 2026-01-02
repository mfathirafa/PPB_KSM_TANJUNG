<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Pembayaran;
use App\Models\Tagihan;
use Illuminate\Support\Facades\Storage;

class PembayaranController extends Controller
{
    /**
     * =========================
     * POST /pembayaran/create
     * =========================
     * Customer membuat pembayaran
     */
    public function create(Request $request)
    {
        $request->validate([
            'tagihan_id' => 'required|exists:tagihans,id',
            'metode'     => 'required|in:QRIS,TRANSFER,CASH',
        ]);

        $user = $request->user();

        if ($user->role !== 'customer') {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $tagihan = Tagihan::findOrFail($request->tagihan_id);

        // Cegah double payment pending
        $existing = Pembayaran::where('tagihan_id', $tagihan->id)
            ->where('status', 'pending')
            ->first();

        if ($existing) {
            return response()->json([
                'message' => 'Pembayaran sudah ada',
                'pembayaran' => $existing
            ]);
        }

        $pembayaran = Pembayaran::create([
            'user_id'       => $user->id,
            'tagihan_id'    => $tagihan->id,
            'tanggal'       => now(),
            'jumlah_bayar'  => $tagihan->jumlah,
            'metode'        => $request->metode,
            'status'        => 'pending',
        ]);

        return response()->json([
            'message' => 'Pembayaran dibuat',
            'pembayaran' => $pembayaran
        ]);
        NotifikasiController::createPembayaranNotif(
            $adminUserId,
            "Pembayaran baru menunggu verifikasi"
        );
    }

    /**
     * =========================
     * POST /pembayaran/upload-bukti
     * =========================
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
            ->firstOrFail();

        $path = $request->file('bukti')
            ->store('bukti_pembayaran', 'public');

        $pembayaran->update([
            'bukti_path' => $path
        ]);

        return response()->json([
            'message' => 'Bukti pembayaran diupload',
            'path' => $path
        ]);
    }

    /**
     * =========================
     * GET /pembayaran/riwayat
     * =========================
     */
    public function riwayatCustomer(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'customer') {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $data = Pembayaran::with('tagihan')
            ->where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function ($p) {
                return [
                    'id' => $p->id,
                    'tagihan_id' => $p->tagihan_id,
                    'tanggal' => $p->created_at->format('d M Y'),
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