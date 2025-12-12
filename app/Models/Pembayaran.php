<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pembayaran extends Model
{
    use HasFactory;

    protected $primaryKey = 'id_pembayaran';

    protected $fillable = [
        'tagihan_id',
        'user_id',
        'nominal',
        'metode',
        'bukti_path',
        'status',
    ];

    // Pembayaran milik satu tagihan
    public function tagihan()
    {
        return $this->belongsTo(Tagihan::class, 'tagihan_id', 'id_tagihan');
    }

    // Pembayaran dilakukan oleh user (pelanggan)
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'user_id');
    }
}
