import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? id;
  // final int? employeeId;
  final int? roleId; // 'giver', 'receiver', 'both'
  final String? email;

  const UserEntity({
    this.id,
    // this.employeeId,
    this.roleId,
    required this.email,
  });

  @override
  List<Object?> get props => [
        id,
        // employeeId,
        roleId,
        email,
      ];

  UserEntity copyWith({
    int? id,
    // int? employeeId,
    int? roleId,
    String? email,
  }) {
    return UserEntity(
      id: id ?? this.id,
      // employeeId: employeeId ?? this.employeeId,
      roleId: roleId ?? this.roleId,
      email: email ?? this.email,
    );
  }
}
