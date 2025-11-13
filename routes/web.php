<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\PelangganController;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/tentang', function () {
    return "Ini halaman KSM Tanjung";
});

Route::get('/contact', function() {
    return "Silahkan hubungi kami di +62-812-345-678";
});

Route::resource('pelanggans', PelangganController::class);
