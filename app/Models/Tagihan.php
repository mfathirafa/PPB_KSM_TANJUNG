<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Tagihan extends Model
{
    protected $fillable = [
        'pelanggan_id',
        'tanggal',
        'jumlah',
        'status',
    ];

    public function pelanggan()
    {
        return $this->belongsTo(Pelanggan::class);
    }

    public function pembayarans()
    {
        return $this->hasMany(Pembayaran::class);
    }
}