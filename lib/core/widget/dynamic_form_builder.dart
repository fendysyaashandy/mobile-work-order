import 'package:flutter/material.dart';
import 'package:work_order_app/core/widget/app_state_page.dart';
import 'package:work_order_app/core/widget/custom_form.dart';

class DynamicFormBuilder extends StatefulWidget {
  final List<Map<String, dynamic>> fields;
  final Map<String, dynamic> formData;
  final Function(String, dynamic) onFieldChanged;
  final Map<
      String,
      Widget Function(Map<String, dynamic>, Map<String, dynamic>,
          Function(String, dynamic))> customWidgets;

  const DynamicFormBuilder({
    super.key,
    required this.fields,
    required this.formData,
    required this.onFieldChanged,
    required this.customWidgets,
  });

  @override
  State<DynamicFormBuilder> createState() => _DynamicFormBuilderState();
}

class _DynamicFormBuilderState extends AppStatePage<DynamicFormBuilder> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller hanya untuk field teks
    for (var field in widget.fields) {
      if (field["type"] == "text") {
        _controllers[field["key"]] = TextEditingController(
          text: widget.formData[field["key"]] ?? "",
        );
      }
    }
  }

  @override
  void dispose() {
    // Bersihkan semua controller saat widget dihapus
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return Column(
      children: widget.fields
          .where((field) =>
              field["showIf"] == null || field["showIf"](widget.formData))
          .map((field) {
        bool isReadOnly = field["isReadOnly"] ?? false;
        bool isDisabled = field["isDisabled"] ?? false;

        switch (field["type"]) {
          case "text":
            return Column(
              children: [
                CustomForm(
                  hintText: field["hint"],
                  labelText: field["label"],
                  keyboardType: TextInputType.text,
                  controller: _controllers[field["key"]],
                  readOnly: isReadOnly,
                  onChanged: (value) {
                    if (!isReadOnly) {
                      widget.onFieldChanged(field["key"], value);
                    }
                  },
                ),
                const SizedBox(height: 10),
              ],
            );

          case "dropdown":
            debugPrint("Dropdown ${field["key"]} - isDisabled: $isDisabled");
            return Column(
              children: [
                CustomForm(
                  hintText: 'Pilih Jenis Pekerjaan',
                  labelText: field["label"],
                  inputType: InputType.dropdown,
                  dropdownItems:
                      (field["options"] as List<Map<String, dynamic>>)
                          .map((option) {
                    return DropdownMenuItem<int>(
                      value: option["value"],
                      child: Text(option["label"]),
                    );
                  }).toList(),
                  dropdownValue: widget.formData[field["key"]],
                  enabled: !isDisabled, // ✅ Buat disabled jika perlu
                  onDropdownChanged: (value) {
                    if (!isDisabled) {
                      widget.onFieldChanged(field["key"], value);
                    }
                  },
                ),
                const SizedBox(height: 10),
              ],
            );

          case "chip":
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(field["label"], style: const TextStyle(fontSize: 16)),
                Wrap(
                  children: (field["options"] as List<Map<String, dynamic>>)
                      .map((option) {
                    bool isSelected = (widget.formData[field["key"]] ?? [])
                        .contains(option["id"]);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(option["name"]),
                        selected: isSelected,
                        onSelected: (selected) {
                          final selectedList = List<int>.from(
                              widget.formData[field["key"]] ?? []);
                          if (selected) {
                            selectedList.add(option["id"]);
                          } else {
                            selectedList.remove(option["id"]);
                          }
                          widget.onFieldChanged(field["key"], selectedList);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            );

          case "custom":
            if (widget.customWidgets.containsKey(field["key"])) {
              return Column(
                children: [
                  widget.customWidgets[field["key"]]!(
                      field, widget.formData, widget.onFieldChanged),
                  const SizedBox(height: 10),
                ],
              );
            }
            return const SizedBox();

          default:
            return const SizedBox();
        }
      }).toList(),
    );
  }
}
