import 'package:work_order_app/feature/work_order/domain/entities/location_type_entity.dart';
import 'package:work_order_app/feature/work_order/domain/entities/user_entity.dart';
import 'package:work_order_app/feature/work_order/domain/entities/work_order_type_entity.dart';

import '/feature/work_order/domain/entities/work_order_entity.dart';

abstract class WorkOrderState {}

class WorkOrderInitial extends WorkOrderState {}

class WorkOrderLoading extends WorkOrderState {}

class WorkOrderLoaded extends WorkOrderState {
  final List<WorkOrderEntity> workOrders;

  WorkOrderLoaded(this.workOrders);
}

class WorkOrderDetailLoaded extends WorkOrderState {
  final WorkOrderEntity workOrder;

  WorkOrderDetailLoaded(this.workOrder);
}

class WorkOrderCreated extends WorkOrderState {
  final WorkOrderEntity workOrder;

  WorkOrderCreated(this.workOrder);
}

class WorkOrderUpdated extends WorkOrderState {
  final WorkOrderEntity workOrder;

  WorkOrderUpdated(this.workOrder);
}

class WorkOrderDeleted extends WorkOrderState {}

//work order type
class WorkOrderTypesLoaded extends WorkOrderState {
  final List<WorkOrderTypeEntity> workOrderTypes;

  WorkOrderTypesLoaded(this.workOrderTypes);
}

class WorkOrderTypeDetailLoaded extends WorkOrderState {
  final WorkOrderTypeEntity workOrderType;

  WorkOrderTypeDetailLoaded(this.workOrderType);
}

//location type
class LocationTypesLoaded extends WorkOrderState {
  final List<LocationTypeEntity> locationTypes;

  LocationTypesLoaded(this.locationTypes);
}

class LocationTypeDetailLoaded extends WorkOrderState {
  final LocationTypeEntity locationType;

  LocationTypeDetailLoaded(this.locationType);
}

//user
class UsersLoaded extends WorkOrderState {
  final List<UserEntity> users;

  UsersLoaded(this.users);
}

class UserDetailLoaded extends WorkOrderState {
  final UserEntity user;

  UserDetailLoaded(this.user);
}

class WorkOrderError extends WorkOrderState {
  final String message;

  WorkOrderError(this.message);
}
