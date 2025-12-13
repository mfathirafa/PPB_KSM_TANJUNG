<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class PelangganSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('pelanggans')->insert([
            [
                'user_id' => 2, // Budi
                'nama' => 'Budi',
                'alamat' => 'Jl. Mawar',
                'no_hp' => '082222222222',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'user_id' => 3, // Siti
                'nama' => 'Siti',
                'alamat' => 'Jl. Melati',
                'no_hp' => '083333333333',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}
