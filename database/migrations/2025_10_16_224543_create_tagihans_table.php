<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('tagihans', function (Blueprint $table) {
            $table->id('id_tagihan');
            $table->unsignedBigInteger('pelanggan_id');

            $table->integer('jumlah');               // nominal
            $table->enum('status', ['unpaid','paid','pending'])->default('unpaid');

            $table->date('tanggal');                 // tanggal dibuat
            $table->date('due_date');                // jatuh tempo
            $table->string('bulan');                 // 'April'
            $table->string('tahun');                 // '2025'

            $table->timestamps();

            $table->foreign('pelanggan_id')
                ->references('id_pelanggan')->on('pelanggans')->onDelete('cascade');
        });


    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tagihans');
    }
};
