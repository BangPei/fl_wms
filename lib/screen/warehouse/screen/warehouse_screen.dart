import 'package:fl_wms/screen/warehouse/bloc/warehouse_bloc.dart';
import 'package:fl_wms/screen/warehouse/data/warehouse.dart';
import 'package:fl_wms/screen/warehouse/data/warehouse_source.dart';
import 'package:fl_wms/widget/advance_table.dart';
import 'package:fl_wms/widget/card_template.dart';
import 'package:fl_wms/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WarehouseScreen extends StatefulWidget {
  const WarehouseScreen({super.key});

  @override
  State<WarehouseScreen> createState() => _WarehouseScreenState();
}

class _WarehouseScreenState extends State<WarehouseScreen> {
  var warehouseSource = WarehouseSource();
  String title = "Warehouse";
  var sortIndex = 0;
  var sortAsc = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DefaultCardTitle(
                title,
                onPressed: () => context.goNamed("add-warehouse"),
                showAddButton: true,
              ),
            ),
            Card(
              child: BlocBuilder<WarehouseBloc, WarehouseState>(
                builder: (context, state) {
                  if (state is WarehouseLoadingState) {
                    return const LoadingShimmer();
                  } else if (state is WarehouseErrorState) {
                    const Text("Error Page");
                  }
                  return AdvanceTable<Warehouse>(
                    title: title,
                    source: warehouseSource,
                    columns: [
                      DataColumn(label: const Text("Code"), onSort: setSort),
                      DataColumn(label: const Text("Name"), onSort: setSort),
                      DataColumn(
                          label: const Text("PIC Name"), onSort: setSort),
                      DataColumn(
                          label: const Text("PIC Phone"), onSort: setSort),
                      DataColumn(label: const Text("Address"), onSort: setSort),
                      DataColumn(label: const Text("Phone"), onSort: setSort),
                      DataColumn(label: const Text("Status"), onSort: setSort),
                      const DataColumn(label: Text("Action")),
                    ],
                    onSearch: (value) =>
                        warehouseSource.filterServerSide(value),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setSort(int i, bool asc) {
    setState(() {
      sortIndex = i;
      sortAsc = asc;
    });
  }
}
