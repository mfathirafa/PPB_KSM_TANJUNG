<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    /**
     * =========================
     * SEND OTP (PUBLIC)
     * =========================
     * POST /send-otp
     */
    public function sendOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|string|min:10|max:20',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Invalid phone number',
                'errors' => $validator->errors(),
            ], 422);
        }

        $otp = rand(100000, 999999);

        $user = User::updateOrCreate(
            ['phone' => $request->phone],
            [
                'otp' => $otp,
                'otp_expires_at' => now()->addMinutes(3),
            ]
        );

        /**
         * NOTE:
         * Di production -> kirim ke WhatsApp API
         * Di PPB / demo -> return OTP ke response
         */
        return response()->json([
            'message' => 'OTP sent',
            'otp' => $otp,
            'expires_in' => 180,
        ]);
    }

    /**
     * =========================
     * VERIFY OTP (PUBLIC)
     * =========================
     * POST /verify-otp
     */
    public function verifyOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|string',
            'otp'   => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Invalid request',
                'errors' => $validator->errors(),
            ], 422);
        }

        $user = User::where('phone', $request->phone)->first();

        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        if (
            $user->otp !== $request->otp ||
            !$user->otp_expires_at ||
            Carbon::now()->gt($user->otp_expires_at)
        ) {
            return response()->json(['message' => 'OTP invalid or expired'], 401);
        }

        // OTP valid → hapus OTP
        $user->update([
            'otp' => null,
            'otp_expires_at' => null,
        ]);

        // Buat token Sanctum
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
     * =========================
     * LOGOUT (AUTH)
     * =========================
     * POST /logout
     */
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logged out',
        ]);
    }
}