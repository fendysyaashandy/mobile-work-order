<?php

namespace Database\Seeders;

use App\Models\Departemen;
use App\Models\Jabatan;
use App\Models\JenisLokasi;
use App\Models\JenisWorkorder;
use App\Models\MasterKpi;
use App\Models\Pegawai;
use App\Models\Pic;
use App\Models\Role;
use App\Models\Status;
use App\Models\TipeWorkorder;
use App\Models\User;
use App\Models\Workorder;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        Departemen::factory(3)->create();
        Jabatan::factory(6)->create();
        Role::factory(3)->create();
        Status::factory(5)->create();
        Pegawai::factory(20)->create();

        User::factory()->create([
            // 'pegawai_id' => 1,
            'role_id' => 1,
            'email' => 'superadmin@gmail.com',
            'password' => bcrypt('password'),
        ]);
        User::factory()->create([
            // 'pegawai_id' => 2,
            'role_id' => 2,
            'email' => 'manager@gmail.com',
            'password' => bcrypt('password'),
        ]);
        User::factory()->create([
            // 'pegawai_id' => 3,
            'role_id' => 3,
            'email' => 'employee@gmail.com',
            'password' => bcrypt('password'),
        ]);
        User::factory(7)->create();
        MasterKpi::factory(10)->create();
        JenisLokasi::factory(2)->create();
        TipeWorkorder::factory(2)->create();
        JenisWorkorder::factory(10)->create();
        Workorder::factory(100)->create();
    }
}
