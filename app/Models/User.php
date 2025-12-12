<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    use HasFactory;

    protected $primaryKey = 'user_id';
    protected $fillable = [
        'name',
        'phone',
        'role',
        'otp',
        'otp_expires_at',
    ];

    protected $hidden = [
        'otp',
        'otp_expires_at',
    ];

    protected $casts = [
        'otp_expires_at' => 'datetime',
    ];

    // ==========================
    // RELASI
    // ==========================

    // Seorang user customer memiliki 1 data pelanggan
    public function pelanggan()
    {
        return $this->hasOne(Pelanggan::class, 'user_id', 'user_id');
    }

    // User customer punya banyak pembayaran
    public function pembayaran()
    {
        return $this->hasMany(Pembayaran::class, 'user_id', 'user_id');
    }
}
