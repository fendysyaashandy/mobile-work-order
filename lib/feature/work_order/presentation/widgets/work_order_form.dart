import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:work_order_app/core/utils/app_snackbar.dart';
import 'package:work_order_app/core/widget/custom_form.dart';
import 'package:work_order_app/core/widget/app_state_page.dart';
import 'package:work_order_app/core/widget/input_chip/editable_chip_field.dart';
import 'package:work_order_app/core/widget/location_picker.dart';
import 'package:work_order_app/feature/work_order/data/models/work_order_model.dart';
import 'package:work_order_app/feature/work_order/domain/entities/location_type_entity.dart';
import 'package:work_order_app/feature/work_order/domain/entities/user_entity.dart';
import 'package:work_order_app/feature/work_order/domain/entities/work_order_type_entity.dart';
import 'package:work_order_app/feature/work_order/presentation/bloc/work_order_bloc.dart';
import 'package:work_order_app/feature/work_order/presentation/bloc/work_order_event.dart';
import 'package:work_order_app/feature/work_order/presentation/bloc/work_order_state.dart';

class WorkOrderForm extends StatefulWidget {
  final bool isOvertime; // True untuk WO Lembur, False untuk WO Normal

  const WorkOrderForm({super.key, required this.isOvertime});

  @override
  State<WorkOrderForm> createState() => _WorkOrderFormState();
}

class _WorkOrderFormState extends AppStatePage<WorkOrderForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  final GlobalKey<EditableChipFieldState> _chipFieldKey =
      GlobalKey<EditableChipFieldState>();

  int? _selectedJobType;
  int? _selectedLocationType;
  String _selectedDurationType = ''; // Default "Jam"
  double? _latitude;
  double? _longitude;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int? _duration;
  DateTime? endDateTime;

  final List<String> normalDurationOptions = ['Jam', 'Hari', 'Bulan'];
  final List<String> overtimeDurationOptions = ['Jam'];
  List<WorkOrderTypeEntity> workOrderTypes = [];
  List<LocationTypeEntity> locationTypes = [];
  List<UserEntity> users = [];

  @override
  void initState() {
    super.initState();
    final bloc = context.read<WorkOrderBloc>();
    bloc.add(GetUsersEvent());
    bloc.add(GetWorkOrderTypesEvent());
    bloc.add(GetLocationTypesEvent());
  }

  @override
  void didUpdateWidget(WorkOrderForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOvertime != oldWidget.isOvertime) {
      setState(() {
        _resetFormFields();
      });
    }
  }

  void _resetFormFields() {
    _titleController.clear();
    _dateController.clear();
    _timeController.clear();
    _durationController.clear();
    _selectedJobType = null;
    _selectedLocationType = null;
    _selectedDurationType =
        widget.isOvertime ? overtimeDurationOptions.first : ''; // Default "Jam"
    selectedDate = null;
    selectedTime = null;
    endDateTime = null;
    _chipFieldKey.currentState?.clear();
    setState(() {});
  }

  void _calculateEndDateTime() {
    if (selectedDate != null && selectedTime != null) {
      DateTime startDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      DateTime calculatedEndDateTime;
      int durationValue = int.tryParse(_durationController.text) ?? 0;

      if (_selectedDurationType == 'Jam') {
        calculatedEndDateTime =
            startDateTime.add(Duration(hours: durationValue));
      } else if (_selectedDurationType == 'Hari') {
        calculatedEndDateTime =
            startDateTime.add(Duration(days: durationValue));
      } else if (_selectedDurationType == 'Bulan') {
        calculatedEndDateTime = DateTime(
          startDateTime.year,
          startDateTime.month + durationValue, // ✅ Tambahkan bulan langsung
          startDateTime.day,
          startDateTime.hour,
          startDateTime.minute,
        );
      } else {
        calculatedEndDateTime =
            startDateTime; // Jika unit tidak dikenal, biarkan tetap sama
      }

      setState(() {
        endDateTime = calculatedEndDateTime;
      });
    }
  }

  void _onSubmit() {
    _calculateEndDateTime();

    if (endDateTime == null) {
      AppSnackbar.showError("Waktu selesai tidak valid.");
      return;
    }

    List<int> assignees =
        _chipFieldKey.currentState?.users.map((u) => u.id!).toList() ?? [];

    final workOrder = WorkOrderModel(
      title: _titleController.text,
      statusId: widget.isOvertime ? 2 : 1,
      startDateTime: DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      ),
      duration: int.parse(_durationController.text), // ✅ Simpan angka asli
      durationUnit: _selectedDurationType, // ✅ Simpan unit asli tanpa konversi
      endDateTime: endDateTime,
      // assignees: assignees,
      workOrderTypeId: _selectedJobType,
      locationTypeId: _selectedLocationType,
      latitude: _latitude,
      longitude: _longitude,
      creator: 1,
      requiresApproval: widget.isOvertime,
    );

    final bloc = context.read<WorkOrderBloc>();
    bloc.add(CreateWorkOrderEvent(workOrder));
    AppSnackbar.showSuccess("Work order berhasil dibuat.");
  }

  String _formatEndDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('EEEE, dd MMMM yyyy HH:mm \'WIB\'');
    return formatter.format(dateTime);
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<WorkOrderBloc, WorkOrderState>(
      builder: (context, state) {
        if (state is WorkOrderTypesLoaded) {
          workOrderTypes = state.workOrderTypes; // Simpan hasil ke variabel
        }
        if (state is LocationTypesLoaded) {
          locationTypes = state.locationTypes;
        }
        if (state is UsersLoaded) {
          users = state.users;
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Pekerjaan
              CustomForm(
                controller: _titleController,
                hintText: 'Judul Pekerjaan',
                labelText: 'Judul pekerjaan',
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul pekerjaan tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              // Jenis Pekerjaan
              CustomForm(
                hintText: 'Pilih Jenis Pekerjaan',
                labelText: 'Jenis Pekerjaan',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis pekerjaan tidak boleh kosong';
                  }
                  return null;
                },
                inputType: InputType.dropdown,
                dropdownItems: workOrderTypes.map((type) {
                  return DropdownMenuItem<int>(
                    value: type.id,
                    child: Text(type.name), // Menampilkan nama pekerjaan
                  );
                }).toList(),
                dropdownValue: _selectedJobType,
                onDropdownChanged: (value) {
                  setState(() {
                    _selectedJobType = value!;
                  });
                },
              ),

              const SizedBox(height: 10),

              // Jenis Lokasi
              CustomForm(
                hintText: 'Statis / Dinamis',
                labelText: 'Jenis Lokasi',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis lokasi tidak boleh kosong';
                  }
                  return null;
                },
                inputType: InputType.dropdown,
                dropdownItems: locationTypes.map((type) {
                  return DropdownMenuItem<int>(
                    value: type.id,
                    child:
                        Text(type.locationType), // Menampilkan nama pekerjaan
                  );
                }).toList(),
                dropdownValue: _selectedLocationType,
                onDropdownChanged: (value) =>
                    setState(() => _selectedLocationType = value!),
              ),
              const SizedBox(height: 10),
              if (_selectedLocationType == 1)
                LocationPicker(
                    isStatic: true,
                    onLocationSelected: (lat, long) {
                      setState(() {
                        _latitude = lat;
                        _longitude = long;
                      });
                    }),

              // Peta yang modular
              // const SizedBox(
              //   height: 300, // Define a fixed height for the LocationPicker
              //   child: LocationPicker(),
              // ),

              const SizedBox(height: 10),

              // Estimasi Waktu
              const Text("Estimasi Waktu WO"),
              Row(
                children: [
                  // Pilih Tanggal
                  const SizedBox(
                    width: 50,
                    child: Text("Mulai"),
                  ),

                  Expanded(
                    child: CustomForm(
                      controller: _dateController,
                      hintText: 'Pilih Tanggal',
                      labelText: "",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal tidak boleh kosong';
                        }
                        return null;
                      },
                      suffixIcon: const Icon(Icons.calendar_today),
                      readOnly: true,
                      onTap: () {
                        // Tambahkan date picker jika diperlukan
                        _selectDate();
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Pilih Jam
                  Expanded(
                    child: CustomForm(
                      controller: _timeController,
                      hintText: 'Pilih Jam',
                      labelText: "",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jam tidak boleh kosong';
                        }
                        return null;
                      },
                      suffixIcon: const Icon(Icons.access_time),
                      readOnly: true,
                      onTap: () {
                        // Tambahkan time picker jika diperlukan
                        _selectTime();
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Durasi
              Row(
                children: [
                  const SizedBox(width: 50, child: Text("Durasi")),

                  // Input angka durasi
                  Expanded(
                    child: CustomForm(
                      controller: _durationController,
                      hintText: 'Durasi',
                      labelText: "",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Durasi tidak boleh kosong';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _duration = int.tryParse(value) ?? 0;
                        _calculateEndDateTime();
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: widget.isOvertime
                        ? CustomForm(
                            hintText: 'Jam',
                            labelText: '',
                            inputType: InputType.dropdown,
                            dropdownItems: overtimeDurationOptions
                                .map((duration) => DropdownMenuItem(
                                    value: duration, child: Text(duration)))
                                .toList(),
                            dropdownValue: _selectedDurationType.isNotEmpty
                                ? _selectedDurationType
                                : null,
                            enabled: false,
                          )
                        : CustomForm(
                            hintText: 'J/H/B',
                            labelText: '',
                            inputType: InputType.dropdown,
                            dropdownItems: normalDurationOptions
                                .map((duration) => DropdownMenuItem(
                                    value: duration, child: Text(duration)))
                                .toList(),
                            dropdownValue: _selectedDurationType.isNotEmpty
                                ? _selectedDurationType
                                : null,
                            onDropdownChanged: (value) {
                              setState(() {
                                _selectedDurationType = value!;
                                _calculateEndDateTime();
                              });
                            },
                          ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Selesai"),
                  Text((endDateTime != null &&
                          _duration != 0 &&
                          _selectedDurationType.isNotEmpty)
                      ? _formatEndDateTime(endDateTime!)
                      : "tanggal selesai"), //dihitung dari tanggal mulai + durasi
                ],
              ),

              const SizedBox(height: 10),

              // EditableChipField(
              //   key: _chipFieldKey,
              //   userList: users,
              // ),

              const SizedBox(height: 20),

              // Tombol Ajukan
              Center(
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  child: const Text("Ajukan"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
        _calculateEndDateTime();
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        _timeController.text = pickedTime.format(context);
        _calculateEndDateTime();
      });
    }
  }
}
