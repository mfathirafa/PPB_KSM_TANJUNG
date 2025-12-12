<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class TagihanAdminController extends Controller
{
    public function index()
    {
        // list semua tagihan untuk tabel admin
    }

    public function store(Request $request)
    {
        // validasi
        // create tagihan baru
    }

    public function update(Request $request, $id)
    {
        // update tagihan
    }

    public function destroy($id)
    {
        // hapus tagihan
    }
}
