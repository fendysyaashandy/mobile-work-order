import 'dart:convert';

import 'package:work_order_app/feature/work_order/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.id,
    // super.employeeId,
    super.roleId,
    super.email,
    // super.password,
  });

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> map) {
    print("📢 parsing user: $map");
    return UserModel(
      id: map['id'],
      // employeeId: map['employeeId'],
      roleId: map['role_id'],
      email: map['email'],
      // password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // 'employeeId': employeeId,
      'email': email,
      'role_id': roleId,
      // 'password': password,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      // employeeId: employeeId,
      email: email,
      roleId: roleId,
      // password: password,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      // employeeId: entity.employeeId,
      email: entity.email,
      roleId: entity.roleId,
      // password: entity.password,
    );
  }
}
