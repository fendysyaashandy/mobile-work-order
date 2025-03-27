<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateDetailFormsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('detail_form', function (Blueprint $table) {
            $table->id();
            // $table->foreignId('form_id')->constrained('m_form')->onDelete('cascade');
            $table->foreignId('jenis_workorder_id')->constrained('m_jenis_workorder')->onDelete('cascade');
            $table->string('nama_field');
            $table->string('tipe_data');
            $table->string('unit_satuan')->nullable();
            $table->integer('min')->nullable();
            $table->integer('max')->nullable();
            $table->string('tipe_field');
            $table->string('sifat');
            $table->integer('parent');
            $table->string('keterangan')->nullable();
            $table->integer('order');
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
        Schema::dropIfExists('detail_form');
    }
}
