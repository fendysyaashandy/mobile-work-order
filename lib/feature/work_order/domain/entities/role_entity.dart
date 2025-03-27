import 'package:equatable/equatable.dart';

class RoleEntity extends Equatable {
  final int? id;
  final String? name;
  final String? description;

  const RoleEntity({
    this.id,
    this.name,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, description];

  RoleEntity copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return RoleEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
