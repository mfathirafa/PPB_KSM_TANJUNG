<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class PembayaranSeeder extends Seeder
{
    public function run(): void
    {
        $now = Carbon::now();

        DB::table('pembayarans')->insert([
            [
                'tagihan_id'   => 1,
                'user_id'      => 1,
                'tanggal'      => $now->copy()->subDays(5),
                'jumlah_bayar' => 5000,
                'metode'       => 'QRIS',
                'created_at'   => $now,
                'updated_at'   => $now,
            ],
            [
                'tagihan_id'   => 2,
                'user_id'      => 2,
                'tanggal'      => $now->copy()->subDays(10),
                'jumlah_bayar' => 10000,
                'metode'       => 'TRANSFER',
                'created_at'   => $now,
                'updated_at'   => $now,
            ],
            [
                'tagihan_id'   => 3,
                'user_id'      => 3,
                'tanggal'      => $now->copy()->subDays(15),
                'jumlah_bayar' => 7500,
                'metode'       => 'QRIS',
                'created_at'   => $now,
                'updated_at'   => $now,
            ],
        ]);
    }
}
