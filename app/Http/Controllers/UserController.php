<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class UserController extends Controller
{
    /**
     * =========================
     * GET /me
     * =========================
     * Return authenticated user info
     */
    public function me(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'id' => $user->id,
            'name' => $user->name,
            'phone' => $user->phone,
            'role' => $user->role,

            // optional (future proof)
            'has_profile' => $user->pelanggan ? true : false,

            'created_at' => $user->created_at,
        ]);
    }
}