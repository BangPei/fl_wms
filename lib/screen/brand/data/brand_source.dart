import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:fl_wms/screen/brand/data/brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap_widgets/bootstrap_widgets.dart';
import 'package:badges/badges.dart' as badges;

// typedef OnViewRowSelect = void Function(Brand brand);

class BrandSource extends AdvancedDataTableSource<Brand> {
  final List<Brand> brands;
  final int recordsTotal;
  final int recordsFiltered;
  final Function(Brand) onTap;
  // final OnViewRowSelect onViewRowSelect;
  BrandSource(this.brands, {required this.recordsTotal,required this.recordsFiltered, required this.onTap});
  String searchText = "";

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
        // onSelectChanged: null,
        cells: const [
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
        ],
      );
    }
    return DataRow.byIndex(
      index: index,
      color: MaterialStateProperty.resolveWith((states) {
        if (index % 2 != 0) {
          return Colors.grey.withOpacity(0.1);
        }
        return Colors.white;
      }),
      // onSelectChanged: (val) => onViewRowSelect(e),
      cells: [
        DataCell(SelectableText(e.name ?? "")),
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
  int get selectedRowCount => 0;

  void filterServerSide(String filterQuery) {
    searchText = filterQuery.toLowerCase().trim();
    setNextView();
  }

  @override
  Future<RemoteDataSourceDetails<Brand>> getNextPage(
      NextPageRequest pageRequest) async {
    return RemoteDataSourceDetails(recordsTotal, brands, filteredRows: recordsFiltered);
  }
}
