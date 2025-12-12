<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class AdminSeeder extends Seeder
{
    public function run(): void
    {
        // 1️⃣ Buat user baru untuk admin
        $user_id = DB::table('users')->insertGetId([
            'Nama' => 'Admin Utama',
            'Email' => 'admin@example.com',
            'Password' => Hash::make('123456'),
            'Role' => 'admin',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        // 2️⃣ Masukkan ke tabel admins, pakai user_id di atas
        DB::table('admins')->insert([
            'User_id' => $user_id, // foreign key dari tabel users
            'Nama' => 'Admin Utama',
            'Username' => 'adminksm',
            'Password' => Hash::make('123456'), // password terenkripsi
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}
