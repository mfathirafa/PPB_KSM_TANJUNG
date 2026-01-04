<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
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

        throw ValidationException::withMessages([
            'phone' => 'Format nomor WhatsApp tidak valid'
        ]);
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
                'role' => $request->input('role', 'customer'), // 🔒 DEFAULT ROLE
            ]
        );

        return response()->json([
            'message' => 'OTP sent',
            'otp' => $otp, // DEV ONLY
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
            'otp'   => 'required|string|size:6',
        ]);

        $phone = $this->normalizePhone($request->phone);

        $user = User::where('phone', $phone)->first();

        if (
            !$user ||
            !$user->otp ||
            $user->otp !== $request->otp ||
            !$user->otp_expires_at ||
            now()->gt($user->otp_expires_at)
        ) {
            return response()->json([
                'message' => 'OTP invalid or expired'
            ], 401);
        }

        // 🔒 OTP valid → hapus agar tidak bisa reuse
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