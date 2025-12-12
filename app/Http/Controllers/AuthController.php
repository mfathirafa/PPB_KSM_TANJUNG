<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Pelanggan;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class AuthController extends Controller
{
    // ================================
    // SEND OTP
    // ================================
    public function sendOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|string|min:10'
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Invalid phone'], 422);
        }

        $phone = $request->phone;

        // Generate OTP
        $otp = rand(100000, 999999);
        $expires = Carbon::now()->addMinutes(5);

        // Find or create user
        $user = User::firstOrCreate(
            ['phone' => $phone],
            [
                'name' => null,
                'role' => 'customer',
            ]
        );

        // Save OTP
        $user->otp = $otp;
        $user->otp_expires_at = $expires;
        $user->save();

        return response()->json([
            'message' => 'OTP sent (dummy)',
            'otp' => $otp, // For demo. Real world: send via WhatsApp API.
        ]);
    }

    // ================================
    // VERIFY OTP
    // ================================
    public function verifyOtp(Request $request)
    {
        $request->validate([
            'phone' => 'required',
            'otp' => 'required'
        ]);

        $user = User::where('phone', $request->phone)->first();

        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        if (
            $user->otp != $request->otp ||
            Carbon::now()->greaterThan($user->otp_expires_at)
        ) {
            return response()->json(['message' => 'Invalid OTP'], 422);
        }

        // Clear OTP (optional)
        $user->otp = null;
        $user->otp_expires_at = null;
        $user->save();

        // Sanctum token
        $token = $user->createToken('auth-token')->plainTextToken;

        return response()->json([
            'message' => 'OTP verified',
            'token' => $token,
            'user' => $user
        ]);
    }
}
