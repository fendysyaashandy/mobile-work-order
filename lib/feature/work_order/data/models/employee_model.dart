import 'dart:convert';

import 'package:work_order_app/feature/work_order/domain/entities/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    super.id,
    super.name,
    super.nip,
    super.birthDate,
    super.gender,
    super.address,
    super.phone,
    super.departmentId,
    super.positionId,
  });

  factory EmployeeModel.fromJson(String source) =>
      EmployeeModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'],
      name: map['nama'],
      nip: map['nip'],
      birthDate: map['tanggal_lahir'] != null
          ? DateTime.tryParse(map['tanggal_lahir'])
          : null,
      gender: map['jenis_kelamin'],
      address: map['alamat'],
      phone: map['telepon'],
      departmentId: map['departemen_id'],
      positionId: map['jabatan_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': name,
      'nip': nip,
      'tanggal_lahir': birthDate?.toIso8601String(),
      'jenis_kelamin': gender,
      'alamat': address,
      'telepon': phone,
      'departemen_id': departmentId,
      'jabatan_id': positionId,
    };
  }

  EmployeeEntity toEntity() {
    return EmployeeEntity(
      id: id,
      name: name,
      nip: nip,
      birthDate: birthDate,
      gender: gender,
      address: address,
      phone: phone,
      departmentId: departmentId,
      positionId: positionId,
    );
  }

  factory EmployeeModel.fromEntity(EmployeeEntity entity) {
    return EmployeeModel(
      id: entity.id,
      name: entity.name,
      nip: entity.nip,
      birthDate: entity.birthDate,
      gender: entity.gender,
      address: entity.address,
      phone: entity.phone,
      departmentId: entity.departmentId,
      positionId: entity.positionId,
    );
  }
}
