<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;

class AuthController extends Controller
{
    /**
     * Normalize phone number to +62 format
     */
    protected function normalizePhone(string $phone): string
    {
        // hapus semua selain angka
        $phone = preg_replace('/[^0-9]/', '', $phone);

        // 0812xxxx → +62812xxxx
        if (str_starts_with($phone, '0')) {
            return '+62' . substr($phone, 1);
        }

        // 62812xxxx → +62812xxxx
        if (str_starts_with($phone, '62')) {
            return '+' . $phone;
        }

        // 812xxxx → +62812xxxx
        if (str_starts_with($phone, '8')) {
            return '+62' . $phone;
        }

        return $phone;
    }

    /**
     * =========================
     * SEND OTP
     * =========================
     */
    public function sendOtp(Request $request)
    {
        $request->validate([
            'phone' => 'required|string',
        ]);

        $phone = $this->normalizePhone($request->phone);

        $otp = random_int(100000, 999999);

        User::updateOrCreate(
            ['phone' => $phone],
            [
                'otp' => (string) $otp,
                'otp_expires_at' => now()->addMinutes(3),
            ]
        );

        return response()->json([
            'message' => 'OTP sent',
            'otp' => $otp, // DEV ONLY — hapus di production
            'expires_in' => 180,
        ]);
    }

    /**
     * =========================
     * VERIFY OTP
     * =========================
     */
    public function verifyOtp(Request $request)
    {
        $request->validate([
            'phone' => 'required|string',
            'otp'   => 'required|string',
        ]);

        $phone = $this->normalizePhone($request->phone);

        $user = User::where('phone', $phone)->first();

        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        if (
            !$user->otp ||
            $user->otp !== $request->otp ||
            !$user->otp_expires_at ||
            now()->gt($user->otp_expires_at)
        ) {
            return response()->json(['message' => 'OTP invalid or expired'], 401);
        }

        // OTP valid → hapus
        $user->update([
            'otp' => null,
            'otp_expires_at' => null,
        ]);

        $token = $user->createToken('mobile')->plainTextToken;

        return response()->json([
            'message' => 'Login success',
            'token'   => $token,
            'role'    => $user->role,
            'user'    => [
                'id'    => $user->id,
                'name'  => $user->name,
                'phone' => $user->phone,
            ],
        ]);
    }

    /**
     * =========================
     * LOGOUT
     * =========================
     */
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json(['message' => 'Logged out']);
    }
}
