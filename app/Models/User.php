<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    use HasFactory;

    protected $table = 'users';
    protected $primaryKey = 'user_id';
    public $timestamps = true;

    protected $fillable = [
        'nama',
        'email',
        'password',
        'role'
    ];

    // 1 user bisa punya banyak notifikasi
    public function admin()
    {
        return $this->hasOne(Admin::class, 'user_id');
    }
    public function pelanggan()
    {
        return $this->hasOne(Pelanggan::class, 'user_id');
    }
    public function notifikasi()
    {
        return $this->hasMany(Notifikasi::class, 'user_id');
    }
    public function laporan_keuangan()
    {
        return $this->hasMany(Laporan_Keuangan::class, 'user_id');
    }
    public function pembayaran()
    {
        return $this->hasMany(Pembayaran::class, 'user_id');
    }
}
