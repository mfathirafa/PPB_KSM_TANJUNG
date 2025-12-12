<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Pelanggan;
use App\Models\User;

class PelangganController extends Controller
{
    public function index()
    {
        // List semua pelanggan
    }

    public function store(Request $request)
    {
        // Tambah pelanggan
    }

    public function show($id)
    {
        // Detail pelanggan
    }

    public function update(Request $request, $id)
    {
        // Update data pelanggan
    }

    public function destroy($id)
    {
        // Hapus pelanggan
    }
}
