<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class AuthController extends Controller
{
    public function sendOtp(Request $request)
    {
        // validasi nomor
        // generate OTP
        // simpan ke DB (otps)
        // return success + otp dummy
    }

    public function verifyOtp(Request $request)
    {
        // cek OTP
        // login/create user
        // buat Sanctum token
        // return user + token
    }

    public function logout(Request $request)
    {
        // hapus token login
        return response()->json(['message' => 'Logged out']);
    }
}
