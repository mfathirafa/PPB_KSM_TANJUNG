<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Tagihan extends Model
{
    use HasFactory;

    protected $primaryKey = 'id_tagihan';

    protected $fillable = [
        'pelanggan_id',
        'jumlah',
        'status',
        'tanggal',
        'due_date',
        'bulan',
        'tahun',
    ];

    protected $casts = [
        'tanggal' => 'date',
        'due_date' => 'date',
    ];

    // Tagihan milik 1 pelanggan
    public function pelanggan()
    {
        return $this->belongsTo(Pelanggan::class, 'pelanggan_id', 'id_pelanggan');
    }

    // Tagihan punya banyak pembayaran
    public function pembayaran()
    {
        return $this->hasMany(Pembayaran::class, 'tagihan_id', 'id_tagihan');
    }
}
