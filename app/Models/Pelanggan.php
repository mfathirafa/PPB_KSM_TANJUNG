<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pelanggan extends Model
{
    use HasFactory;

    protected $primaryKey = 'id_pelanggan';

    protected $fillable = [
        'user_id',
        'alamat',
        'no_hp',
    ];

    // Pelanggan milik 1 user
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'user_id');
    }

    // Pelanggan punya banyak tagihan
    public function tagihans()
    {
        return $this->hasMany(Tagihan::class, 'pelanggan_id', 'id_pelanggan');
    }
}
