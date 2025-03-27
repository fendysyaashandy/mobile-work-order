<?php

namespace App\Http\Controllers;

use App\Models\LemburSpl;
use App\Models\Workorder;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

class WorkorderController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        try {
            $type = $request->query('type');
            $search = $request->query('search');
            $status = $request->query('status');
            $dateRange = $request->query('date_range');
            $startDate = $request->query('start_date');
            $endDate = $request->query('end_date');
            $page = $request->query('page', 1);
            $limit = $request->query('limit', 10);
            $sort = $request->query('sort', 'desc');
            $all = $request->query('all', false);

            $query = Workorder::with('penerimaTugas', 'pic', 'jenisWorkorder', 'jenisLokasi', 'tipeWorkorder', 'status', 'lemburSpl');
            if ($type) {
                $query->where('tipe_workorder_id', $type);
            }
            if ($search) {
                $query->where(function ($q) use ($search) {
                    $q->where('judul_pekerjaan', 'ILIKE', "%$search%")
                        ->orWhereHas('jenisWorkorder', function ($q) use ($search) {
                            $q->where('nama', 'ILIKE', "%$search%");
                        })
                        ->orWhereHas('jenisLokasi', function ($q) use ($search) {
                            $q->where('nama', 'ILIKE', "%$search%");
                        })
                        ->orWhere('unit_waktu', 'ILIKE', "%$search%")
                        ->orWhereHas('status', function ($q) use ($search) {
                            $q->where('nama', 'ILIKE', "%$search%");
                        })
                        ->orWhereHas('penerimaTugas', function ($q) use ($search) {
                            $q->where('email', 'ILIKE', "%$search%");
                        });
                });
            }
            if ($status) {
                $query->where('status_id', $status);
            }
            if ($dateRange) {
                switch ($dateRange) {
                    case 'hari_ini':
                        $query->whereBetween('created_at', [
                            Carbon::now()->startOfDay(),
                            Carbon::now()->endOfDay(),
                        ]);
                        break;
                    case 'minggu_ini':
                        $query->whereBetween('created_at', [
                            Carbon::now()->startOfWeek(),
                            Carbon::now()->endOfWeek(),
                        ]);
                        break;
                    case 'bulan_ini':
                        $query->whereBetween('created_at', [
                            Carbon::now()->startOfMonth(),
                            Carbon::now()->endOfMonth(),
                        ]);
                        break;
                    case '3_bulan':
                        $query->whereBetween('created_at', [
                            Carbon::now()->subMonths(3)->startOfDay(),
                            Carbon::now()->endOfDay(),
                        ]);
                        break;
                    case 'custom':
                        if ($startDate && $endDate) {
                            $query->whereBetween('created_at', [
                                Carbon::parse($startDate)->startOfDay(),
                                Carbon::parse($endDate)->endOfDay(),
                            ]);
                        }
                        break;
                }
            }

            $query->orderBy('created_at', $sort);

            if ($all) {
                return response()->json([
                    'data' => $query->get(),
                ]);
            }

            $workorders = $query->paginate($limit, ['*'], 'page', $page);
            return response()->json([
                'data' => $workorders->items(),
                'totalPages' => $workorders->lastPage(),
                'currentPage' => $workorders->currentPage(),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Terjadi kesalahan saat mengambil data workorder',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'judul_pekerjaan' => 'required|string',
            'waktu_penugasan' => 'required|date',
            'estimasi_durasi' => 'required|integer',
            'unit_waktu' => 'required|in:Jam,Hari,Bulan',
            'estimasi_selesai' => 'required|date',
            'longitude' => 'nullable|numeric',
            'latitude' => 'nullable|numeric',
            'pic_id' => 'required|exists:users,id',
            'jenis_workorder_id' => 'required|exists:m_jenis_workorder,id',
            'jenis_lokasi_id' => 'required|exists:m_jenis_lokasi,id',
            'tipe_workorder_id' => 'required|exists:m_tipe_workorder,id',
            'penerima_tugas' => 'required|array|exists:users,id',
        ]);
        DB::beginTransaction();
        try {
            $statusId = 3;
            $lemburSplId = null;
            if ($validatedData['tipe_workorder_id'] == 2) {
                $lemburSpl = LemburSpl::create([
                    'status_id' => 1,
                    'waktu_pengajuan' => now(),
                    'waktu_verifikasi' => null,
                    'alasan_ditolak' => null,
                ]);
                $lemburSplId = $lemburSpl->id;
                $statusId = 1;
            }

            $workorder = Workorder::create([
                'judul_pekerjaan' => $validatedData['judul_pekerjaan'],
                'waktu_penugasan' => $validatedData['waktu_penugasan'],
                'estimasi_durasi' => $validatedData['estimasi_durasi'],
                'unit_waktu' => $validatedData['unit_waktu'],
                'estimasi_selesai' => $validatedData['estimasi_selesai'],
                'longitude' => $validatedData['longitude'],
                'latitude' => $validatedData['latitude'],
                'pic_id' => $validatedData['pic_id'],
                'lembur_spl_id' => $lemburSplId,
                'status_id' => $statusId,
                'jenis_workorder_id' => $validatedData['jenis_workorder_id'],
                'jenis_lokasi_id' => $validatedData['jenis_lokasi_id'],
                'tipe_workorder_id' => $validatedData['tipe_workorder_id'],
            ]);

            $workorder->penerimaTugas()->attach($validatedData['penerima_tugas']);
            DB::commit();
            return response()->json([
                'message' => 'Work Order berhasil disimpan',
                'data' => $workorder->load('penerimaTugas')
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        try {
            $workorder = Workorder::with('penerimaTugas', 'pic', 'jenisWorkorder', 'jenisLokasi', 'tipeWorkorder', 'status', 'lemburSpl')->findOrFail($id);
            return response()->json($workorder, 200);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $validatedData = $request->validate([
            'judul_pekerjaan' => 'nullable|string',
            'waktu_penugasan' => 'nullable|date',
            'estimasi_durasi' => 'nullable|integer',
            'unit_waktu' => 'nullable|string',
            'estimasi_selesai' => 'nullable|date',
            'longitude' => 'nullable|numeric',
            'latitude' => 'nullable|numeric',
            'pic_id' => 'nullable|exists:users,id',
            'jenis_workorder_id' => 'nullable|exists:m_jenis_workorder,id',
            'jenis_lokasi_id' => 'nullable|exists:m_jenis_lokasi,id',
            'tipe_workorder_id' => 'nullable|exists:m_tipe_workorder,id',
        ]);
        try {
            $workorder = Workorder::findOrFail($id);
            $workorder->update($validatedData);

            return response()->json(['message' => 'Workorder berhasil diupdate', 'data' => $workorder], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        try {
            $workorder = Workorder::findOrFail($id);
            $workorder->delete();
            return response()->json(['message' => 'Workorder berhasil dihapus'], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
}
