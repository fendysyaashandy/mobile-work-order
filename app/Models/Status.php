<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Status extends Model
{
    use HasFactory;
    protected $table = 'm_status';

    public function workorder()
    {
        return $this->hasMany(Workorder::class, 'status_id');
    }

    public function lemburSpl()
    {
        return $this->hasMany(LemburSpl::class, 'status_id');
    }
}
