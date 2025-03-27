import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_app/config/form_fields_config.dart';
import 'package:work_order_app/core/utils/app_snackbar.dart';
import 'package:work_order_app/core/widget/app_state_page.dart';
import 'package:work_order_app/core/widget/custom_app_bar.dart';
import 'package:work_order_app/core/widget/custom_field_widgets.dart';
import 'package:work_order_app/core/widget/dynamic_form_builder.dart';
import 'package:work_order_app/feature/work_order/data/models/work_order_model.dart';
import 'package:work_order_app/feature/work_order/domain/entities/location_type_entity.dart';
import 'package:work_order_app/feature/work_order/domain/entities/user_entity.dart';
import 'package:work_order_app/feature/work_order/domain/entities/work_order_type_entity.dart';
import 'package:work_order_app/feature/work_order/presentation/bloc/work_order_bloc.dart';
import 'package:work_order_app/feature/work_order/presentation/bloc/work_order_event.dart';
import 'package:work_order_app/feature/work_order/presentation/bloc/work_order_state.dart';
import 'package:work_order_app/feature/work_order/presentation/widgets/button_interaction.dart';

class DetailWorkOrderPage extends StatefulWidget {
  final int? workOrderId;
  final bool isOvertime;
  const DetailWorkOrderPage(
      {super.key, this.workOrderId, required this.isOvertime});

  @override
  State<DetailWorkOrderPage> createState() => _DetailWorkOrderPageState();
}

class _DetailWorkOrderPageState extends AppStatePage<DetailWorkOrderPage> {
  Map<String, dynamic> formData = {};
  List<WorkOrderTypeEntity> workOrderTypes = [];
  List<LocationTypeEntity> locationTypes = [];
  List<UserEntity> assignees = [];
  int? status;

  bool isDataLoaded = false;
  bool get isDetailMode => widget.workOrderId != null;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<WorkOrderBloc>();

    formData["isOvertime"] = widget.isOvertime;

    if (isDetailMode) {
      bloc.add(GetWorkOrderDetailEvent(widget.workOrderId!));
    } else {
      bloc.add(GetWorkOrderTypesEvent());
      bloc.add(GetLocationTypesEvent());
      bloc.add(GetUsersEvent());
    }
  }

  void _onFieldChanged(String key, dynamic value) {
    setState(() {
      formData[key] = value;
    });
  }

  void _checkDataLoaded() {
    if (isDetailMode) {
      // Mode Detail (Pastikan semua field dari formData sudah terisi)
      if (formData.containsKey("assignees") &&
          formData.containsKey("title") &&
          formData.containsKey("startDateTime") &&
          formData.containsKey("duration") &&
          formData.containsKey("durationUnit") &&
          formData.containsKey("endDateTime")) {
        setState(() {
          isDataLoaded = true;
        });
      }
    } else {
      // Mode Pembuatan WO (Hanya butuh dropdown dan daftar user)
      if (workOrderTypes.isNotEmpty &&
          locationTypes.isNotEmpty &&
          assignees.isNotEmpty) {
        setState(() {
          isDataLoaded = true;
        });
      }
    }
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocListener<WorkOrderBloc, WorkOrderState>(
      listener: (context, state) {
        if (state is WorkOrderTypesLoaded) {
          workOrderTypes = state.workOrderTypes;
        }
        if (state is LocationTypesLoaded) {
          locationTypes = state.locationTypes;
        }
        if (state is UsersLoaded) {
          assignees = state.users;
        }
        if (state is WorkOrderDetailLoaded) {
          status = state.workOrder.statusId;
          setState(() {
            formData = {
              "title": state.workOrder.title,
              "jobType": state.workOrder.workOrderType?.name,
              "locationType": state.workOrder.locationType?.locationType,
              "latitude": state.workOrder.latitude,
              "longitude": state.workOrder.longitude,
              "startDateTime": state.workOrder.startDateTime,
              "duration": state.workOrder.duration,
              "durationUnit": state.workOrder.durationUnit,
              "endDateTime": state.workOrder.endDateTime,
              "assignees": state.workOrder.assignees,
            };
            debugPrint("✅ formData Updated: $formData");
            _checkDataLoaded();
          });
        }
        _checkDataLoaded();
      },
      child: BlocBuilder<WorkOrderBloc, WorkOrderState>(
        builder: (context, state) {
          final formFields = (isDetailMode)
              ? FormFieldsConfig.getDetailWorkOrderFields(
                  assigneeOptions: assignees,
                  isDetailMode: isDetailMode,
                  isOvertime: formData["isOvertime"] ?? false,
                )
              : FormFieldsConfig.getWorkOrderFields(
                  jobTypeOptions: workOrderTypes,
                  locationTypeOptions: locationTypes,
                  assigneeOptions: assignees,
                  isDetailMode: isDetailMode,
                  isOvertime: formData["isOvertime"] ?? false,
                );

          return Scaffold(
            appBar: (widget.workOrderId != null)
                ? CustomAppBar(
                    title: (widget.isOvertime)
                        ? "Work Order Lembur"
                        : "Work Order Normal",
                  )
                : null,
            body: state is WorkOrderLoading || !isDataLoaded
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        DynamicFormBuilder(
                          key: ValueKey(formData["isOvertime"]),
                          fields: formFields,
                          formData: formData,
                          onFieldChanged: _onFieldChanged,
                          customWidgets: CustomFieldWidgets.fields,
                        ),
                        ButtonInteraction(
                          status: status,
                          onPressed: widget.workOrderId == null
                              ? _validateAndSubmit
                              : null,
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  void _validateAndSubmit() {
    // Cek apakah semua field sudah terisi
    if (formData["title"] == null || formData["title"].trim().isEmpty) {
      AppSnackbar.showError("Judul tidak boleh kosong.");
      return;
    }
    if (formData["jobType"] == null) {
      AppSnackbar.showError("Jenis pekerjaan harus dipilih.");
      return;
    }
    if (formData["locationType"] == null) {
      AppSnackbar.showError("Jenis lokasi harus dipilih.");
      return;
    }
    if (formData["locationType"] == 1) {
      if (formData["latitude"] == null || formData["longitude"] == null) {
        AppSnackbar.showError("Lokasi harus dipilih.");
        return;
      }
    }
    if (formData["startDateTime"] == null) {
      AppSnackbar.showError("Waktu mulai harus diisi.");
      return;
    }
    if (formData["duration"] == null || formData["duration"] <= 0) {
      AppSnackbar.showError("Durasi harus lebih dari 0.");
      return;
    }
    if (formData["durationUnit"] == null) {
      AppSnackbar.showError("Satuan durasi harus dipilih.");
      return;
    }

    final List<UserEntity> assignees = formData["assignees"] ?? [];
    final List<int> assigneeIds = assignees.map((user) => user.id!).toList();
    debugPrint("🚀 Final Assignees IDs: $assigneeIds"); // Debugging
    if (assigneeIds.isEmpty) {
      AppSnackbar.showError("Minimal 1 petugas harus dipilih.");
      return;
    }

    if (formData["endDateTime"] == null) {
      AppSnackbar.showError("Waktu selesai tidak valid.");
      return;
    }

    // Buat model WorkOrder
    final workOrder = WorkOrderModel(
      title: formData["title"],
      statusId: widget.isOvertime ? 2 : 1, // WO Lembur butuh approval
      startDateTime: formData["startDateTime"],
      duration: formData["duration"],
      durationUnit: formData["durationUnit"],
      endDateTime: formData["endDateTime"],
      assigneeIds: assigneeIds,
      workOrderTypeId: formData["jobType"],
      locationTypeId: formData["locationType"],
      latitude: formData["latitude"],
      longitude: formData["longitude"],
      creator: 1,
      requiresApproval: widget.isOvertime,
    );

    // Kirim ke backend
    final bloc = context.read<WorkOrderBloc>();
    bloc.add(CreateWorkOrderEvent(workOrder));

    // Beri notifikasi ke user
    AppSnackbar.showSuccess("Work order berhasil dibuat.");
    _onSubmit();
  }

  Future<void> _onSubmit() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasi API call

    if (mounted) {
      Navigator.pop(context); // ✅ Hanya dipanggil jika widget masih ada
    }
  } // Kembali ke halaman sebelumnya
}
