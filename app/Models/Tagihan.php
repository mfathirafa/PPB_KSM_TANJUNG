<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Tagihan extends Model
{
    protected $fillable = [
        'pelanggan_id',
        'jumlah',
        'tanggal',
    ];

    protected $casts = [
        'tanggal' => 'date',
    ];

    public function pelanggan()
    {
        return $this->belongsTo(Pelanggan::class);
    }

    public function pembayarans()
    {
        return $this->hasMany(Pembayaran::class);
    }

    /**
     * ===============================
     * STATUS AKTIF TAGIHAN (FINAL)
     * ===============================
     * PRIORITAS:
     * 1. pending   → menunggu verifikasi
     * 2. confirmed → lunas
     * 3. lainnya   → belum_dibayar
     */
    public function statusAktif(): string
    {
        if ($this->pembayarans->where('status', 'pending')->count() > 0) {
            return 'pending';
        }

        if ($this->pembayarans->where('status', 'confirmed')->count() > 0) {
            return 'lunas';
        }

        return 'belum_dibayar';
    }
}