import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:work_order_app/core/widget/app_state_page.dart';
import 'package:work_order_app/core/widget/filter_list/filter_list.dart';
import 'package:work_order_app/feature/work_order/domain/entities/work_order_entity.dart';
import 'package:work_order_app/feature/work_order/presentation/bloc/work_order_bloc.dart';
import 'package:work_order_app/feature/work_order/presentation/bloc/work_order_event.dart';
import 'package:work_order_app/feature/work_order/presentation/bloc/work_order_state.dart';
import 'package:work_order_app/feature/work_order/presentation/pages/create_work_order_page.dart';

class AssignerWorkOrderListPage extends StatefulWidget {
  const AssignerWorkOrderListPage({super.key});

  @override
  State<AssignerWorkOrderListPage> createState() =>
      _AssignerWorkOrderListPageState();
}

class _AssignerWorkOrderListPageState
    extends AppStatePage<AssignerWorkOrderListPage> {
  final ScrollController _scrollController = ScrollController();
  late WorkOrderBloc _workOrderBloc;

  @override
  void initState() {
    super.initState();
    _workOrderBloc = context.read<WorkOrderBloc>();
    _scrollController.addListener(_onScroll);
    _workOrderBloc.add(GetWorkOrdersEvent());
  }

  void _onScroll() {
    if (_workOrderBloc.currentPage >= _workOrderBloc.totalPages) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _workOrderBloc
          .add(LoadMoreWorkOrdersEvent(_workOrderBloc.currentPage + 1, 20));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 8),
          _searchWorkOrder(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Work Order List",
                  style: textTheme.displaySmall,
                ),
                IconButton(
                  icon: const Icon(HugeIcons.strokeRoundedPreferenceHorizontal),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled:
                          true, // Agar bisa full height jika perlu
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (context) => const CustomFilterDialog(),
                    );
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<WorkOrderBloc, WorkOrderState>(
              builder: (context, state) {
                debugPrint("📢 State saat ini: $state");
                if (state is WorkOrderLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WorkOrderLoaded) {
                  debugPrint(
                      "✅ Menampilkan ${state.workOrders.length} Work Orders");
                  if (state.workOrders.isEmpty) {
                    return const Center(child: Text('Belum ada data.'));
                  }
                  return _buildWorkOrderList(state.workOrders);
                } else if (state is WorkOrderError) {
                  return Center(
                      child: Text('Error: ${state.message}')); // ✅ Jika Error
                }
                return const Center(child: Text('Anda offline.'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateWorkOrderPage(),
            ),
          );
          if (mounted) {
            context.read<WorkOrderBloc>().add(GetWorkOrdersEvent());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _searchWorkOrder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari Work Order',
          prefixIcon: const Icon(HugeIcons.strokeRoundedSearch01),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkOrderList(List<WorkOrderEntity> workOrders) {
    return ListView.builder(
      shrinkWrap: true, // ✅ Agar mengikuti ukuran kontennya
      controller: _scrollController,
      itemCount: workOrders.length +
          (_workOrderBloc.currentPage < _workOrderBloc.totalPages ? 1 : 0),
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        if (index >= workOrders.length) {
          return const Center(child: CircularProgressIndicator());
        }
        final workOrder = workOrders[index];
        return _buildWorkOrderCard(workOrder);
      },
    );
  }

  Widget _buildWorkOrderCard(WorkOrderEntity workOrder) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                workOrder.title,
                style: textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildStatusChip(workOrder),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(workOrder.workOrderType?.name ?? 'No Type',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(workOrder.endDateTime.toString(),
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateWorkOrderPage(
                workOrderId: workOrder.id,
              ),
            ),
          );
          if (mounted) {
            context.read<WorkOrderBloc>().add(GetWorkOrdersEvent());
          }
        },
      ),
    );
  }

  Widget _buildStatusChip(WorkOrderEntity workOrder) {
    final type = workOrder.requiresApproval ? "WO Lembur" : "WO Normal";
    final typeColor =
        workOrder.requiresApproval ? color.warning : color.success;

    final status = workOrder.status?.status;
    final statusColor = color.status[workOrder.status?.id];

    return Row(
      spacing: 4,
      children: [
        Container(
          height: 15,
          decoration: BoxDecoration(
            color: typeColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              type,
              style: TextStyle(
                  fontSize: 12,
                  color: workOrder.requiresApproval
                      ? color.primary[500]
                      : color.foreground[100]),
            ),
          ),
        ),
        Container(
          height: 15,
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              status!,
              style: TextStyle(
                  fontSize: 12,
                  color: workOrder.statusId != 2
                      ? color.foreground[100]
                      : color.primary[500]),
            ),
          ),
        ),
      ],
    );
  }
}
