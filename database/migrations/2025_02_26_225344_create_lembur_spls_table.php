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
        Schema::create('lembur_spl', function (Blueprint $table) {
            $table->id();
            $table->foreignId('status_id')->constrained('m_status');
            $table->datetime('waktu_pengajuan');
            $table->datetime('waktu_verifikasi')->nullable();
            $table->string('alasan_ditolak')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('lembur_spl');
    }
};
