<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class PembayaranAdminController extends Controller
{
    public function listAdmin()
    {
        $payments = Pembayaran::with('tagihan.pelanggan.user')
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json(['pembayaran' => $payments]);
    }


    public function approve($id)
    {
        $payment = Pembayaran::find($id);

        if (!$payment) return response()->json(['message' => 'Not found'], 404);

        $payment->status = 'approved';
        $payment->save();

        // Update status tagihan
        $tagihan = Tagihan::find($payment->tagihan_id);
        $tagihan->status = 'paid';
        $tagihan->save();

        return response()->json(['message' => 'Payment approved']);
    }


    public function reject($id)
    {
        $payment = Pembayaran::find($id);

        if (!$payment) return response()->json(['message' => 'Not found'], 404);

        $payment->status = 'rejected';
        $payment->save();

        return response()->json(['message' => 'Payment rejected']);
    }

}
