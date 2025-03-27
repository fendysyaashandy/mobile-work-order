import 'package:sqflite/sqflite.dart';
import '/core/resource/data_state.dart';
import '/core/resource/local_data_source.dart';
import '/feature/work_order/data/models/work_order_model.dart';

class WorkOrderLocalDataSource extends LocalDataSource<WorkOrderModel> {
  final Database database;

  WorkOrderLocalDataSource(this.database);

  @override
  Future<DataState<List<WorkOrderModel>>> fetchAll() async {
    try {
      final List<Map<String, dynamic>> maps =
          await database.query('work_orders');
      print("📂 Data dari database lokal: $maps"); // ✅ Log isi database
      final data = List.generate(maps.length, (i) {
        return WorkOrderModel.fromMap(maps[i]);
      });
      print("✅ Work Order ditemukan: ${data.length}");
      return DataSuccess(data);
    } catch (e) {
      print("❌ Gagal mengambil data dari database: $e");
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<WorkOrderModel>> fetchById(int id) async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        'work_orders',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return DataSuccess(WorkOrderModel.fromMap(maps.first));
      } else {
        return const DataFailed('WorkOrder not found');
      }
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> create(WorkOrderModel workOrder) async {
    try {
      await database.insert('work_orders', workOrder.toMap());
      print(
          "✅ Work Order berhasil disimpan: ${workOrder.toMap()}"); // Tambahkan log ini
      return const DataSuccess(null);
    } catch (e) {
      print("❌ Gagal menyimpan Work Order: $e"); // Tambahkan log error
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> update(WorkOrderModel workOrder) async {
    try {
      await database.update(
        'work_orders',
        workOrder.toMap(),
        where: 'id = ?',
        whereArgs: [workOrder.id],
      );
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> delete(int id) async {
    try {
      await database.delete(
        'work_orders',
        where: 'id = ?',
        whereArgs: [id],
      );
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
