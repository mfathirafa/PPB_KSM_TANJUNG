<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Pelanggan;
use Illuminate\Support\Facades\DB;

class PelangganController extends Controller
{
    /**
     * GET /admin/pelanggan
     * List semua pelanggan
     */
    public function index()
    {
        $pelanggans = Pelanggan::with('user')
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function ($p) {
                return [
                    'id'        => $p->id,
                    'nama'      => $p->nama,
                    'phone'     => $p->no_hp,
                    'alamat'    => $p->alamat,
                    'user_id'   => $p->user_id,
                    'created_at' => $p->created_at->format('Y-m-d'),
                ];
            });

        return response()->json($pelanggans);
    }

    /**
     * POST /admin/pelanggan
     * Admin membuat pelanggan baru
     */
    public function store(Request $request)
    {
        $request->validate([
            'nama'   => 'required|string|max:200',
            'phone'  => 'required|string|max:20',
            'alamat' => 'required|string',
        ]);

        DB::beginTransaction();

        try {
            // 1️⃣ Buat user customer
            // 1️⃣ Cari user berdasarkan phone
        $user = User::where('phone', $request->phone)->first();

        // 2️⃣ Kalau belum ada → buat user
        if (!$user) {
            $user = User::create([
                'name'  => $request->nama,
                'phone' => $request->phone,
                'role'  => 'customer',
            ]);
        }

        // 3️⃣ Cegah pelanggan ganda
        if (Pelanggan::where('user_id', $user->id)->exists()) {
            DB::rollBack();
            return response()->json([
                'message' => 'User ini sudah menjadi pelanggan'
            ], 422);
        }

        // 4️⃣ Jadikan pelanggan
        $pelanggan = Pelanggan::create([
            'user_id' => $user->id,
            'nama'    => $request->nama,
            'alamat'  => $request->alamat,
            'no_hp'   => $request->phone,
        ]);
            DB::commit();

            return response()->json([
                'message'   => 'Pelanggan berhasil dibuat',
                'pelanggan' => $pelanggan
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();

            return response()->json([
                'message' => 'Gagal membuat pelanggan',
                'error'   => $e->getMessage()
            ], 500);
        }
    }

    /**
     * GET /admin/pelanggan/{id}
     */
    public function show($id)
    {
        $pelanggan = Pelanggan::with('user')->find($id);

        if (!$pelanggan) {
            return response()->json(['message' => 'Pelanggan tidak ditemukan'], 404);
        }

        return response()->json($pelanggan);
    }

    /**
     * PUT /admin/pelanggan/{id}
     */
    public function update(Request $request, $id)
    {
        $pelanggan = Pelanggan::find($id);

        if (!$pelanggan) {
            return response()->json(['message' => 'Pelanggan tidak ditemukan'], 404);
        }

        $request->validate([
            'nama'   => 'required|string|max:200',
            'alamat' => 'required|string',
        ]);

        $pelanggan->update([
            'nama'   => $request->nama,
            'alamat' => $request->alamat,
        ]);

        // sync ke user
        $pelanggan->user->update([
            'name' => $request->nama,
        ]);

        return response()->json([
            'message' => 'Pelanggan berhasil diperbarui'
        ]);
    }

    /**
     * DELETE /admin/pelanggan/{id}
     */
    public function destroy($id)
    {
        $pelanggan = Pelanggan::find($id);

        if (!$pelanggan) {
            return response()->json(['message' => 'Pelanggan tidak ditemukan'], 404);
        }

        // hapus user → cascade ke pelanggan
        $pelanggan->delete();

        return response()->json([
            'message' => 'Pelanggan berhasil dihapus'
        ]);
    }
}