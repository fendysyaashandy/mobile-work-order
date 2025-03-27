<?php

namespace App\Http\Controllers;

use App\Models\DetailForm;
use App\Models\Form;
use App\Models\OptionForm;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class FormController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        try {
            $form = Form::with('jenisWorkorder', 'detailForm.optionForm')->get();
            return response()->json($form, 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Terjadi kesalahan saat mengambil data forms',
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
            'jenis_workorder_id' => 'required|integer|exists:m_jenis_workorder,id',
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
            $form = Form::create([
                'jenis_workorder_id' => $validatedData['jenis_workorder_id'],
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
                'm_form' => $form,
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
            $form = Form::with('jenisWorkorder', 'detailForm.optionForm')->findorFail($id);
            return response()->json($form, 200);
        } catch (\Exception $e) {
            return response()->json(['message' => $e->getMessage(),], 500);
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
            'jenis_workorder_id' => 'required|integer|exists:m_jenis_workorder,id',
            'detail_form' => 'required|array',
            'detail_form.*.id' => 'nullable|integer|exists:detail_form,id',
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
            'detail_form.*.option_form.*.id' => 'nullable|integer|exists:option_form,id',
            'detail_form.*.option_form.*.nama_opsi' => 'required|string',
            'detail_form.*.option_form.*.parent' => 'required|integer',
            'detail_form.*.option_form.*.order' => 'required|integer',
        ]);

        DB::beginTransaction();

        try {
            $form = Form::findOrFail($id);
            $form->update([
                'jenis_workorder_id' => $validatedData['jenis_workorder_id'],
            ]);

            $existingDetailIds = [];
            $existingOptionIds = [];

            foreach ($validatedData['detail_form'] as $detail) {
                if (isset($detail['id'])) {
                    $detailForm = DetailForm::findOrFail($detail['id']);
                    $detailForm->update($detail);
                } else {
                    $detailForm = $form->detailForm()->create($detail);
                }
                $existingDetailIds[] = $detailForm->id;

                if (!empty($detail['option_form'])) {
                    foreach ($detail['option_form'] as $option) {
                        if (isset($option['id'])) {
                            $optionForm = OptionForm::findOrFail($option['id']);
                            $optionForm->update($option);
                        } else {
                            $optionForm = $detailForm->optionForm()->create($option);
                        }
                        $existingOptionIds[] = $optionForm->id;
                    }
                }
            }
            DetailForm::where('form_id', $id)->whereNotIn('id', $existingDetailIds)->delete();
            OptionForm::whereNotIn('id', $existingOptionIds)->delete();

            DB::commit();
            return response()->json([
                'm_form' => $form,
                'detail_form' => $form->detailForm,
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'Gagal mengupdate data: ' . $e->getMessage()], 500);
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
            $form = Form::findOrFail($id);
            $form->delete();
            return response()->json(['message' => 'Form berhasil dihapus'], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
}
