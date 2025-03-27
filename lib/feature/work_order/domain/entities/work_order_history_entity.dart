import 'package:equatable/equatable.dart';

class WorkOrderHistoryEntity extends Equatable {
  final int? id;
  final int workOrderId;
  final String status;
  final String date;

  const WorkOrderHistoryEntity({
    this.id,
    required this.workOrderId,
    required this.status,
    required this.date,
  });

  @override
  List<Object?> get props => [id, workOrderId, status, date];

  WorkOrderHistoryEntity copyWith({
    int? id,
    int? workOrderId,
    String? status,
    String? date,
  }) {
    return WorkOrderHistoryEntity(
      id: id ?? this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }
}
