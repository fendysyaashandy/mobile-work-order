<?php

namespace Database\Factories;

use App\Models\User;
use App\Models\Workorder;
use Illuminate\Database\Eloquent\Factories\Factory;

class WorkorderFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        return [
            'judul_pekerjaan' => $this->faker->jobTitle(),
            'waktu_penugasan' => $this->faker->dateTimeThisMonth(),
            'estimasi_durasi' => $this->faker->numberBetween(1, 23),
            'unit_waktu' => $this->faker->randomElement(['Jam', 'Hari', 'Bulan']),
            'estimasi_selesai' => $this->faker->dateTimeThisMonth(),
            'longitude' => $this->faker->longitude(),
            'latitude' => $this->faker->latitude(),
            'pic_id' => $this->faker->numberBetween(1, 4),
            'status_id' => $this->faker->numberBetween(1, 5),
            'jenis_workorder_id' => $this->faker->numberBetween(1, 5),
            'jenis_lokasi_id' => $this->faker->numberBetween(1, 2),
            'tipe_workorder_id' => $this->faker->numberBetween(1, 2),
        ];
    }

    public function configure()
    {
        return $this->afterCreating(function (Workorder $workorder) {
            $users = User::inRandomOrder()->limit(rand(1, 3))->pluck('id');
            $workorder->penerimaTugas()->attach($users);
        });
    }
}
