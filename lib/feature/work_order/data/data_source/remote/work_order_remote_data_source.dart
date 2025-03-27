import 'package:dio/dio.dart';
import '/core/resource/data_state.dart';
import '/feature/work_order/data/models/work_order_model.dart';
import '/core/resource/remote_data_source.dart';

class WorkOrderRemoteDataSource extends RemoteDatasource {
  WorkOrderRemoteDataSource() : super();

  Future<DataState<List<WorkOrderModel>>> fetchWorkOrders(
      int page, int limit) async {
    try {
      final response = await dio.get(
        '/workorder',
        queryParameters: {'page': page, 'limit': limit},
      );
      final data = response.data['data']
          .map<WorkOrderModel>((json) => WorkOrderModel.fromMap(json))
          .toList();
      final totalPages = response.data['totalPages'];
      final currentPage = response.data['currentPage'];
      return PaginatedDataSuccess(
        data,
        totalPages: totalPages,
        currentPage: currentPage,
      );
    } catch (e) {
      return DataFailed(DioException(
        error: e,
        requestOptions: RequestOptions(path: '/workorder'),
      ));
    }
  }

  Future<DataState<WorkOrderModel>> fetchWorkOrderDetail(int id) async {
    try {
      final response = await dio.get('/workorder/$id'); // Perbaikan di sini
      final data = WorkOrderModel.fromMap(response.data);
      return DataSuccess(data);
    } catch (e) {
      return DataFailed(DioException(
        error: e,
        requestOptions: RequestOptions(path: '/workorder/$id'),
      ));
    }
  }

  Future<DataState<WorkOrderModel>> createWorkOrder(
      WorkOrderModel workOrder) async {
    try {
      print("📤 Mengirim request ke API: ${dio.options.baseUrl}/workorder");
      print("📤 Data yang dikirim: ${workOrder.toMap()}");

      final response = await dio.post(
        '/workorder',
        data: workOrder.toMap(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            "X-Requested-With": "XMLHttpRequest",
          },
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );
      print("📥 Response: ${response.statusCode} - ${response.data}");
      final data = WorkOrderModel.fromMap(response.data);
      return DataSuccess(data);
    } catch (e) {
      return DataFailed(DioException(
        error: e,
        requestOptions: RequestOptions(path: '/workorder'),
      ));
    }
  }

  Future<DataState<WorkOrderModel>> updateWorkOrder(
      WorkOrderModel workOrder) async {
    try {
      final response = await dio.put(
        '/workorder/${workOrder.id}', // Perbaikan di sini
        data: workOrder.toMap(),
      );
      final data = WorkOrderModel.fromMap(response.data);
      return DataSuccess(data);
    } catch (e) {
      return DataFailed(DioException(
        error: e,
        requestOptions: RequestOptions(path: '/workorder/${workOrder.id}'),
      ));
    }
  }

  Future<DataState<void>> deleteWorkOrder(int id) async {
    try {
      await dio.delete('/workorder/$id'); // Perbaikan di sini
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(DioException(
        error: e,
        requestOptions: RequestOptions(path: '/workorder/$id'),
      ));
    }
  }
}
