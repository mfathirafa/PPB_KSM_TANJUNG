<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Factories\HasFactory;

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

    protected $hidden = ['otp', 'otp_expires_at'];

    protected $casts = [
        'otp_expires_at' => 'datetime',
    ];

    public function pelanggan()
    {
        return $this->hasOne(Pelanggan::class);
    }

    public function pembayarans()
    {
        return $this->hasMany(Pembayaran::class);
    }

    public function verifiedPembayarans()
    {
        return $this->hasMany(Pembayaran::class, 'verified_by');
    }

    public function notifikasis()
    {
        return $this->hasMany(Notifikasi::class);
    }
}
