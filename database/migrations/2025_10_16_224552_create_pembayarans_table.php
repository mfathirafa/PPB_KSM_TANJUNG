<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('pembayarans', function (Blueprint $table) {
            $table->id();

            // customer
            $table->foreignId('user_id')
                ->constrained('users')
                ->cascadeOnDelete();

            // tagihan
            $table->foreignId('tagihan_id')
                ->constrained('tagihans')
                ->cascadeOnDelete();

            // admin verifier
            $table->foreignId('verified_by')
                ->nullable()
                ->constrained('users')
                ->nullOnDelete();

            $table->date('tanggal');
            $table->integer('jumlah_bayar');
            $table->enum('metode', ['QRIS', 'TRANSFER', 'CASH']);

            $table->enum('status', [
                'pending',
                'confirmed',
                'rejected'
            ])->default('pending');

            $table->timestamps();
        });

    }

    public function down(): void
    {
        Schema::dropIfExists('pembayarans');
    }
};
