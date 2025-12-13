<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('notifikasis', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->text('pesan');
            $table->enum('tipe', ['tagihan', 'pembayaran', 'laporan', 'sistem']);
            $table->enum('channel', ['whatsapp', 'system'])->default('whatsapp');
            $table->enum('status', ['pending', 'sent', 'failed', 'read'])->default('pending');
            $table->timestamp('sent_at')->nullable();
            $table->timestamps();
        });

    }

    public function down(): void
    {
        Schema::dropIfExists('notifikasis');
    }
};
