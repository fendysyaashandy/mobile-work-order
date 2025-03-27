import 'package:work_order_app/feature/work_order/domain/entities/location_type_entity.dart';
import 'package:work_order_app/feature/work_order/domain/entities/user_entity.dart';
import 'package:work_order_app/feature/work_order/domain/entities/work_order_type_entity.dart';

class FormFieldsConfig {
  static List<Map<String, dynamic>> getWorkOrderFields({
    required List<WorkOrderTypeEntity> jobTypeOptions,
    required List<LocationTypeEntity> locationTypeOptions,
    required List<UserEntity> assigneeOptions,
    required bool isDetailMode,
    required bool isOvertime,
  }) {
    return [
      {
        "type": "text",
        "key": "title",
        "label": "Judul Pekerjaan",
        "hint": "Masukkan judul",
      },
      {
        "type": "dropdown",
        "key": "jobType",
        "label": "Jenis Pekerjaan",
        "hint": "Pilih jenis pekerjaan",
        "options": jobTypeOptions
            .map((type) => {"value": type.id, "label": type.name})
            .toList(),
      },
      {
        "type": "dropdown",
        "key": "locationType",
        "label": "Jenis Lokasi",
        "hint": "Statis / Dinamis",
        "options": locationTypeOptions
            .map((type) => {"value": type.id, "label": type.locationType})
            .toList(),
      },
      {
        "key": "locationPicker",
        "type": "custom",
        "showIf": (formData) => formData["locationType"] == 1,
        "latitude": (formData) => formData["latitude"],
        "longitude": (formData) => formData["longitude"],
      },
      {
        "key": "timeEstimate",
        "type": "custom",
        "showIf": (formData) => true, // 🔹 Selalu tampil
        "isOvertime": isOvertime,
      },
      {
        "key": "isOvertime",
        "type":
            "hidden", // ✅ Bisa ditandai sebagai "hidden" karena tidak perlu ditampilkan di UI
        "value": isOvertime, // ✅ Simpan nilai isOvertime di form fields
      },
      {
        "type": "custom",
        "key": "assignees",
        "options": assigneeOptions, // 🔹 Menggunakan daftar user dari backend
      },
      // {
      //   "type": "chip",
      //   "key": "assignees",
      //   "label": "Petugas",
      //   "options": assigneeOptions
      // },
    ];
  }

  static List<Map<String, dynamic>> getDetailWorkOrderFields({
    required List<UserEntity> assigneeOptions,
    required bool isDetailMode,
    required bool isOvertime,
  }) {
    return [
      {
        "type": "text",
        "key": "title",
        "label": "Judul Pekerjaan",
        "hint": "Masukkan judul",
        "isReadOnly": isDetailMode
      },
      {
        "type": "text",
        "key": "jobType",
        "label": "Jenis Pekerjaan",
        "hint": "Pilih jenis pekerjaan",
        "isReadOnly": isDetailMode
      },
      {
        "type": "text",
        "key": "locationType",
        "label": "Jenis Lokasi",
        "hint": "Statis / Dinamis",
        "isReadOnly": isDetailMode
      },
      {
        "key": "locationPicker",
        "type": "custom",
        "showIf": (formData) => formData["locationType"] == "Statis",
        "latitude": (formData) => formData["latitude"],
        "longitude": (formData) => formData["longitude"],
        "isReadOnly": isDetailMode
      },
      {
        "key": "timeEstimate",
        "type": "custom",
        "showIf": (formData) => true, // 🔹 Selalu tampil
        "isOvertime": isOvertime,
        "startDateTime": (formData) => formData["startDateTime"],
        "duration": (formData) => formData["duration"],
        "durationUnit": (formData) => formData["durationUnit"],
        "endDateTime": (formData) => formData["endDateTime"],
        "isReadOnly": isDetailMode
      },
      {
        "key": "isOvertime",
        "type":
            "hidden", // ✅ Bisa ditandai sebagai "hidden" karena tidak perlu ditampilkan di UI
        "value": isOvertime, // ✅ Simpan nilai isOvertime di form fields
      },
      {
        "type": "custom",
        "key": "assignees",
        "options": assigneeOptions, // 🔹 Menggunakan daftar user dari backend
        "isReadOnly": isDetailMode,
      },
      // {
      //   "type": "chip",
      //   "key": "assignees",
      //   "label": "Petugas",
      //   "options": assigneeOptions
      // },
    ];
  }
}
