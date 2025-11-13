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
            $table->unsignedBigInteger('admin_id');
            $table->unsignedBigInteger('user_id');


            $table->date('tanggal');
            $table->integer('jumlah_bayar');
            $table->string('metode', 20);
            $table->timestamps();

            $table->foreign('tagihan_id')->references('id_tagihan')->on('tagihans')->onDelete('cascade');
            $table->foreign('admin_id')->references('id_admin')->on('admins')->onDelete('cascade');
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
