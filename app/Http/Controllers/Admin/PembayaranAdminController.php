<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Pembayaran;
use App\Models\Tagihan;
use Illuminate\Http\Request;

class PembayaranAdminController extends Controller
{
    /**
     * List semua pembayaran
     */
    public function index()
    {
        $data = Pembayaran::with(['user', 'tagihan'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'pembayaran' => $data
        ]);
    }

    /**
     * Approve pembayaran
     */
    public function approve($id, Request $request)
    {
        $admin = $request->user();

        $pembayaran = Pembayaran::findOrFail($id);

        if ($pembayaran->status !== 'pending') {
            return response()->json([
                'message' => 'Pembayaran sudah diproses'
            ], 400);
        }

        $pembayaran->update([
            'status' => 'confirmed',
            'verified_by' => $admin->id,
        ]);

        // Update status tagihan
        $pembayaran->tagihan->update([
            'status' => 'lunas'
        ]);

        return response()->json([
            'message' => 'Pembayaran disetujui'
        ]);
        NotifikasiController::createPembayaranNotif(
            $pembayaran->user_id,
            "Pembayaran Anda telah dikonfirmasi"
        );
    }

    /**
     * Reject pembayaran
     */
    public function reject($id)
    {
        $pembayaran = Pembayaran::findOrFail($id);

        if ($pembayaran->status !== 'pending') {
            return response()->json([
                'message' => 'Pembayaran sudah diproses'
            ], 400);
        }

        $pembayaran->update([
            'status' => 'rejected'
        ]);

        return response()->json([
            'message' => 'Pembayaran ditolak'
        ]);
        NotifikasiController::createPembayaranNotif(
            $pembayaran->user_id,
            "Pembayaran Anda ditolak"
        );
    }
}