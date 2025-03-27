import 'package:flutter/material.dart';
import 'package:work_order_app/core/widget/app_stateless_widget.dart';

class AddChip extends AppStatelessWidget {
  const AddChip({
    super.key,
    required this.chip,
    required this.onDeleted,
    required this.onSelected,
  });

  final String chip;
  final ValueChanged<String> onDeleted;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7.0),
      child: Container(
        margin: const EdgeInsets.only(right: 3),
        child: InputChip(
          key: ObjectKey(chip),
          label: Text(chip), // ✅ Pastikan label berupa String
          avatar: CircleAvatar(
            child: Text(chip.isNotEmpty
                ? chip[0].toUpperCase()
                : '?'), // ✅ Hindari error jika kosong
          ),
          onDeleted: () => onDeleted(chip),
          onSelected: (bool value) => onSelected(chip),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.all(2),
        ),
      ),
    );
  }
}
