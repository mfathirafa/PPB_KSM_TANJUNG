<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Laporan_Keuangan extends Model
{
  use HasFactory;
  
  protected $table = 'laporan_keuangan';
  protected $primaryKey = 'id_laporan';
  public $timestamps = false;

  protected $fillable = [
    'user_id',
    'tanggal_laporan',
    'total_pemasukan',
    'total_pengeluaran'
  ];

  public function user()
  {
    return $this->belongsTo(User::class, 'User_id');
  }
}