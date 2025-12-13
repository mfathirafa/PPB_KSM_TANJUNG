<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Carbon\Carbon;

class AuthController extends Controller
{
    /**
     * Kirim OTP ke nomor WA
     */
    public function sendOtp(Request $request)
    {
        $request->validate([
            'phone' => 'required|string|min:10',
        ]);

        $otp = rand(100000, 999999);

        $user = User::firstOrCreate(
            ['phone' => $request->phone],
            [
                'name' => null,
                'role' => 'customer',
            ]
        );

        $user->otp = $otp;
        $user->otp_expires_at = Carbon::now()->addMinutes(3);
        $user->save();

        // ⚠️ sementara return OTP (nanti diganti WA gateway)
        return response()->json([
            'message' => 'OTP sent',
            'otp' => $otp,
            'expires_in' => 180,
        ]);
    }

    /**
     * Verifikasi OTP dan issue token Sanctum
     */
    public function verifyOtp(Request $request)
    {
        $request->validate([
            'phone' => 'required|string',
            'otp'   => 'required|string',
        ]);

        $user = User::where('phone', $request->phone)->first();

        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        if (
            $user->otp !== $request->otp ||
            Carbon::now()->greaterThan($user->otp_expires_at)
        ) {
            return response()->json(['message' => 'OTP invalid or expired'], 401);
        }

        // bersihkan OTP
        $user->otp = null;
        $user->otp_expires_at = null;
        $user->save();

        // issue token
        $token = $user->createToken('mobile')->plainTextToken;

        return response()->json([
            'message' => 'Login success',
            'token' => $token,
            'role' => $user->role,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'phone' => $user->phone,
            ],
        ]);
    }

    /**
     * Logout (revoke token)
     */
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logged out',
        ]);
    }
}
