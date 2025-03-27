<?php

namespace App\Http\Controllers;

use App\Models\JenisWorkorder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class JenisWorkorderController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        try {
            $search = $request->query('search');
            $page = $request->query('page', 1);
            $limit = $request->query('limit', 10);
            $sort = $request->query('sort', 'desc');
            $all = $request->query('all', false);

            $query = JenisWorkorder::with('detailForm', 'kpi');
            if ($search) {
                $query->where('nama', 'ILIKE', "%$search%");
            }

            $query->orderBy('created_at', $sort);

            if ($all) {
                return response()->json([
                    'data' => $query->get(),
                ]);
            }

            $jenisworkorders = $query->paginate($limit, ['*'], 'page', $page);
            return response()->json([
                'data' => $jenisworkorders->items(),
                'totalPages' => $jenisworkorders->lastPage(),
                'currentPage' => $jenisworkorders->currentPage(),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Terjadi kesalahan saat mengambil data jenis workorder',
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
            'nama' => 'required|string|unique:m_jenis_workorder,nama',
            'kpi_id' => 'required|integer|exists:master_kpi,id',
            'detail_form' => 'required|array',
            'detail_form.*.nama_field' => 'required|string',
            'detail_form.*.tipe_data' => 'required|string',
            'detail_form.*.unit_satuan' => 'nullable|string',
            'detail_form.*.min' => 'nullable|integer',
            'detail_form.*.max' => 'nullable|integer',
            'detail_form.*.tipe_field' => 'required|string',
            'detail_form.*.sifat' => 'required|string',
            'detail_form.*.keterangan' => 'nullable|string',
            'detail_form.*.parent' => 'required|integer',
            'detail_form.*.order' => 'required|integer',
            'detail_form.*.option_form' => 'nullable|array',
            'detail_form.*.option_form.*.nama_opsi' => 'required|string',
            'detail_form.*.option_form.*.parent' => 'required|integer',
            'detail_form.*.option_form.*.order' => 'required|integer',
        ]);

        DB::beginTransaction();

        try {
            $form = JenisWorkorder::create([
                'nama' => $validatedData['nama'],
                'kpi_id' => $validatedData['kpi_id'],
            ]);

            foreach ($validatedData['detail_form'] as $detail) {
                $detailForm =  $form->detailForm()->create([
                    'nama_field' => $detail['nama_field'],
                    'tipe_data' => $detail['tipe_data'],
                    'unit_satuan' => $detail['unit_satuan'],
                    'min' => $detail['min'],
                    'max' => $detail['max'],
                    'tipe_field' => $detail['tipe_field'],
                    'sifat' => $detail['sifat'],
                    'keterangan' => $detail['keterangan'],
                    'parent' => $detail['parent'],
                    'order' => $detail['order'],
                ]);

                if (!empty($detail['option_form'])) {
                    foreach ($detail['option_form'] as $option) {
                        $detailForm->optionForm()->create([
                            'nama_opsi' => $option['nama_opsi'],
                            'parent' => $option['parent'],
                            'order' => $option['order'],
                        ]);
                    }
                }
            }
            DB::commit();
            return response()->json([
                'jenis_workorder' => $form,
                'detail_form' => $form->detailForm,
                'option' => $form->detailForm->map->optionForm,
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'Gagal menyimpan data: ' . $e->getMessage()], 500);
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
            $jenisWorkorder = JenisWorkorder::with('detailForm', 'detailForm.optionForm')->findOrFail($id);
            return response()->json($jenisWorkorder, 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Terjadi kesalahan saat mengambil data jenis workorder',
                'message' => $e->getMessage()
            ], 500);
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
            'nama' => 'required|string',
        ]);

        try {
            $jenisWorkorder = JenisWorkorder::findOrFail($id);
            $jenisWorkorder->update($validatedData);
            return response()->json([
                'message' => 'Data jenis workorder berhasil diupdate',
                'data' => $jenisWorkorder
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Terjadi kesalahan saat mengupdate data jenis workorder',
                'message' => $e->getMessage()
            ], 500);
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
            $jenisWorkorder = JenisWorkorder::findOrFail($id);
            $jenisWorkorder->delete();
            return response()->json([
                'message' => 'Data jenis workorder berhasil dihapus',
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Terjadi kesalahan saat menghapus data jenis workorder',
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
