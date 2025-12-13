<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class LaporanKeuangan extends Model
{
    protected $fillable = [
        'periode',
        'total_pemasukan',
        'total_transaksi',
        'generated_at',
    ];

    protected $casts = [
        'generated_at' => 'datetime',
    ];
}
