<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('detail_form', function (Blueprint $table) {
            $table->id();
            $table->foreignId('form_id')->constrained('m_form')->onDelete('cascade');
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
     */
    public function down(): void
    {
        Schema::dropIfExists('detail_form');
    }
};
