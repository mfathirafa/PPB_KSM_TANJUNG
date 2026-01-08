<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;


class UserFactory extends Factory
{
    public function definition(): array
    {
        return [
            'name'  => $this->faker->name(),
            'phone' => $this->faker->unique()->numerify('08##########'),
            'role'  => 'admin',
        ];
    }

    public function admin(): static
    {
        return $this->state(fn () => [
            'role' => 'admin',
        ]);
    }

    public function pelanggan(): static
    {
        return $this->state(fn () => [
            'role' => 'pelanggan',
        ]);
    }
}