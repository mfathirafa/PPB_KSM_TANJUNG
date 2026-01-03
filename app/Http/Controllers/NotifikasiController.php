<?php

namespace App\Http\Controllers;

use App\Models\Notifikasi;
use App\Models\User;
use Illuminate\Http\Request;
use Carbon\Carbon;

class NotifikasiController extends Controller
{
    // ============================
    // KIRIM OTP
    // ============================
    public function sendOtp(Request $request)
    {
        $request->validate(['phone' => 'required']);

        $otp = rand(111111, 999999);

        // simpan ke tabel notifikasi
        Notifikasi::create([
            'user_id' => null, // belum punya user
            'isi_pesan' => "Kode OTP Anda: $otp",
            'tipe' => 'otp',
        ]);

        return response()->json([
            'message' => 'OTP generated',
            'otp' => $otp,
        ]);
    }


    // ============================
    // NOTIFIKASI TAGIHAN
    // ============================
    public function tagihan(Request $request)
    {
        $request->validate([
            'user_id' => 'required',
            'pesan' => 'required',
        ]);

        Notifikasi::create([
            'user_id' => $request->user_id,
            'isi_pesan' => $request->pesan,
            'tipe' => 'tagihan',
        ]);

        return response()->json(['message' => 'Notifikasi tagihan dikirim']);
    }


    // ============================
    // NOTIFIKASI PEMBAYARAN
    // ============================
    public function pembayaran(Request $request)
    {
        $request->validate([
            'user_id' => 'required',
            'pesan' => 'required',
        ]);

        Notifikasi::create([
            'user_id' => $request->user_id,
            'isi_pesan' => $request->pesan,
            'tipe' => 'pembayaran',
        ]);

        return response()->json(['message' => 'Notifikasi pembayaran dikirim']);
    }


    // ============================
    // LIST NOTIFIKASI USER
    // ============================
    public function list(Request $request)
    {
        $user = $request->user();

        $data = $user->notifikasis()
            ->orderByDesc('created_at')
            ->limit(5)
            ->get()
            ->map(function ($n) {
                return [
                    'id' => $n->id,
                    'pesan' => $n->pesan,
                    'dibaca' => $n->dibaca,
                    'tanggal' => $n->created_at->format('Y-m-d H:i'),
                ];
            });

        return response()->json([
            'notifikasi' => $data
        ]);
    }



    // ============================
    // MARK AS READ
    // ============================
    public function markRead($id)
    {
        $notif = Notifikasi::findOrFail($id);
        $notif->is_read = true;
        $notif->save();

        return response()->json(['message' => 'Notifikasi dibaca']);
    }
}
