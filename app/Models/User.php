<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory;

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

    public function pelanggan()
    {
        return $this->hasOne(Pelanggan::class);
    }

    public function pembayaran()
    {
        return $this->hasMany(Pembayaran::class);
    }
}
