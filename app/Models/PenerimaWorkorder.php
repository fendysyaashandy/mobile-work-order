<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PenerimaWorkorder extends Model
{
    use HasFactory;
    protected $table = 'penerima_workorder';
    protected $primaryKey = ['workorder_id', 'user_id'];
    public $incrementing = false;

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function workorder()
    {
        return $this->belongsTo(Workorder::class, 'workorder_id');
    }
}
