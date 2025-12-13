<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class TagihanSeeder extends Seeder
{
    public function run(): void
    {
        $now = Carbon::now();

        DB::table('tagihans')->insert([
            [
                'pelanggan_id' => 1, // pelanggan pertama
                'tanggal'      => $now->copy()->subDays(20),
                'jumlah'       => 5000,
                'status'       => 'belum_dibayar',
                'created_at'   => $now,
                'updated_at'   => $now,
            ],
            [
                'pelanggan_id' => 2, // pelanggan kedua
                'tanggal'      => $now->copy()->subDays(15),
                'jumlah'       => 10000,
                'status'       => 'belum_dibayar',
                'created_at'   => $now,
                'updated_at'   => $now,
            ],
            [
                'pelanggan_id' => 1, // pelanggan pertama lagi
                'tanggal'      => $now->copy()->subDays(10),
                'jumlah'       => 7500,
                'status'       => 'belum_dibayar',
                'created_at'   => $now,
                'updated_at'   => $now,
            ],
        ]);
    }
}
