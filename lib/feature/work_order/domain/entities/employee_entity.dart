import 'package:equatable/equatable.dart';

class EmployeeEntity extends Equatable {
  final int? id;
  final String? name;
  final String? nip;
  final DateTime? birthDate;
  final String? gender;
  final String? address;
  final String? phone;
  final int? departmentId;
  final int? positionId;

  const EmployeeEntity({
    this.id,
    this.name,
    this.nip,
    this.birthDate,
    this.gender,
    this.address,
    this.phone,
    this.departmentId,
    this.positionId,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        nip,
        birthDate,
        address,
        phone,
        departmentId,
        positionId,
      ];

  EmployeeEntity copyWith({
    int? id,
    String? name,
    String? nip,
    DateTime? birthDate,
    String? address,
    String? phone,
    int? departmentId,
    int? positionId,
  }) {
    return EmployeeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      nip: nip ?? this.nip,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      departmentId: departmentId ?? this.departmentId,
      positionId: positionId ?? this.positionId,
    );
  }
}
