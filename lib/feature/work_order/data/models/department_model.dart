import 'dart:convert';
import '/feature/work_order/domain/entities/department_entity.dart';

class DepartmentModel extends DepartmentEntity {
  const DepartmentModel({
    super.id,
    required super.name,
    required super.jobTypes,
  });

  factory DepartmentModel.fromJson(String source) =>
      DepartmentModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      id: map['id'],
      name: map['name'],
      jobTypes: List<String>.from(map['jobTypes']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'jobTypes': jobTypes,
    };
  }

  DepartmentEntity toEntity() {
    return DepartmentEntity(
      id: id,
      name: name,
      jobTypes: jobTypes,
    );
  }

  factory DepartmentModel.fromEntity(DepartmentEntity entity) {
    return DepartmentModel(
      id: entity.id,
      name: entity.name,
      jobTypes: entity.jobTypes,
    );
  }
}
