<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pembayaran extends Model
{
  use HasFactory;
  protected $table = 'pembayarans';
  protected $primaryKey = 'id_pembayaran';
  public $timestamps = false;

  protected $fillable = [
    'id_tagihan',
    'user_id',
    'tanggal',
    'jumlah_Bayar',
    'metode'
  ];

  public function tagihan()
  {
    return $this->belongsTo(Tagihan::class, 'id_tagihan');
  }

  public function user()
  {
    return $this->belongsTo(User::class, 'user_id');
  }
}