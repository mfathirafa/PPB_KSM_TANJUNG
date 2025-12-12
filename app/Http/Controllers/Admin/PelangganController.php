<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Pelanggan;
use App\Models\User;


class PelangganController extends Controller
{
    public function index()
    {
        $data = Pelanggan::with('user')->get();

        return response()->json([
            'pelanggan' => $data
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name'   => 'required',
            'phone'  => 'required|unique:users,phone',
            'alamat' => 'nullable|string',
        ]);

        // 1) BUAT USER
        $user = User::create([
            'name'  => $request->name,
            'phone' => $request->phone,
            'role'  => 'customer'
        ]);

        // 2) BUAT PELANGGAN
        $pelanggan = Pelanggan::create([
            'user_id' => $user->user_id,
            'alamat'  => $request->alamat,
            'no_hp'   => $request->phone,
        ]);

        return response()->json([
            'message'   => 'Pelanggan created',
            'pelanggan' => $pelanggan->load('user')
        ], 201);
    }

    public function show($id)
    {
        $data = Pelanggan::with('user')->find($id);

        if (!$data) {
            return response()->json(['message' => 'Not found'], 404);
        }

        return response()->json(['pelanggan' => $data]);
    }

    public function update(Request $request, $id)
    {
        $pelanggan = Pelanggan::with('user')->find($id);

        if (!$pelanggan) {
            return response()->json(['message' => 'Not found'], 404);
        }

        $request->validate([
            'name'  => 'required',
            'phone' => 'required|unique:users,phone,' . $pelanggan->user_id . ',user_id',
            'alamat' => 'nullable|string'
        ]);

        // UPDATE USER
        $pelanggan->user->update([
            'name'  => $request->name,
            'phone' => $request->phone
        ]);

        // UPDATE PELANGGAN
        $pelanggan->update([
            'alamat' => $request->alamat,
            'no_hp'  => $request->phone
        ]);

        return response()->json(['message' => 'Updated']);
    }

    public function destroy($id)
    {
        $pelanggan = Pelanggan::find($id);

        if (!$pelanggan) {
            return response()->json(['message' => 'Not found'], 404);
        }

        // Delete user → cascade hapus pelanggan otomatis
        $pelanggan->user->delete();

        return response()->json(['message' => 'Deleted']);
    }
}
