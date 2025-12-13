<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('tagihans', function (Blueprint $table) {
            $table->id();
            $table->foreignId('pelanggan_id')->constrained()->cascadeOnDelete();
            $table->date('tanggal');
            $table->integer('jumlah');
            $table->enum('status', ['belum_dibayar', 'dibayar', 'lunas'])
                ->default('belum_dibayar');
            $table->timestamps();
        });

    }

    public function down(): void
    {
        Schema::dropIfExists('tagihans');
    }
};
