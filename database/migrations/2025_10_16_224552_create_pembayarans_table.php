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
        Schema::create('pembayarans', function (Blueprint $table) {
            $table->id('id_pembayaran');
            $table->unsignedBigInteger('tagihan_id');
            $table->unsignedBigInteger('user_id');

            $table->integer('nominal');
            $table->string('metode', 50);               // QRIS, VA, transfer, dll
            $table->string('bukti_path')->nullable();   // path bukti bayar

            $table->enum('status', ['pending','approved','rejected'])
                ->default('pending');

            $table->timestamps();

            $table->foreign('tagihan_id')->references('id_tagihan')->on('tagihans')->onDelete('cascade');
            $table->foreign('user_id')->references('user_id')->on('users')->onDelete('cascade');
        });


    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pembayarans');
    }
};
