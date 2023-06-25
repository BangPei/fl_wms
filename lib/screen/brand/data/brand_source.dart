import 'package:fl_wms/screen/brand/data/brand.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef OnViewRowSelect = void Function(Brand brand);

class BrandSource extends DataTableSource {
  final List<Brand> brands;
  final OnViewRowSelect onViewRowSelect;
  BrandSource(this.brands, {required this.onViewRowSelect});
  @override
  DataRow? getRow(int index) {
    assert(index >= 0);

    if (index >= brands.length) {
      return null;
    }
    Brand e = brands[index];

    return DataRow.byIndex(
      index: index,
      onSelectChanged: (val) => onViewRowSelect(e),
      cells: [
        DataCell(Text("${index + 1}")),
        DataCell(Text(e.name ?? "")),
        DataCell(Text(e.isActive.toString())),
        DataCell(IconButton(
            onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.filePen))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => brands.length;

  @override
  int get selectedRowCount => 0;
}
