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
     * STATUS DITENTUKAN DARI PEMBAYARAN TERAKHIR
     */
    public function statusAktif(): string
    {
        $lastPayment = $this->pembayarans()
            ->orderByDesc('created_at')
            ->first();

        if (!$lastPayment) {
            return 'belum_dibayar';
        }

        return match ($lastPayment->status) {
            'pending'   => 'menunggu_verifikasi',
            'confirmed' => 'lunas',
            'rejected'  => 'ditolak',
            default     => 'belum_dibayar',
        };
    }
}