import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:fl_wms/library/interceptor/injector.dart';
import 'package:fl_wms/library/interceptor/navigation_service.dart';
import 'package:fl_wms/models/datatable_model.dart';
import 'package:fl_wms/screen/warehouse/data/warehouse.dart';
import 'package:fl_wms/service/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap_widgets/bootstrap_widgets.dart';
import 'package:badges/badges.dart' as badges;
import 'package:go_router/go_router.dart';

// typedef OnViewRowSelect = void Function(Warehouse uom);

class WarehouseSource extends AdvancedDataTableSource<Warehouse> {
  final NavigationService _nav = locator<NavigationService>();
  String searchText = "";
  int _draw = 0;
  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= lastDetails!.rows.length) {
      return null;
    }
    Warehouse e = lastDetails!.rows[index];
    if (lastDetails!.rows.isEmpty) {
      return DataRow.byIndex(
        index: index,
        // onSelectChanged: null,
        cells: const [
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
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
        if (index % 2 != 0) {
          return Colors.grey.withOpacity(0.1);
        }
        return Colors.white;
      }),
      // onSelectChanged: (val) => onViewRowSelect(e),
      cells: [
        DataCell(SelectableText(e.code ?? "")),
        DataCell(SelectableText(e.name ?? "")),
        DataCell(SelectableText(e.pic ?? "")),
        DataCell(SelectableText(e.picPhone ?? "")),
        DataCell(SelectableText(e.address ?? "")),
        DataCell(SelectableText(e.phone ?? "")),
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
              onTap: () => _nav.navKey.currentContext!.goNamed(
                "edit-warehouse",
                pathParameters: {"id": e.id.toString()},
              ),
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

  @override
  Future<RemoteDataSourceDetails<Warehouse>> getNextPage(
      NextPageRequest pageRequest) async {
    try {
      _draw = _draw + 1;
      Map<String, dynamic> map = {
        "draw": _draw.toString(),
        "columns[0][data]": "code",
        "columns[0][searchable]": "true",
        "columns[0][orderable]": "true",
        "columns[0][search][regex]": "false",
        "columns[1][data]": "name",
        "columns[1][searchable]": "true",
        "columns[1][orderable]": "true",
        "columns[1][search][regex]": "false",
        "columns[2][data]": "pic",
        "columns[2][searchable]": "true",
        "columns[2][orderable]": "true",
        "columns[2][search][regex]": "false",
        "columns[3][data]": "pic_phone",
        "columns[3][searchable]": "true",
        "columns[3][orderable]": "true",
        "columns[3][search][regex]": "false",
        "columns[4][data]": "address",
        "columns[4][search][regex]": "false",
        "columns[5][data]": "phone",
        "columns[5][searchable]": "true",
        "columns[5][orderable]": "true",
        "columns[5][search][regex]": "false",
        "columns[6][data]": "is_active",
        "columns[6][searchable]": "true",
        "columns[6][orderable]": "true",
        "columns[6][search][regex]": "false",
        "order[0][column]": pageRequest.columnSortIndex.toString(),
        "order[0][dir]": (pageRequest.sortAscending ?? false) ? "asc" : "desc",
        "start": pageRequest.offset.toString(),
        "length": pageRequest.pageSize.toString(),
        "search[value]": searchText
      };
      DataTableModel dataTable =
          await Api.getDataTable("/api/warehouse/dataTable", query: map);
      List<Warehouse> warehouses =
          (dataTable.data ?? []).map((e) => Warehouse.fromJson(e)).toList();
      return RemoteDataSourceDetails(
        dataTable.recordsTotal ?? 0,
        warehouses,
        filteredRows: dataTable.recordsFiltered,
      );
    } catch (e) {
      return RemoteDataSourceDetails(0, [], filteredRows: 0);
    }
  }

  void filterServerSide(String value) {
    searchText = value.toLowerCase().trim();
    setNextView();
  }
}
