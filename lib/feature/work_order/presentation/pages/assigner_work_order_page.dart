import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:work_order_app/core/widget/app_state_page.dart';
import 'package:work_order_app/core/widget/custom_app_bar.dart';
import 'package:work_order_app/feature/work_order/presentation/pages/assigner_work_order_list_page.dart';
import 'package:work_order_app/feature/work_order/presentation/pages/approval_page.dart';
import 'package:work_order_app/feature/work_order/presentation/widgets/work_order_filter.dart';

class AssignerWorkOrderPage extends StatefulWidget {
  const AssignerWorkOrderPage({super.key});

  @override
  State<AssignerWorkOrderPage> createState() => _AssignerWorkOrderPageState();
}

class _AssignerWorkOrderPageState extends AppStatePage<AssignerWorkOrderPage> {
  int _selectedFilter = 0; // Index filter utama
  // int _subFilter = 0; // Index filter kedua (jika ada)

  final List<String> _filterLabels = [
    'Pembuatan',
    'Persetujuan',
  ];

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Work Order',
          actionIcon: HugeIcons.strokeRoundedNotification02,
          onActionPressed: () {},
        ),
        body: Column(
          children: [
            WorkOrderFilter(
                onFilterSelected: (mainIndex, subIndex) {
                  setState(() {
                    _selectedFilter = mainIndex;
                  });
                },
                filterLabels: _filterLabels),
            Expanded(child: _getPage()),
          ],
        ));
  }

  Widget _getPage() {
    if (_selectedFilter == 0) {
      return const AssignerWorkOrderListPage();
    } else {
      return const ApprovalPage();
    }
  }
}
