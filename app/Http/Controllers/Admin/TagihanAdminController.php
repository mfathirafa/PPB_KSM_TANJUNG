<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Tagihan;
use App\Models\Pelanggan;

class TagihanController extends Controller
{
    public function index()
    {
        $data = Tagihan::with(['pelanggan.user'])
            ->orderBy('tanggal', 'desc')
            ->get();

        return response()->json([
            'tagihan' => $data
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'pelanggan_id' => 'required|exists:pelanggans,id_pelanggan',
            'jumlah'       => 'required|integer|min:1',
            'tanggal'      => 'required|date',
        ]);

        $tagihan = Tagihan::create([
            'pelanggan_id' => $request->pelanggan_id,
            'jumlah'       => $request->jumlah,
            'tanggal'      => $request->tanggal,
            'status'       => 'unpaid',
        ]);

        return response()->json([
            'message' => 'Tagihan created',
            'tagihan' => $tagihan
        ], 201);
    }

    public function show($id)
    {
        $tagihan = Tagihan::with('pelanggan.user')->find($id);

        if (!$tagihan) {
            return response()->json(['message' => 'Not found'], 404);
        }

        return response()->json(['tagihan' => $tagihan]);
    }

    public function update(Request $request, $id)
    {
        $tagihan = Tagihan::find($id);

        if (!$tagihan) return response()->json(['message' => 'Not found'], 404);

        $request->validate([
            'jumlah'       => 'integer|min:1',
            'tanggal'      => 'date',
            'status'       => 'in:unpaid,paid,pending'
        ]);

        $tagihan->update($request->only(['jumlah', 'tanggal', 'status']));

        return response()->json(['message' => 'Updated']);
    }

    public function destroy($id)
    {
        $tagihan = Tagihan::find($id);

        if (!$tagihan) return response()->json(['message' => 'Not found'], 404);

        $tagihan->delete();

        return response()->json(['message' => 'Deleted']);
    }
}
