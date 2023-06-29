import 'package:fl_wms/screen/category/data/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap_widgets/bootstrap_widgets.dart';
import 'package:badges/badges.dart' as badges;

// typedef OnViewRowSelect = void Function(Brand brand);

class CategorySource extends DataTableSource {
  final List<Category> categories;
  final Function(Category) onTap;
  // final OnViewRowSelect onViewRowSelect;
  CategorySource(this.categories, {required this.onTap});

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= categories.length) {
      return null;
    }
    Category e = categories[index];
    if (categories.isEmpty) {
      return DataRow.byIndex(
        index: index,
        // onSelectChanged: null,
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
      color: MaterialStateProperty.resolveWith((states) {
        // If the button is pressed, return green, otherwise blue
        if (index % 2 != 0) {
          return Colors.grey.withOpacity(0.1);
        }
        return Colors.white;
      }),
      // onSelectChanged: (val) => onViewRowSelect(e),
      cells: [
        DataCell(Text("${index + 1}")),
        DataCell(Text(e.name ?? "")),
        DataCell(badges.Badge(
          badgeContent: Text(
            e.isActive! ? "Active" : "Inactive",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          badgeAnimation: const badges.BadgeAnimation.rotation(
            animationDuration: Duration(seconds: 1),
            colorChangeAnimationDuration: Duration(seconds: 1),
            loopAnimation: false,
            curve: Curves.fastOutSlowIn,
            colorChangeAnimationCurve: Curves.easeInCubic,
          ),
          badgeStyle: badges.BadgeStyle(
            shape: badges.BadgeShape.square,
            badgeColor:
                e.isActive! ? BootstrapColors.success : BootstrapColors.danger,
            padding: const EdgeInsets.all(3),
            borderRadius: BorderRadius.circular(9),
            elevation: 0,
          ),
        )),
        DataCell(Row(
          children: [
            GestureDetector(
              onTap: () {
                onTap(e);
              },
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
            // const SizedBox(width: 3),
            // GestureDetector(
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 7),
            //     decoration: BoxDecoration(
            //       color: BootstrapColors.danger.withOpacity(0.9),
            //       borderRadius: const BorderRadius.all(
            //         Radius.circular(5),
            //       ),
            //     ),
            //     child: const Row(
            //       children: [
            //         Icon(
            //           Icons.delete,
            //           color: Colors.white,
            //           size: 18,
            //         ),
            //         Text(
            //           "Hapus",
            //           style: TextStyle(color: Colors.white, fontSize: 11),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => categories.length;

  @override
  int get selectedRowCount => 0;
}
