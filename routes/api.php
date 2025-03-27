<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\FormController;
use App\Http\Controllers\JenisLokasiController;
use App\Http\Controllers\JenisWorkorderController;
use App\Http\Controllers\KpiController;
use App\Http\Controllers\LemburSplController;
use App\Http\Controllers\PicController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\WorkorderController;
use App\Models\Workorder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('login', [AuthController::class, 'login']);
Route::post('register', [AuthController::class, 'register']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('logout', [AuthController::class, 'logout']);
});



Route::apiResource('form', FormController::class);
Route::apiResource('jenis-workorder', JenisWorkorderController::class);
Route::apiResource('kpi', KpiController::class);

Route::apiResource('jenis-lokasi', JenisLokasiController::class);
Route::apiResource('workorder', WorkorderController::class);


Route::apiResource('lembur-spl', LemburSplController::class);
Route::apiResource('user', UserController::class);
