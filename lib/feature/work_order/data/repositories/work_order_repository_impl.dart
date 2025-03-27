import 'package:flutter/material.dart';
import 'package:work_order_app/feature/work_order/data/data_source/local/work_order_local_data_source.dart';
import 'package:work_order_app/feature/work_order/data/data_source/remote/work_order_remote_data_source.dart';
import '/core/resource/data_state.dart';
import '/feature/work_order/data/models/work_order_model.dart';
import '/feature/work_order/domain/entities/work_order_entity.dart';
import '/feature/work_order/domain/repositories/work_order_repository.dart';

class WorkOrderRepositoryImpl implements WorkOrderRepository {
  final WorkOrderRemoteDataSource remoteDataSource;
  final WorkOrderLocalDataSource localDataSource;

  WorkOrderRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<DataState<List<WorkOrderEntity>>> getWorkOrders(
    int page,
    int limit,
  ) async {
    try {
      final response = await remoteDataSource.fetchWorkOrders(page, limit);
      debugPrint("📥 Data dari RemoteDataSource: $response");
      if (response is PaginatedDataSuccess<List<WorkOrderModel>>) {
        final entities =
            response.data!.map((model) => model.toEntity()).toList();
        // for (var workOrder in response.data!) {
        //   await localDataSource.create(workOrder);
        // }
        return PaginatedDataSuccess(
          entities,
          totalPages: response.totalPages,
          currentPage: response.currentPage,
        );
      } else {
        final localResponse = await localDataSource.fetchAll();
        if (localResponse is DataSuccess<List<WorkOrderModel>>) {
          final localEntities =
              localResponse.data!.map((model) => model.toEntity()).toList();
          return DataSuccess(localEntities);
        } else {
          return DataFailed(response.error!);
        }
      }
    } catch (e) {
      return DataFailed("Terjadi kesalahan: $e");
    }
  }

  @override
  Future<DataState<WorkOrderEntity>> getWorkOrderDetail(int id) async {
    final response = await remoteDataSource.fetchWorkOrderDetail(id);
    if (response is DataSuccess<WorkOrderModel>) {
      return DataSuccess(response.data!.toEntity());
    } else {
      final localResponse = await localDataSource.fetchById(id);
      if (localResponse is DataSuccess<WorkOrderModel>) {
        return DataSuccess(localResponse.data!.toEntity());
      } else {
        return DataFailed(response.error!);
      }
    }
  }

  @override
  Future<DataState<WorkOrderEntity>> createWorkOrder(
      WorkOrderEntity workOrder) async {
    try {
      final model = WorkOrderModel.fromEntity(workOrder);
      final response = await remoteDataSource.createWorkOrder(model);
      if (response is DataSuccess<WorkOrderModel>) {
        return DataSuccess(response.data!.toEntity());
      } else {
        return DataFailed("Gagal menyimpan work order ke server.");
      }
    } catch (e) {
      return DataFailed("Terjadi kesalahan saat menyimpan: $e");
    }
  }

  @override
  Future<DataState<WorkOrderEntity>> updateWorkOrder(
      WorkOrderEntity workOrder) async {
    final model = WorkOrderModel.fromEntity(workOrder);
    final response = await remoteDataSource.updateWorkOrder(model);
    if (response is DataSuccess<WorkOrderModel>) {
      await localDataSource.update(response.data!);
      return DataSuccess(response.data!.toEntity());
    } else {
      final localResponse = await localDataSource.update(model);
      if (localResponse is DataSuccess<WorkOrderModel>) {
        return DataSuccess(localResponse.data!.toEntity());
      } else {
        return DataFailed(response.error!);
      }
    }
  }

  @override
  Future<DataState<void>> deleteWorkOrder(int id) async {
    final response = await remoteDataSource.deleteWorkOrder(id);
    if (response is DataSuccess) {
      await localDataSource.delete(id);
      return const DataSuccess(null);
    } else {
      final localResponse = await localDataSource.delete(id);
      if (localResponse is DataSuccess) {
        return const DataSuccess(null);
      } else {
        return DataFailed(response.error!);
      }
    }
  }
}
