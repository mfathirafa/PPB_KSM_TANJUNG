<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| AUTH / OTP (PUBLIC)
|--------------------------------------------------------------------------
*/
Route::post('/send-otp', [AuthController::class, 'sendOtp']);
Route::post('/verify-otp', [AuthController::class, 'verifyOtp']);


/*
|--------------------------------------------------------------------------
| CUSTOMER AREA (AUTH REQUIRED)
|--------------------------------------------------------------------------
*/
Route::middleware('auth:sanctum')->group(function () {

    // Profile
    Route::get('/me', [UserController::class, 'me']);

    // Tagihan user
    Route::get('/tagihan', [TagihanController::class, 'getUserTagihan']);

    // Pembayaran user
    Route::post('/pembayaran/{tagihan_id}', [PembayaranController::class, 'bayar']);
    Route::get('/pembayaran/riwayat', [PembayaranController::class, 'riwayat']);

    // Logout
    Route::post('/logout', [AuthController::class, 'logout']);
});


/*
|--------------------------------------------------------------------------
| ADMIN AREA (AUTH + ADMIN MIDDLEWARE)
|--------------------------------------------------------------------------
*/
Route::middleware(['auth:sanctum', 'admin'])->group(function () {

    // ------------------ Pelanggan ------------------
    Route::get('/admin/pelanggan', [PelangganController::class, 'index']);
    Route::post('/admin/pelanggan', [PelangganController::class, 'store']);
    Route::get('/admin/pelanggan/{id}', [PelangganController::class, 'show']);
    Route::put('/admin/pelanggan/{id}', [PelangganController::class, 'update']);
    Route::delete('/admin/pelanggan/{id}', [PelangganController::class, 'destroy']);

    // ------------------ Tagihan ------------------
    Route::get('/admin/tagihan', [TagihanAdminController::class, 'index']);
    Route::post('/admin/tagihan', [TagihanAdminController::class, 'store']);
    Route::put('/admin/tagihan/{id}', [TagihanAdminController::class, 'update']);
    Route::delete('/admin/tagihan/{id}', [TagihanAdminController::class, 'destroy']);

    // ------------------ Pembayaran ------------------
    Route::get('/admin/pembayaran', [PembayaranAdminController::class, 'index']);
    Route::put('/admin/pembayaran/{id}/approve', [PembayaranAdminController::class, 'approve']);
    Route::put('/admin/pembayaran/{id}/reject', [PembayaranAdminController::class, 'reject']);

    // ------------------ Laporan ------------------
    Route::get('/admin/laporan/summary', [LaporanController::class, 'summary']);
    Route::get('/admin/laporan/transaksi', [LaporanController::class, 'transaksi']);

    // ------------------ Settings ------------------
    Route::get('/admin/settings', [SettingsController::class, 'show']);
    Route::put('/admin/settings', [SettingsController::class, 'update']);
    Route::post('/admin/settings/regenerate-jwt', [SettingsController::class, 'regenerateJwt']);
});
