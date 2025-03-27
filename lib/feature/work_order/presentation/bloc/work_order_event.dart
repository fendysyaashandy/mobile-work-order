import '/feature/work_order/domain/entities/work_order_entity.dart';

abstract class WorkOrderEvent {}

class GetWorkOrdersEvent extends WorkOrderEvent {}

class LoadMoreWorkOrdersEvent extends WorkOrderEvent {
  final int page;
  final int limit;

  LoadMoreWorkOrdersEvent(this.page, this.limit);
}

class GetWorkOrderDetailEvent extends WorkOrderEvent {
  final int id;

  GetWorkOrderDetailEvent(this.id);
}

class CreateWorkOrderEvent extends WorkOrderEvent {
  final WorkOrderEntity workOrder;

  CreateWorkOrderEvent(this.workOrder);
}

class UpdateWorkOrderEvent extends WorkOrderEvent {
  final WorkOrderEntity workOrder;

  UpdateWorkOrderEvent(this.workOrder);
}

class DeleteWorkOrderEvent extends WorkOrderEvent {
  final int id;

  DeleteWorkOrderEvent(this.id);
}

//work order type
class GetWorkOrderTypesEvent extends WorkOrderEvent {}

class GetWorkOrderTypeDetailEvent extends WorkOrderEvent {
  final int id;

  GetWorkOrderTypeDetailEvent(this.id);
}

//location type
class GetLocationTypesEvent extends WorkOrderEvent {}

class GetLocationTypeDetailEvent extends WorkOrderEvent {
  final int id;

  GetLocationTypeDetailEvent(this.id);
}

//user
class GetUsersEvent extends WorkOrderEvent {}

class GetUserDetailEvent extends WorkOrderEvent {
  final int id;

  GetUserDetailEvent(this.id);
}
