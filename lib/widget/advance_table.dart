import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:fl_wms/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap_widgets/bootstrap_widgets.dart';

class AdvanceTable<T> extends StatefulWidget {
  final String title;
  final AdvancedDataTableSource<T> source;
  final ValueChanged<String>? onSearch;
  final List<DataColumn>? columns;
  const AdvanceTable(
      {super.key,
      required this.source,
      this.onSearch,
      required this.title,
      this.columns});

  @override
  State<AdvanceTable> createState() => _AdvanceTableState();
}

class _AdvanceTableState extends State<AdvanceTable> {
  var sortIndex = 0;
  var sortAsc = true;
  final _searchController = TextEditingController();
  var rowsPerPage = AdvancedPaginatedDataTable.defaultRowsPerPage;
  @override
  Widget build(BuildContext context) {
    return AdvancedPaginatedDataTable(
      loadingWidget: () => const LoadingShimmer(),
      dataRowHeight: 37,
      sortAscending: sortAsc,
      sortColumnIndex: sortIndex,
      showFirstLastButtons: true,
      addEmptyRows: false,
      showCheckboxColumn: false,
      availableRowsPerPage: const [5, 10, 25, 50, 100],
      rowsPerPage: rowsPerPage,
      header: TextFormField(
        autofocus: true,
        controller: _searchController,
        onFieldSubmitted: widget.onSearch,
        decoration: const BootstrapInputDecoration(
          hintText: "Search...",
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        ),
      ),
      columns: widget.columns ??
          [
            DataColumn(label: Text(widget.title), onSort: setSort),
            const DataColumn(label: Text("Status")),
            const DataColumn(label: Text("Action")),
          ],
      source: widget.source,
      onRowsPerPageChanged: (n) => setState(() => rowsPerPage = n!),
    );
  }

  void setSort(int i, bool asc) {
    setState(() {
      sortIndex = i;
      sortAsc = asc;
    });
  }
}
