<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateFormsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('m_form', function (Blueprint $table) {
            $table->id();
            // $table->foreignId('jenis_workorder_id')->constrained('m_jenis_workorder')->onDelete('cascade');
            // $table->foreignId('kpi_id')->constrained('master_kpi');
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
        Schema::dropIfExists('m_form');
    }
}
