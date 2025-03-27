<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePenerimaWorkordersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('penerima_workorder', function (Blueprint $table) {
            $table->foreignId('workorder_id')->constrained('workorder')->onDelete('cascade');
            $table->foreignId('user_id')->constrained('users');
            $table->primary(['workorder_id', 'user_id']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('penerima_workorder');
    }
}
