<?php

namespace App\Http\Controllers;

use App\Models\Notifikasi;
use Illuminate\Http\Request;

class NotifikasiController extends Controller
{
    /**
     * =========================
     * GET /notifikasi
     * =========================
     * List notifikasi user
     */
    public function list(Request $request)
    {
        $user = $request->user();

        $data = Notifikasi::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'notifikasi' => $data
        ]);
    }

    /**
     * =========================
     * PATCH /notifikasi/{id}/read
     * =========================
     */
    public function markRead($id, Request $request)
    {
        $user = $request->user();

        $notif = Notifikasi::where('id', $id)
            ->where('user_id', $user->id)
            ->firstOrFail();

        $notif->update([
            'status' => 'read'
        ]);

        return response()->json([
            'message' => 'Notifikasi dibaca'
        ]);
    }

    /**
     * =========================
     * INTERNAL: Notif tagihan
     * =========================
     */
    public static function createTagihanNotif($userId, $pesan)
    {
        Notifikasi::create([
            'user_id' => $userId,
            'pesan' => $pesan,
            'tipe' => 'tagihan',
            'channel' => 'system',
            'status' => 'sent',
            'sent_at' => now(),
        ]);
    }

    /**
     * =========================
     * INTERNAL: Notif pembayaran
     * =========================
     */
    public static function createPembayaranNotif($userId, $pesan)
    {
        Notifikasi::create([
            'user_id' => $userId,
            'pesan' => $pesan,
            'tipe' => 'pembayaran',
            'channel' => 'system',
            'status' => 'sent',
            'sent_at' => now(),
        ]);
    }
}