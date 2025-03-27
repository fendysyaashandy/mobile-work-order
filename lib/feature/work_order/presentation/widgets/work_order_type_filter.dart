import 'package:flutter/material.dart';
import 'package:work_order_app/core/widget/app_state_page.dart';

class WorkOrderTypeFilter extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onFilterSelected;
  final List<String> filterLabels;
  const WorkOrderTypeFilter(
      {super.key,
      required this.selectedIndex,
      required this.onFilterSelected,
      required this.filterLabels});

  @override
  State<WorkOrderTypeFilter> createState() => _WorkOrderTypeFilterState();
}

class _WorkOrderTypeFilterState extends AppStatePage<WorkOrderTypeFilter> {
  @override
  Widget buildPage(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: List.generate(widget.filterLabels.length, (index) {
          bool isActive = widget.selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onFilterSelected(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isActive ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  widget.filterLabels[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isActive ? Colors.blue : Colors.black,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
