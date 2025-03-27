import '/core/resource/data_state.dart';
import '/feature/work_order/domain/repositories/work_order_repository.dart';
import '/core/usecase/usecase.dart';

class DeleteWorkOrderUseCase implements UseCase<Future<DataState<void>>, int> {
  final WorkOrderRepository repository;

  DeleteWorkOrderUseCase(this.repository);

  @override
  Future<DataState<void>> call(int id) {
    return repository.deleteWorkOrder(id);
  }
}
