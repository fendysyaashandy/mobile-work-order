import 'package:equatable/equatable.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:work_order_app/feature/work_order/domain/entities/location_type_entity.dart';
import 'package:work_order_app/feature/work_order/domain/entities/status_entity.dart';
import 'package:work_order_app/feature/work_order/domain/entities/user_entity.dart';
import 'package:work_order_app/feature/work_order/domain/entities/work_order_type_entity.dart';

class WorkOrderEntity extends Equatable {
  final int? id;
  final String title;
  final DateTime? startDateTime;
  final int? duration;
  final String? durationUnit;
  final DateTime? endDateTime;
  final double? longitude;
  final double? latitude;
  final int? creator;
  final int? statusId; //Mengambil dari Status
  final int? workOrderTypeId; //Mengambil dari WorkOrderType
  final int? locationTypeId; //Mengambil dari LocationType
  final bool requiresApproval;
  final List<int>? assigneeIds;
  final List<UserEntity>? assignees;
  final LocationTypeEntity? locationType;
  final WorkOrderTypeEntity? workOrderType;
  final StatusEntity? status;

  // final AssigneesEntity? assignees;
  // final String? description;
  // final LocationEntity? location;
  // final DepartmentEntity? department;

  const WorkOrderEntity({
    this.id,
    required this.title,
    this.startDateTime,
    this.duration,
    this.durationUnit,
    this.endDateTime,
    this.longitude,
    this.latitude,
    this.creator,
    this.statusId,
    this.workOrderTypeId,
    this.locationTypeId,
    this.requiresApproval = false,
    this.assigneeIds,
    this.assignees,
    this.locationType,
    this.workOrderType,
    this.status,

    // this.description,
    // this.location,
    // this.department,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        startDateTime,
        duration,
        durationUnit,
        endDateTime,
        longitude,
        latitude,
        creator,
        statusId,
        workOrderTypeId,
        locationTypeId,
        requiresApproval,
        assigneeIds,
        assignees,
        locationType,
        workOrderType,
        status,

        // description,
        // assignees,
        // location,
        // department,
      ];

  WorkOrderEntity copyWith({
    int? id,
    String? title,
    DateTime? startDateTime,
    int? duration,
    String? durationUnit,
    DateTime? endDateTime,
    double? longitude,
    double? latitude,
    int? creator,
    int? statusId,
    int? workOrderTypeId,
    int? locationTypeId,
    bool? requiresApproval,
    List<int>? assigneeIds,
    List<UserEntity>? assignees,
    LocationTypeEntity? locationType,
    WorkOrderTypeEntity? workOrderType,
    StatusEntity? status,

    // String? description,
    // List<String>? assignees,
    // LocationEntity? location,
    // DepartmentEntity? department,
  }) {
    return WorkOrderEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      startDateTime: startDateTime ?? this.startDateTime,
      duration: duration ?? this.duration,
      durationUnit: durationUnit ?? this.durationUnit,
      endDateTime: endDateTime ?? this.endDateTime,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      creator: creator ?? this.creator,
      statusId: statusId ?? this.statusId,
      workOrderTypeId: workOrderTypeId ?? this.workOrderTypeId,
      locationTypeId: locationTypeId ?? this.locationTypeId,
      requiresApproval: requiresApproval ?? this.requiresApproval,
      assigneeIds: assigneeIds ?? this.assigneeIds,
      assignees: assignees ?? this.assignees,
      locationType: locationType ?? this.locationType,
      workOrderType: workOrderType ?? this.workOrderType,
      status: status ?? this.status,

      // description: description ?? description,
      // assignees: assignees ?? this.assignees,
      // location: location ?? this.location,
      // department: department ?? this.department,
    );
  }
}
