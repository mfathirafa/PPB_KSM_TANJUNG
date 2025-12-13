<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('laporan_keuangans', function (Blueprint $table) {
            $table->id();
            $table->string('periode', 7); // YYYY-MM
            $table->integer('total_pemasukan');
            $table->integer('total_transaksi');
            $table->timestamp('generated_at');
            $table->timestamps();

            $table->unique('periode');
        });

    }

    public function down(): void
    {
        Schema::dropIfExists('laporan_keuangans');
    }
};
