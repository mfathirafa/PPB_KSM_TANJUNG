<?php

namespace Database\Factories;

use App\Models\Pelanggan;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class PelangganFactory extends Factory
{
    // 🔥 INI WAJIB
    protected $model = Pelanggan::class;

    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'nama'    => $this->faker->name(),
            'alamat'  => $this->faker->address(),
            'no_hp'   => '08' . $this->faker->numerify('##########'),
        ];
    }
}