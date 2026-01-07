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
     * =========================
     * NORMALIZE PHONE (+62)
     * =========================
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

        throw new \Exception('Format nomor tidak valid');
    }

    /**
     * =====================================================
     * GET /api/admin/pelanggan
     * MASTER DATA PELANGGAN (FINAL & BENAR)
     * =====================================================
     * - SEMUA pelanggan muncul
     * - TANPA syarat tagihan
     * - TANPA syarat pembayaran
     * - Status pelanggan ≠ status pembayaran
     */
    public function index()
    {
        $pelanggans = Pelanggan::with([
            'user',
            'tagihans.pembayarans'
        ])
        ->orderByDesc('created_at')
        ->get()
        ->map(function ($p) {

            // Ambil pembayaran terakhir (jika ada)
            $lastPayment = $p->tagihans
                ->flatMap->pembayarans
                ->sortByDesc('created_at')
                ->first();

            return [
                'id'           => $p->id,
                'nama'         => $p->nama,
                'phone'        => $p->no_hp,
                'alamat'       => $p->alamat,

                // ✅ STATUS PELANGGAN (MASTER DATA)
                'status'       => 'aktif',

                // Info tambahan (opsional)
                'last_payment' => $lastPayment
                    ? $lastPayment->created_at->format('Y-m-d')
                    : null,
            ];
        });

        return response()->json([
            'pelanggan' => $pelanggans
        ]);
    }

    /**
     * =========================
     * POST /api/admin/pelanggan
     * =========================
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

            // Cari / buat user
            $user = User::firstOrCreate(
                ['phone' => $phone],
                [
                    'name' => $request->nama,
                    'role' => 'customer',
                ]
            );

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
     * =========================
     * PUT /api/admin/pelanggan/{id}
     * =========================
     */
    public function update(Request $request, $id)
    {
        $request->validate([
            'nama'   => 'required|string|max:200',
            'alamat' => 'required|string',
        ]);

        $pelanggan = Pelanggan::with('user')->find($id);

        if (!$pelanggan) {
            return response()->json([
                'message' => 'Pelanggan tidak ditemukan'
            ], 404);
        }

        $pelanggan->update([
            'nama'   => $request->nama,
            'alamat' => $request->alamat,
        ]);

        if ($pelanggan->user) {
            $pelanggan->user->update([
                'name' => $request->nama
            ]);
        }

        return response()->json([
            'message' => 'Pelanggan berhasil diperbarui'
        ]);
    }

    /**
     * =========================
     * DELETE /api/admin/pelanggan/{id}
     * =========================
     */
    public function destroy($id)
    {
        $pelanggan = Pelanggan::find($id);

        if (!$pelanggan) {
            return response()->json([
                'message' => 'Pelanggan tidak ditemukan'
            ], 404);
        }

        $pelanggan->delete();

        return response()->json([
            'message' => 'Pelanggan berhasil dihapus'
        ]);
    }
}