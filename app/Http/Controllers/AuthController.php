<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class AuthController extends Controller
{
  public function sendOtp(Request $request)
  {
    $request->validate([
      'phone' => 'required'
    ]);

    $otp = rand(100000, 999999);

    session(['otp' => $otp, 'phone' => $request->phone]);

    return response()->json([
      'success' => true,
      'message' => 'OTP terkirim (dummy)',
      'otp' => $otp // buat tes dulu di flutter
    ]);
  }
  
  public function verifyOtp(Request $request)
  {
    $request->validate([
      'phone' => 'required',
      'otp' => 'required'
    ]);

    if (
      session('phone') == $request->phone &&
      session('otp') == $request->otp
    ) {
      return response()->json([
        'success' => true,
        'message' => 'OTP valid!'
      ]);
    }
    return response()->json([
      'success' => false,
      'message' => 'OTP salah atau tidak cocok'
    ], 400);
  }
}

