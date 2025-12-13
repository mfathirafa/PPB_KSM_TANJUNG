<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\LaporanKeuangan;
use Illuminate\Http\Request;

class LaporanKeuanganController extends Controller
{
    public function index()
    {
        return response()->json([
            'data' => LaporanKeuangan::orderBy('periode', 'desc')->get()
        ]);
    }

    public function show($periode)
    {
        $laporan = LaporanKeuangan::where('periode', $periode)->firstOrFail();

        return response()->json([
            'data' => $laporan
        ]);
    }
}
