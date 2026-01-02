<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pembayaran extends Model
{
    protected $fillable = [
        'user_id',
        'tagihan_id',
        'verified_by',
        'tanggal',
        'jumlah_bayar',
        'metode',
        'status',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function tagihan()
    {
        return $this->belongsTo(Tagihan::class);
    }

    public function adminVerifier()
    {
        return $this->belongsTo(User::class, 'verified_by');
    }
}