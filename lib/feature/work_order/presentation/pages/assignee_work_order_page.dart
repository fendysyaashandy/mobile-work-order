import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:work_order_app/core/widget/app_state_page.dart';
import 'package:work_order_app/core/widget/custom_app_bar.dart';
import 'package:work_order_app/feature/work_order/presentation/pages/history_work_order_page.dart';
import 'package:work_order_app/feature/work_order/presentation/pages/assignee_work_order_list_page.dart';
import 'package:work_order_app/feature/work_order/presentation/widgets/work_order_filter.dart';

class AssigneeWorkOrderPage extends StatefulWidget {
  const AssigneeWorkOrderPage({super.key});

  @override
  State<AssigneeWorkOrderPage> createState() => _AssigneeWorkOrderPageState();
}

class _AssigneeWorkOrderPageState extends AppStatePage<AssigneeWorkOrderPage> {
  int _selectedFilter = 0;

  final List<String> _filterLabels = [
    'Pengerjaan',
    'Riwayat',
  ];

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Work Order',
          actionIcon: Iconsax.notification_copy,
          onActionPressed: () {},
        ),
        body: Column(
          children: [
            WorkOrderFilter(
                onFilterSelected: (mainIndex, subIndex) {
                  setState(() {
                    _selectedFilter = mainIndex;
                    // _subFilter = subIndex;
                  });
                },
                filterLabels: _filterLabels),
            Expanded(child: _getPage()),
          ],
        ));
  }

  Widget _getPage() {
    if (_selectedFilter == 0) {
      return const AssigneeWorkOrderListPage();
    } else {
      return const HistoryWorkOrderPage();
    }
  }
}
