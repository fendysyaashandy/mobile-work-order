<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class StatusFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        static $names = ['Belum disetujui', 'Disetujui', 'Revisi', 'Ditolak', 'Selesai'];
        static $desc = ['Menunggu persetujuan', 'Disetujui oleh atasan', 'Revisi hasil pekerjaan', 'Ditolak oleh atasan', 'Sudah selesai'];
        $nama = array_shift($names);
        $keterangan = array_shift($desc);

        return [
            'nama' => $nama,
            'keterangan' => $keterangan,
            'aktif' => true,
        ];
    }
}
