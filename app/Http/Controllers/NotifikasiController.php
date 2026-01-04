<?php

namespace App\Http\Controllers;

use App\Models\Notifikasi;
use Illuminate\Http\Request;

class NotifikasiController extends Controller
{
    /* =====================================================
     * HELPER STATIC (DIPAKAI CONTROLLER LAIN)
     * ===================================================== */

    public static function createTagihanNotif(int $userId, string $pesan): void
    {
        Notifikasi::create([
            'user_id' => $userId,
            'pesan'   => $pesan,
            'tipe'    => 'tagihan',
            'dibaca'  => false,
        ]);
    }

    public static function createPembayaranNotif(int $userId, string $pesan): void
    {
        Notifikasi::create([
            'user_id' => $userId,
            'pesan'   => $pesan,
            'tipe'    => 'pembayaran',
            'dibaca'  => false,
        ]);
    }

    /* =====================================================
     * LIST NOTIFIKASI USER
     * ===================================================== */
    public function list(Request $request)
    {
        $user = $request->user();

        $data = Notifikasi::where('user_id', $user->id)
            ->orderByDesc('created_at')
            ->limit(10)
            ->get()
            ->map(function ($n) {
                return [
                    'id'       => $n->id,
                    'pesan'    => $n->pesan,
                    'tipe'     => $n->tipe,
                    'dibaca'   => $n->dibaca,
                    'tanggal'  => $n->created_at->format('Y-m-d H:i'),
                ];
            });

        return response()->json([
            'notifikasi' => $data
        ]);
    }

    /* =====================================================
     * MARK NOTIFIKASI SEBAGAI DIBACA
     * ===================================================== */
    public function markRead(Request $request, int $id)
    {
        $notif = Notifikasi::where('id', $id)
            ->where('user_id', $request->user()->id)
            ->firstOrFail();

        $notif->update(['dibaca' => true]);

        return response()->json([
            'message' => 'Notifikasi dibaca'
        ]);
    }
}