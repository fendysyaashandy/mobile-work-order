import 'package:equatable/equatable.dart';

class WorkOrderTypeEntity extends Equatable {
  final int? id;
  final String name;
  // final String? description;

  const WorkOrderTypeEntity({
    this.id,
    required this.name,
    // this.description,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        // description,
      ];

  WorkOrderTypeEntity copyWith({
    int? id,
    String? name,
    // String? description,
  }) {
    return WorkOrderTypeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      // description: description ?? this.description,
    );
  }
}
