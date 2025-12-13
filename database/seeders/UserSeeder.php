<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('users')->insert([
            [
                'name' => 'Admin KSM',
                'phone' => '081111111111',
                'role' => 'admin',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Budi',
                'phone' => '082222222222',
                'role' => 'customer',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Siti',
                'phone' => '083333333333',
                'role' => 'customer',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}
