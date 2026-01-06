<?php

namespace App\Http\Controllers;

use App\Models\Pelanggan;
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
            'id'      => $user->id,
            'name'    => $user->name,
            'phone'   => $user->phone,
            'role'    => $user->role,

            'alamat'  => optional($user->pelanggan)->alamat,
        ]);
    }
}
