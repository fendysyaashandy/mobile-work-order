import '/core/resource/data_state.dart';
import '/feature/work_order/domain/entities/work_order_entity.dart';

abstract class WorkOrderRepository {
  Future<DataState<List<WorkOrderEntity>>> getWorkOrders(int page, int limit);
  Future<DataState<WorkOrderEntity>> getWorkOrderDetail(int id);
  Future<DataState<WorkOrderEntity>> createWorkOrder(WorkOrderEntity workOrder);
  Future<DataState<WorkOrderEntity>> updateWorkOrder(WorkOrderEntity workOrder);
  Future<DataState<void>> deleteWorkOrder(int id);
  // Future<DataState<LocationEntity>> getCurrentLocation();
  // Future<DataState<WorkOrderEntity>> updateLocation(
  //     double latitude, double longitude);
}
