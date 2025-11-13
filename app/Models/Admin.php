<?php 

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Admin extends Model
{
  use HasFactory;

  protected $table = 'admins';
  protected $primaryKey = 'id_admin';
  public $timestamps = true;

  protected $fillable = [
    'user_id',
    'nama',
    'username',
    'password'
  ];

  public function user()
  {
    return $this->belongsTo(User::class, 'user_id');
  }
  public function pembayaran()
  {
    return $this->hasMany(Pembayaran::class, 'ID_Admin');
  }
}