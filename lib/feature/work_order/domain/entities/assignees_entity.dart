import 'package:equatable/equatable.dart';

class AssigneesEntity extends Equatable {
  final int? workOrderId;
  final int? userId;

  const AssigneesEntity({
    this.workOrderId,
    this.userId,
  });

  @override
  List<Object?> get props => [
        workOrderId,
        userId,
      ];

  AssigneesEntity copyWith({int? workOrderId, int? userId}) {
    return AssigneesEntity(
      workOrderId: workOrderId ?? this.workOrderId,
      userId: userId ?? this.userId,
    );
  }
}
