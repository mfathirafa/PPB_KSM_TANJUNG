<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Pembayaran;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\NotifikasiController;

class PembayaranAdminController extends Controller
{
    /**
     * GET /admin/pembayaran
     */
    public function index()
    {
        return response()->json([
            'pembayaran' => Pembayaran::with([
                'user',
                'tagihan.pelanggan'
            ])
            ->orderByDesc('created_at')
            ->get()
        ]);
    }

    /**
     * PUT /admin/pembayaran/{id}/approve
     */
    public function approve($id, Request $request)
    {
        $admin = $request->user();

        if ($admin->role !== 'admin') {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        DB::beginTransaction();

        try {
            $p = Pembayaran::with('tagihan')->findOrFail($id);

            if ($p->status !== 'pending') {
                DB::rollBack();
                return response()->json([
                    'message' => 'Pembayaran sudah diproses'
                ], 400);
            }

            // ✅ Update pembayaran
            $p->update([
                'status'      => 'confirmed',
                'verified_by' => $admin->id,
            ]);

            // ✅ Update tagihan
            $p->tagihan->update([
                'status' => 'lunas'
            ]);

            // 🔔 Notifikasi ke customer
            NotifikasiController::createPembayaranNotif(
                $p->user_id,
                "Pembayaran Anda telah dikonfirmasi"
            );

            DB::commit();

            return response()->json([
                'message' => 'Pembayaran disetujui'
            ]);

        } catch (\Exception $e) {
            DB::rollBack();

            return response()->json([
                'message' => 'Gagal menyetujui pembayaran',
                'error'   => $e->getMessage()
            ], 500);
        }
    }

    /**
     * PUT /admin/pembayaran/{id}/reject
     */
    public function reject($id, Request $request)
    {
        $admin = $request->user();

        if ($admin->role !== 'admin') {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        DB::beginTransaction();

        try {
            $p = Pembayaran::with('tagihan')->findOrFail($id);

            if ($p->status !== 'pending') {
                DB::rollBack();
                return response()->json([
                    'message' => 'Pembayaran sudah diproses'
                ], 400);
            }

            // ❌ Reject pembayaran
            $p->update([
                'status' => 'rejected'
            ]);

            // 🔔 Notifikasi ke customer
            NotifikasiController::createPembayaranNotif(
                $p->user_id,
                "Pembayaran Anda ditolak"
            );

            DB::commit();

            return response()->json([
                'message' => 'Pembayaran ditolak'
            ]);

        } catch (\Exception $e) {
            DB::rollBack();

            return response()->json([
                'message' => 'Gagal menolak pembayaran',
                'error'   => $e->getMessage()
            ], 500);
        }
    }
}