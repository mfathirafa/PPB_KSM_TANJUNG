<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Notifikasi extends Model
{
  use HasFactory;

  protected $table = 'notifikasi';
  protected $primaryKey = 'notifikasi_id';
  public $timestamps = false;

  protected $fillable = [
    'user_id',
    'Isi_pesan',
    'Tanggal_kirim',
    'tipe',
    'status_baca'
  ];

  public function user()
  {
    return $this->belongTo(User::class, 'user_id');
  }
}