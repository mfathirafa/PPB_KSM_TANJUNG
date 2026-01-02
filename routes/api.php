<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Schedule;


/*
|--------------------------------------------------------------------------
| AUTH CONTROLLERS
|--------------------------------------------------------------------------
*/
use App\Http\Controllers\AuthController;

/*
|--------------------------------------------------------------------------
| CUSTOMER CONTROLLERS
|--------------------------------------------------------------------------
*/
use App\Http\Controllers\UserController;
use App\Http\Controllers\CustomerTagihanController;
use App\Http\Controllers\PembayaranController;
use App\Http\Controllers\NotifikasiController;
use App\Http\Controllers\LaporanKeuanganController;



/*
|--------------------------------------------------------------------------
| ADMIN CONTROLLERS
|--------------------------------------------------------------------------
*/
use App\Http\Controllers\Admin\PelangganController;
use App\Http\Controllers\Admin\TagihanAdminController;
use App\Http\Controllers\Admin\PembayaranAdminController;
use App\Http\Controllers\Admin\SettingsController;
use App\Http\Controllers\Admin\LaporanController;
use App\Http\Controllers\Admin\DashboardAdminController;


Schedule::command('report:generate-monthly')
    ->monthlyOn(1, '00:05');


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
    Route::get('/tagihan', [CustomerTagihanController::class, 'index']);

    // Pembayaran user
    Route::post('/pembayaran/create', [PembayaranController::class, 'create']);
    Route::post('/pembayaran/upload-bukti', [PembayaranController::class, 'uploadBukti']);
    Route::get('/pembayaran/riwayat', [PembayaranController::class, 'riwayatCustomer']);

    // Logout
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::post('/notifikasi/tagihan', [NotifikasiController::class, 'tagihan']);
    Route::post('/notifikasi/pembayaran', [NotifikasiController::class, 'pembayaran']);

    Route::get('/notifikasi', [NotifikasiController::class, 'list']);
    Route::patch('/notifikasi/{id}/read', [NotifikasiController::class, 'markRead']);
});

/*
|--------------------------------------------------------------------------
| ADMIN AREA (AUTH + ADMIN MIDDLEWARE)
|--------------------------------------------------------------------------
*/
Route::middleware(['auth:sanctum', 'admin'])
    ->prefix('admin')
    ->group(function () {
        // Dashboard Admin
        Route::get('/dashboard', [DashboardAdminController::class, 'index']);

    

        /*
        |--------------------------------------------------------------------------
        | PELANGGAN CRUD
        |--------------------------------------------------------------------------
        */
        Route::get('/pelanggan', [PelangganController::class, 'index']);
        Route::post('/pelanggan', [PelangganController::class, 'store']);
        Route::get('/pelanggan/{id}', [PelangganController::class, 'show']);
        Route::put('/pelanggan/{id}', [PelangganController::class, 'update']);
        Route::delete('/pelanggan/{id}', [PelangganController::class, 'destroy']);

        /*
        |--------------------------------------------------------------------------
        | TAGIHAN CRUD
        |--------------------------------------------------------------------------
        */
        Route::get('/tagihan', [TagihanAdminController::class, 'index']);
        Route::post('/tagihan', [TagihanAdminController::class, 'store']);
        Route::get('/tagihan/{id}', [TagihanAdminController::class, 'show']);
        Route::put('/tagihan/{id}', [TagihanAdminController::class, 'update']);
        Route::delete('/tagihan/{id}', [TagihanAdminController::class, 'destroy']);

        /*
        |--------------------------------------------------------------------------
        | PEMBAYARAN (ADMIN)
        |--------------------------------------------------------------------------
        */
        Route::get('/pembayaran', [PembayaranAdminController::class, 'index']);
        Route::put('/pembayaran/{id}/approve', [PembayaranAdminController::class, 'approve']);
        Route::put('/pembayaran/{id}/reject', [PembayaranAdminController::class, 'reject']);

        /*
        |--------------------------------------------------------------------------
        | LAPORAN
        |--------------------------------------------------------------------------
                */
        Route::get('/admin/laporan-keuangan', [LaporanKeuanganController::class, 'index']);
        Route::get('/admin/laporan-keuangan/{periode}', [LaporanKeuanganController::class, 'show']);

        /*
        |--------------------------------------------------------------------------
        | SETTINGS
        |--------------------------------------------------------------------------
        */
        Route::get('/settings', [SettingsController::class, 'show']);
        Route::put('/settings', [SettingsController::class, 'update']);
        Route::post('/settings/regenerate-jwt', [SettingsController::class, 'regenerateJwt']);
    });
