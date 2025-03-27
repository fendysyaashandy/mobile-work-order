import '/core/resource/data_state.dart';
import '/feature/work_order/domain/entities/work_order_entity.dart';
import '/feature/work_order/domain/repositories/work_order_repository.dart';
import '/core/usecase/usecase.dart';

class GetWorkOrdersUseCase
    implements
        UseCase<Future<DataState<List<WorkOrderEntity>>>, WorkOrderParams> {
  final WorkOrderRepository repository;

  GetWorkOrdersUseCase(this.repository);

  @override
  Future<DataState<List<WorkOrderEntity>>> call(WorkOrderParams params) {
    return repository.getWorkOrders(params.page, params.limit);
  }
}

class WorkOrderParams {
  final int page;
  final int limit;

  WorkOrderParams({required this.page, required this.limit});
}
