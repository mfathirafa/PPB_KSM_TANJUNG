<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Pelanggan;
use Illuminate\Foundation\Testing\RefreshDatabase;

class TagihanTest extends TestCase
{
    use RefreshDatabase;

    /** @test */
    public function admin_dapat_membuat_tagihan_baru()
    {
        // =========================
        // BUAT ADMIN
        // =========================
        $admin = User::factory()->create([
            'role' => 'admin',
        ]);

        // =========================
        // BUAT PELANGGAN
        // =========================
        $pelanggan = Pelanggan::factory()->create();

        // =========================
        // DATA TAGIHAN
        // =========================
        $payload = [
            'pelanggan_id' => $pelanggan->id,
            'jumlah' => 5000,
            'tanggal' => now()->toDateString(),
        ];

        // =========================
        // HIT API
        // =========================
        $response = $this->actingAs($admin)
            ->postJson('/api/admin/tagihan', $payload);

        // =========================
        // ASSERT
        // =========================
        $response->assertStatus(201);

        $this->assertDatabaseHas('tagihans', [
            'pelanggan_id' => $pelanggan->id,
            'jumlah' => 5000,
        ]);
    }
}