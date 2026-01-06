<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('pembayarans', function (Blueprint $table) {
            $table->id();

            // customer yang bayar
            $table->foreignId('user_id')
                ->constrained()
                ->cascadeOnDelete();

            // tagihan yang dibayar
            $table->foreignId('tagihan_id')
                ->constrained()
                ->cascadeOnDelete();

            // admin yang verifikasi
            $table->foreignId('verified_by')
                ->nullable()
                ->constrained('users')
                ->nullOnDelete();

            $table->date('tanggal');
            $table->integer('jumlah_bayar');

            $table->enum('metode', [
                'QRIS',
                'TRANSFER',
                'CASH'
            ]);

            $table->enum('status', [
                'pending',
                'confirmed',
                'rejected'
            ])->default('pending');

            $table->timestamps();
        });

        // 🔥 HAPUS no_hp dari pelanggans (SATU SUMBER: users.phone)
        Schema::table('pelanggans', function (Blueprint $table) {
            if (Schema::hasColumn('pelanggans', 'no_hp')) {
                $table->dropColumn('no_hp');
            }
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('pembayarans');

        // restore kolom no_hp jika rollback
        Schema::table('pelanggans', function (Blueprint $table) {
            if (!Schema::hasColumn('pelanggans', 'no_hp')) {
                $table->string('no_hp')->nullable();
            }
        });
    }
};