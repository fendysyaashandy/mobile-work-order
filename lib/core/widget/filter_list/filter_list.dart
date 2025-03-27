import 'package:flutter/material.dart';
import 'package:work_order_app/core/widget/app_state_page.dart';

class CustomFilterDialog extends StatefulWidget {
  const CustomFilterDialog({super.key});

  @override
  State<CustomFilterDialog> createState() => _CustomFilterDialogState();
}

class _CustomFilterDialogState extends AppStatePage<CustomFilterDialog> {
  String? selectedWorkOrderType;
  String? selectedStatus;
  String? selectedAssignee;
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget buildPage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.85, // Sesuaikan tinggi
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter by:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildWorkOrderTypeFilter(),
          _buildAssigneeFilter(),
          _buildStatusFilter(),
          _buildDateFilter(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildWorkOrderTypeFilter() {
    return _buildSection(
      title: 'Pilih Work Order',
      child: Row(
        children: [
          _filterButton('Normal', selectedWorkOrderType == 'Normal', () {
            setState(() => selectedWorkOrderType = 'Normal');
          }),
          const SizedBox(width: 8),
          _filterButton('Lembur', selectedWorkOrderType == 'Lembur', () {
            setState(() => selectedWorkOrderType = 'Lembur');
          }),
        ],
      ),
    );
  }

  Widget _buildAssigneeFilter() {
    return _buildSection(
      title: 'Nama Petugas',
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari nama petugas...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: (value) => setState(() => selectedAssignee = value),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return _buildSection(
      title: 'Status',
      child: Wrap(
        spacing: 8,
        children: [
          'Belum disetujui',
          'Disetujui',
          'Revisi',
          'Ditolak',
          'Selesai'
        ]
            .map(
                (status) => _filterButton(status, selectedStatus == status, () {
                      setState(() => selectedStatus = status);
                    }))
            .toList(),
      ),
    );
  }

  Widget _buildDateFilter() {
    return _buildSection(
      title: 'Tanggal',
      child: Row(
        children: [
          _datePickerButton(
              'Dari', startDate, (date) => setState(() => startDate = date)),
          const SizedBox(width: 8),
          _datePickerButton(
              'Sampai', endDate, (date) => setState(() => endDate = date)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () => setState(() {
            selectedWorkOrderType = null;
            selectedAssignee = null;
            selectedStatus = null;
            startDate = null;
            endDate = null;
          }),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
          child:
              const Text('Atur Ulang', style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, {
            'workOrderType': selectedWorkOrderType,
            'assignee': selectedAssignee,
            'status': selectedStatus,
            'startDate': startDate,
            'endDate': endDate,
          }),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Terapkan', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _filterButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _datePickerButton(
      String label, DateTime? date, Function(DateTime) onDateSelected) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            onDateSelected(pickedDate);
          }
        },
        child: Text(
            date == null ? label : '${date.day}-${date.month}-${date.year}'),
      ),
    );
  }
}
