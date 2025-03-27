import 'dart:convert';

import 'package:work_order_app/feature/work_order/domain/entities/work_order_type_entity.dart';

class WorkOrderTypeModel extends WorkOrderTypeEntity {
  const WorkOrderTypeModel({
    super.id,
    required super.name,
    // super.description,
  });

  factory WorkOrderTypeModel.fromJson(String source) =>
      WorkOrderTypeModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  factory WorkOrderTypeModel.fromMap(Map<String, dynamic> map) {
    print("📢 parsing jenis workorder: $map");
    return WorkOrderTypeModel(
      id: map['id'],
      name: map['nama'] ?? 'Unknown',
      // description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': name,
      // 'description': description,
    };
  }

  WorkOrderTypeEntity toEntity() {
    return WorkOrderTypeEntity(
      id: id,
      name: name,
      // description: description,
    );
  }

  factory WorkOrderTypeModel.fromEntity(WorkOrderTypeEntity entity) {
    return WorkOrderTypeModel(
      id: entity.id,
      name: entity.name,
      // description: entity.description,
    );
  }
}
