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
     * Normalize phone number to +62 format
     */
    protected function normalizePhone(string $phone): string
    {
        $phone = preg_replace('/[^0-9]/', '', $phone);

        if (str_starts_with($phone, '0')) {
            return '+62' . substr($phone, 1);
        }

        if (str_starts_with($phone, '62')) {
            return '+' . $phone;
        }

        if (str_starts_with($phone, '8')) {
            return '+62' . $phone;
        }

        throw new \Exception('Invalid phone number');
    }

    /**
     * GET /admin/pelanggan
     */
    public function index()
    {
        $pelanggans = Pelanggan::with('user')
            ->orderByDesc('created_at')
            ->get()
            ->map(function ($p) {
                return [
                    'id'         => $p->id,
                    'nama'       => $p->nama,
                    'phone'      => $p->no_hp,
                    'alamat'     => $p->alamat,
                    'user_id'    => $p->user_id,
                    'created_at'=> $p->created_at->format('Y-m-d'),
                ];
            });

        return response()->json($pelanggans);
    }

    /**
     * POST /admin/pelanggan
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
            $phone = $this->normalizePhone($request->phone);

            // Cari atau buat user
            $user = User::where('phone', $phone)->first();

            if (!$user) {
                $user = User::create([
                    'name'  => $request->nama,
                    'phone' => $phone,
                    'role'  => 'customer',
                ]);
            }

            // Cegah pelanggan ganda
            if (Pelanggan::where('user_id', $user->id)->exists()) {
                DB::rollBack();
                return response()->json([
                    'message' => 'User ini sudah terdaftar sebagai pelanggan'
                ], 422);
            }

            // Buat pelanggan
            $pelanggan = Pelanggan::create([
                'user_id' => $user->id,
                'nama'    => $request->nama,
                'alamat'  => $request->alamat,
                'no_hp'   => $phone,
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

        // Sinkronkan ke user
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

        // ⚠️ Hanya hapus pelanggan, user tetap ada
        $pelanggan->delete();

        return response()->json([
            'message' => 'Pelanggan berhasil dihapus'
        ]);
    }
}