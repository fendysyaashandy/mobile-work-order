import 'package:equatable/equatable.dart';

class DepartmentEntity extends Equatable {
  final int? id;
  final String? name;
  final List<String>? jobTypes; // Daftar jenis pekerjaan

  const DepartmentEntity({
    this.id,
    this.name,
    this.jobTypes,
  });

  @override
  List<Object?> get props => [id, name, jobTypes];

  DepartmentEntity copyWith({
    int? id,
    String? name,
    List<String>? jobTypes,
  }) {
    return DepartmentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      jobTypes: jobTypes ?? this.jobTypes,
    );
  }
}
