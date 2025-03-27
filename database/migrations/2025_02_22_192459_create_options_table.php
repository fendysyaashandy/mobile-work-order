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
        Schema::create('option_form', function (Blueprint $table) {
            $table->id();
            $table->foreignId('detail_form_id')->constrained('detail_form')->onDelete('cascade');
            $table->string('nama_opsi');
            $table->integer('parent');
            $table->integer('order');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('option_form');
    }
};
