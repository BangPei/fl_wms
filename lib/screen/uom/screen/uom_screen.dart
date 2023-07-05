import 'package:fl_wms/screen/uom/bloc/uom_bloc.dart';
import 'package:fl_wms/screen/uom/data/uom.dart';
import 'package:fl_wms/screen/uom/data/uom_source.dart';
import 'package:fl_wms/widget/advance_table.dart';
import 'package:fl_wms/widget/card_template.dart';
import 'package:fl_wms/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UomScreen extends StatefulWidget {
  const UomScreen({super.key});

  @override
  State<UomScreen> createState() => _UomScreenState();
}

class _UomScreenState extends State<UomScreen> {
  var uomSource = UomSource();
  String title = "Uom";
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
                onPressed: uomSource.openModal,
                showAddButton: true,
              ),
            ),
            Card(
              child: BlocBuilder<UomBloc, UomState>(
                builder: (context, state) {
                  if (state is UomLoadingState) {
                    return const LoadingShimmer();
                  } else if (state is UomErrorState) {
                    const Text("Error Page");
                  }
                  return AdvanceTable<Uom>(
                    title: title,
                    source: uomSource,
                    columns: [
                      DataColumn(label: Text(title), onSort: setSort),
                      DataColumn(label: const Text("Alias"), onSort: setSort),
                      const DataColumn(label: Text("Status")),
                      const DataColumn(label: Text("Action")),
                    ],
                    onSearch: (value) => uomSource.filterServerSide(value),
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
