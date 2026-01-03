<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class UserController extends Controller
{
    /**
     * GET /me
     */
    public function me(Request $request)
    {
        $user = $request->user()->load('pelanggan');

        return response()->json([
            'id' => $user->id,
            'name' => $user->name,
            'phone' => $user->phone,
            'role' => $user->role,

            'pelanggan' => $user->pelanggan ? [
                'id' => $user->pelanggan->id,
                'nama' => $user->pelanggan->nama,
                'alamat' => $user->pelanggan->alamat,
                'no_hp' => $user->pelanggan->no_hp,
            ] : null,
        ]);
    }
}
