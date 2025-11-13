<?php

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Tagihan extends Model
{
  use HasFactory;

  protected $table = 'tagihans';
  protected $primaryKey = 'id_tagihan';
  public $timestamps = false;

  protected $fillable = [
    'id_pelanggan',
    'Tanggal',
    'Jumlah',
    'Status'
  ];

  public function pelanggan()
  {
    return $this->belongsTo(Pelanggan::class, 'id_pelanggan');
  }

  public function pembayaran()
  {
    return $this->hasMany(Pembayaran::class, 'id_tagihan');
  }

}