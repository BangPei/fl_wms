import 'package:fl_wms/screen/brand/data/brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap_widgets/bootstrap_widgets.dart';

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
    if (brands.isEmpty) {
      return DataRow.byIndex(
        index: index,
        onSelectChanged: null,
        cells: const [
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
        ],
      );
    }
    return DataRow.byIndex(
      index: index,
      onSelectChanged: (val) => onViewRowSelect(e),
      cells: [
        DataCell(Text("${index + 1}")),
        DataCell(Text(e.name ?? "")),
        DataCell(Align(
          alignment: Alignment.centerLeft,
          child: BootstrapLabel(
            text: e.isActive! ? "Active" : "Inactive",
            fontSize: 13,
            type: e.isActive!
                ? BootstrapLabelType.success
                : BootstrapLabelType.danger,
          ),
        )),
        DataCell(
            // Align(alignment: Alignment.centerRight, child: Text("Edit ")),
            // showEditIcon: true,
            Row(
          children: [
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 7),
                decoration: BoxDecoration(
                  color: BootstrapColors.primary.withOpacity(0.9),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                    Text(
                      "Edit",
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(width: 3),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 7),
                decoration: BoxDecoration(
                  color: BootstrapColors.danger.withOpacity(0.9),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 18,
                    ),
                    Text(
                      "Hapus",
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    )
                  ],
                ),
              ),
            ),
          ],
        )),
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
