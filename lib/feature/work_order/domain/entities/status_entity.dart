import 'package:equatable/equatable.dart';

class StatusEntity extends Equatable {
  final int? id;
  final String? status;

  const StatusEntity({
    this.id,
    this.status,
  });

  @override
  List<Object?> get props => [
        id,
        status,
      ];

  StatusEntity copyWith({
    int? id,
    String? status,
  }) {
    return StatusEntity(
      id: id ?? this.id,
      status: status ?? this.status,
    );
  }
}
