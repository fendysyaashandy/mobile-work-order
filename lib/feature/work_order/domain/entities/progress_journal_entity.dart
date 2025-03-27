import 'package:equatable/equatable.dart';

class ProgressJournalEntity extends Equatable {
  final int? id;
  final int workOrderId;
  final String description;
  final String date;

  const ProgressJournalEntity({
    this.id,
    required this.workOrderId,
    required this.description,
    required this.date,
  });

  @override
  List<Object?> get props => [id, workOrderId, description, date];

  ProgressJournalEntity copyWith({
    int? id,
    int? workOrderId,
    String? description,
    String? date,
  }) {
    return ProgressJournalEntity(
      id: id ?? this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }
}
