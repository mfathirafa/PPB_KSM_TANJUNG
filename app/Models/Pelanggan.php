<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pelanggan extends Model
{
    use HasFactory;
    
    protected $table = 'pelanggans';
    protected $primaryKey = 'id_pelanggan';
    public $timestamps = false;

    protected $fillable = [
        'user_id',
        'nama',
        'alamat',
        'no_hp'
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
    public function tagihan()
    {
        return $this->hasMany(Tagihan::class, 'ID_Pelanggan');
    }
}