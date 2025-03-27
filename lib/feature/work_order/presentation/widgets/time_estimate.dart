import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:work_order_app/core/widget/app_state_page.dart';
import 'package:work_order_app/core/widget/custom_form.dart';

class TimeEstimate extends StatefulWidget {
  final bool isOvertime;
  final bool isReadOnly;
  final Function(DateTime?, int?, String?, DateTime?) onChanged;
  final DateTime? startDateTime;
  final int? duration;
  final String? durationUnit;
  final DateTime? endDateTime;

  const TimeEstimate(
      {super.key,
      required this.isOvertime,
      this.isReadOnly = false,
      required this.onChanged,
      this.startDateTime,
      this.duration,
      this.durationUnit,
      this.endDateTime});

  @override
  State<TimeEstimate> createState() => _TimeEstimateState();
}

class _TimeEstimateState extends AppStatePage<TimeEstimate> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _durationTypeController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  DateTime? endDateTime;
  int _duration = 0;
  String _selectedDurationType = '';
  final List<String> normalDurationOptions = ['Jam', 'Hari', 'Bulan'];

  @override
  void initState() {
    super.initState();
    _updateDurationType();
    _initialValue();
  }

  @override
  void didUpdateWidget(TimeEstimate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOvertime != oldWidget.isOvertime) {
      _updateDurationType();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (selectedTime != null) {
      _timeController.text =
          selectedTime!.format(context); // ✅ Pindahkan ke sini
    }
  }

  void _initialValue() {
    selectedDate = widget.startDateTime;
    selectedTime = widget.startDateTime != null
        ? TimeOfDay.fromDateTime(widget.startDateTime!)
        : null;

    _duration = widget.duration ?? 0;
    _selectedDurationType =
        widget.durationUnit ?? (widget.isOvertime ? "Jam" : "");
    endDateTime = widget.endDateTime;

    _dateController.text = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : '';
    _durationController.text = _duration > 0 ? _duration.toString() : '';
    _durationTypeController.text = _selectedDurationType;
  }

  void _updateDurationType() {
    setState(() {
      _selectedDurationType = widget.isOvertime ? 'Jam' : '';
      _durationTypeController.text = _selectedDurationType; // Update text field
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    return Column(
      children: [
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
                onTap: (widget.isReadOnly)
                    ? null
                    : () {
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
                onTap: (widget.isReadOnly)
                    ? null
                    : () {
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
                readOnly: widget.isReadOnly,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: widget.isOvertime
                  ? CustomForm(
                      controller: _durationTypeController,
                      hintText: 'Jam',
                      labelText: '',
                      enabled: false,
                    )
                  : CustomForm(
                      controller: _durationTypeController,
                      hintText: 'J/H/B',
                      labelText: '',
                      inputType: (widget.isReadOnly)
                          ? InputType.text
                          : InputType.dropdown,
                      readOnly: widget.isReadOnly,
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
      ],
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

      widget.onChanged(
          startDateTime, durationValue, _selectedDurationType, endDateTime);
    }
  }

  String _formatEndDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('EEEE, dd MMMM yyyy HH:mm \'WIB\'');
    return formatter.format(dateTime);
  }
}
