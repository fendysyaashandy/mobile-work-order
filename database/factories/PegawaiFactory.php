<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class PegawaiFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        return [
            'nama' => $this->faker->name(),
            'nip' => $this->faker->unique()->randomNumber(8),
            'tanggal_lahir' => $this->faker->date(),
            'jenis_kelamin' => $this->faker->randomElement(['Laki-laki', 'Perempuan']),
            'alamat' => $this->faker->address(),
            'telepon' => $this->faker->phoneNumber(),
            'departemen_id' => $this->faker->numberBetween(1, 3),
            'jabatan_id' => $this->faker->numberBetween(1, 6),
        ];
    }
}
