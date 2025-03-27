import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_app/core/widget/app_state_page.dart';
import 'package:work_order_app/feature/work_order/domain/entities/work_order_entity.dart';
import 'package:work_order_app/feature/work_order/presentation/bloc/work_order_bloc.dart';
import 'package:work_order_app/feature/work_order/presentation/bloc/work_order_event.dart';
import 'package:work_order_app/feature/work_order/presentation/bloc/work_order_state.dart';

class ApprovalPage extends StatefulWidget {
  const ApprovalPage({super.key});

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends AppStatePage<ApprovalPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<WorkOrderBloc>()
        .add(GetWorkOrdersEvent()); // ✅ Ambil data WO saat halaman dibuka
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<WorkOrderBloc, WorkOrderState>(
      builder: (context, state) {
        print("📢 State saat ini: $state"); // ✅ Log state untuk debugging
        if (state is WorkOrderLoading) {
          return const Center(
              child: CircularProgressIndicator()); // ✅ Loading Indicator
        } else if (state is WorkOrderLoaded) {
          print("✅ Menampilkan ${state.workOrders.length} Work Orders");
          return _buildWorkOrderList(state.workOrders); // ✅ Tampilkan List Card
        } else if (state is WorkOrderError) {
          print("❌ Error: ${state.message}");
          return Center(child: Text('Error: ${state.message}')); // ✅ Jika Error
        }
        return const Center(child: Text('Belum ada data.'));
      },
    );
  }

  Widget _buildWorkOrderList(List<WorkOrderEntity> workOrders) {
    return ListView.builder(
      shrinkWrap: true, // ✅ Agar mengikuti ukuran kontennya
      physics: const BouncingScrollPhysics(), // ✅ Hindari error overflow
      itemCount: workOrders.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final workOrder = workOrders[index];
        return GestureDetector(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return WorkOrderForm(
              //       isOvertime: false, workOrderId: workOrder.id);
              // }));
            },
            child: _buildWorkOrderCard(workOrder));
      },
    );
  }

  Widget _buildWorkOrderCard(WorkOrderEntity workOrder) {
    print("📝 Work Order Type: ${workOrder.workOrderType}");

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(workOrder.title ?? 'No Title',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(workOrder.workOrderType?.name ?? 'No Type',
                style: const TextStyle(fontSize: 12)),
            Text('Status: ${workOrder.status?.status ?? 'No Status'}',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
            // Text(workOrder.assignees?.userId.toString() ?? 'No Assignee',
            //     style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // ✅ Tambahkan navigasi ke detail Work Order jika diperlukan
        },
      ),
    );
  }
}
