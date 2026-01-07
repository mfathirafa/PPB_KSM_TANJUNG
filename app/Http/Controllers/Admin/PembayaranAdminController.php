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
     * GET /api/admin/pembayaran
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
            ->map(function ($p) {
                return [
                    'id' => $p->id,
                    'nama' => $p->tagihan->pelanggan->nama ?? '-',
                    'tanggal' => $p->created_at->format('Y-m-d'),
                    'jumlah' => (int) $p->jumlah_bayar,
                    'metode' => $p->metode,
                    'status' => $p->status, // pending | confirmed | rejected
                ];
            })
        ]);
    }

    /**
     * PUT /api/admin/pembayaran/{id}/approve
     */
    public function approve($id, Request $request)
    {
        $admin = $request->user();

        if ($admin->role !== 'admin') {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        DB::beginTransaction();

        try {
            $p = Pembayaran::findOrFail($id);

            if ($p->status !== 'pending') {
                DB::rollBack();
                return response()->json(['message' => 'Pembayaran sudah diproses'], 400);
            }

            $p->update([
                'status' => 'confirmed',
                'verified_by' => $admin->id,
            ]);

            NotifikasiController::createPembayaranNotif(
                $p->user_id,
                'Pembayaran Anda telah dikonfirmasi'
            );

            DB::commit();

            return response()->json(['message' => 'Pembayaran disetujui']);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'message' => 'Gagal menyetujui pembayaran',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * PUT /api/admin/pembayaran/{id}/reject
     */
    public function reject($id, Request $request)
    {
        $admin = $request->user();

        if ($admin->role !== 'admin') {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        DB::beginTransaction();

        try {
            $p = Pembayaran::findOrFail($id);

            if ($p->status !== 'pending') {
                DB::rollBack();
                return response()->json(['message' => 'Pembayaran sudah diproses'], 400);
            }

            $p->update([
                'status' => 'rejected'
            ]);

            NotifikasiController::createPembayaranNotif(
                $p->user_id,
                'Pembayaran Anda ditolak'
            );

            DB::commit();

            return response()->json(['message' => 'Pembayaran ditolak']);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'message' => 'Gagal menolak pembayaran',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}