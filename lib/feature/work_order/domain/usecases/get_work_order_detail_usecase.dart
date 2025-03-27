import '/core/resource/data_state.dart';
import '/feature/work_order/domain/entities/work_order_entity.dart';
import '/feature/work_order/domain/repositories/work_order_repository.dart';
import '/core/usecase/usecase.dart';

class GetWorkOrderDetailUseCase
    implements UseCase<Future<DataState<WorkOrderEntity>>, int> {
  final WorkOrderRepository repository;

  GetWorkOrderDetailUseCase(this.repository);

  @override
  Future<DataState<WorkOrderEntity>> call(int id) {
    return repository.getWorkOrderDetail(id);
  }
}
