import '/core/resource/data_state.dart';
import '/feature/work_order/domain/entities/work_order_entity.dart';
import '/feature/work_order/domain/repositories/work_order_repository.dart';
import '/core/usecase/usecase.dart';

class CreateWorkOrderUseCase
    implements UseCase<Future<DataState<WorkOrderEntity>>, WorkOrderEntity> {
  final WorkOrderRepository repository;

  CreateWorkOrderUseCase(this.repository);

  @override
  Future<DataState<WorkOrderEntity>> call(WorkOrderEntity workOrder) {
    return repository.createWorkOrder(workOrder);
  }
}
