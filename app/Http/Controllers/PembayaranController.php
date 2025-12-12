<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Pembayaran;
use App\Models\Tagihan;
use App\Models\Pelanggan;

class PembayaranController extends Controller
{
    // ============================
    // CUSTOMER: Create payment
    // ============================
    public function create(Request $request)
    {
        $request->validate([
            'tagihan_id' => 'required|exists:tagihans,id_tagihan',
            'metode' => 'required|string'
        ]);

        $user = auth()->user();

        // Cegah double pending
        $existing = Pembayaran::where('tagihan_id', $request->tagihan_id)
            ->where('status', 'pending')
            ->first();

        if ($existing) return response()->json(['payment' => $existing]);

        $payment = Pembayaran::create([
            'tagihan_id' => $request->tagihan_id,
            'user_id' => $user->user_id,
            'nominal' => Tagihan::find($request->tagihan_id)->jumlah,
            'metode' => $request->metode,
            'status' => 'pending',
        ]);

        return response()->json(['payment' => $payment]);
    }

    // ============================
    // CUSTOMER: Upload Bukti
    // ============================
    public function uploadBukti(Request $request)
    {
        $request->validate([
            'pembayaran_id' => 'required|exists:pembayarans,id_pembayaran',
            'bukti' => 'required|file|mimes:jpg,jpeg,png,pdf'
        ]);

        $path = $request->file('bukti')->store('bukti_pembayaran', 'public');

        $payment = Pembayaran::find($request->pembayaran_id);
        $payment->bukti_path = $path;
        $payment->save();

        return response()->json(['message' => 'Uploaded', 'path' => $path]);
    }

    // ============================
    // CUSTOMER: Riwayat
    // ============================
    public function riwayatCustomer()
    {
        $user = auth()->user();

        $history = Pembayaran::with('tagihan')
            ->where('user_id', $user->user_id)
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function ($p) {

                $statusUI = match ($p->status) {
                    'pending' => 'Menunggu Pembayaran',
                    'approved' => 'Terkonfirmasi',
                    'rejected' => 'Ditolak',
                    default => 'Menunggu Pembayaran'
                };

                return [
                    'id' => $p->id_pembayaran,
                    'title' => 'Tagihan #' . $p->tagihan_id,
                    'date' => $p->created_at->format('d M Y, H:i'),
                    'status' => $statusUI,
                    'method' => $p->metode,
                    'amount' => $p->nominal,
                    'timestamp' => strtotime($p->created_at),
                ];
            });

        return response()->json(['history' => $history]);
    }

    // ============================
    // ADMIN: List pembayaran
    // ============================
    public function listAdmin()
    {
        $payments = Pembayaran::with('tagihan.pelanggan.user')
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json(['pembayaran' => $payments]);
    }

    // ============================
    // ADMIN: Approve
    // ============================
    public function approve($id)
    {
        $payment = Pembayaran::find($id);

        if (!$payment) return response()->json(['message' => 'Not found'], 404);

        $payment->status = 'approved';
        $payment->save();

        $tagihan = Tagihan::find($payment->tagihan_id);
        $tagihan->status = 'paid';
        $tagihan->save();

        return response()->json(['message' => 'Payment approved']);
    }

    // ============================
    // ADMIN: Reject
    // ============================
    public function reject($id)
    {
        $payment = Pembayaran::find($id);

        if (!$payment) return response()->json(['message' => 'Not found'], 404);

        $payment->status = 'rejected';
        $payment->save();

        return response()->json(['message' => 'Payment rejected']);
    }
}
