import 'package:flutter/material.dart';
import 'package:work_order_app/core/widget/app_state_page.dart';
import 'package:work_order_app/core/widget/custom_app_bar.dart';
import 'package:work_order_app/feature/work_order/presentation/pages/detail_work_order_page.dart';
import 'package:work_order_app/feature/work_order/presentation/widgets/work_order_type_filter.dart';

class CreateWorkOrderPage extends StatefulWidget {
  final int? workOrderId;
  const CreateWorkOrderPage({super.key, this.workOrderId});

  @override
  State<CreateWorkOrderPage> createState() => _CreateWorkOrderPageState();
}

class _CreateWorkOrderPageState extends AppStatePage<CreateWorkOrderPage> {
  int _subFilterIndex = 0;
  final List<String> _filterLabels = ['WO Normal', 'WO Lembur'];

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
        appBar: (widget.workOrderId == null)
            ? const CustomAppBar(
                title: 'Buat Work Order',
              )
            : null,
        body: Column(
          children: [
            (widget.workOrderId == null)
                ? WorkOrderTypeFilter(
                    selectedIndex: _subFilterIndex,
                    onFilterSelected: (index) {
                      setState(() {
                        _subFilterIndex = index;
                      });
                    },
                    filterLabels: _filterLabels)
                : const SizedBox(),
            Expanded(
                child: DetailWorkOrderPage(
              key: ValueKey(_subFilterIndex),
              workOrderId: widget.workOrderId,
              isOvertime: _subFilterIndex == 1 ? true : false,
            )),
          ],
        ));
  }
}
