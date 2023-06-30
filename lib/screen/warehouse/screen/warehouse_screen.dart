import 'dart:convert';
import 'package:fl_wms/service/api.dart';
import 'package:flutter_bootstrap_widgets/bootstrap_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class WarehouseScreen extends StatefulWidget {
  const WarehouseScreen({super.key});

  @override
  State<WarehouseScreen> createState() => _WarehouseScreenState();
}

class _WarehouseScreenState extends State<WarehouseScreen> {
  List<PlutoRow> rows = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: PlutoGrid(
        columns: [
          PlutoColumn(
            title: "Code",
            field: "code",
            type: const PlutoColumnTypeText(),
          ),
          PlutoColumn(
            title: "Warehouse",
            field: "name",
            type: const PlutoColumnTypeText(),
          ),
          PlutoColumn(
            title: "Pic",
            field: "pic",
            type: const PlutoColumnTypeText(),
          ),
          PlutoColumn(
            title: "Pic Phone",
            field: "pic_phone",
            type: const PlutoColumnTypeText(),
          ),
          PlutoColumn(
            title: "Address",
            field: "address",
            type: const PlutoColumnTypeText(),
          ),
          PlutoColumn(
            title: "phone",
            field: "phone",
            type: const PlutoColumnTypeText(),
          ),
          PlutoColumn(
            title: "Status",
            field: "is_active",
            readOnly: true,
            type: const PlutoColumnTypeText(),
            renderer: (rendererContext) {
              return SizedBox(
                width: 100,
                child: badges.Badge(
                  badgeContent: Text(
                    rendererContext
                            .row.cells[rendererContext.column.field]!.value
                        ? "Active"
                        : "Inactive",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  badgeAnimation: const badges.BadgeAnimation.rotation(
                    animationDuration: Duration(seconds: 1),
                    colorChangeAnimationDuration: Duration(seconds: 1),
                    loopAnimation: false,
                    // curve: Curves.easeIn,
                    colorChangeAnimationCurve: Curves.easeInCubic,
                  ),
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.square,
                    badgeColor: rendererContext
                            .row.cells[rendererContext.column.field]!.value!
                        ? BootstrapColors.success
                        : BootstrapColors.danger,
                    padding: const EdgeInsets.all(3),
                    borderRadius: BorderRadius.circular(9),
                    elevation: 0,
                  ),
                ),
              );
            },
          ),
        ],
        rows: rows,
        createFooter: (stateManager) {
          return PlutoLazyPagination(
            initialPage: 1,
            initialFetch: true,
            fetchWithSorting: true,
            fetchWithFiltering: true,
            pageSizeToMove: null,
            fetch: fetch,
            stateManager: stateManager,
          );
        },
      ),
    );
  }

  Future<PlutoLazyPaginationResponse> fetch(
    PlutoLazyPaginationRequest request,
  ) async {
    try {
      String queryString = '?page=${request.page}';
      if (request.filterRows.isNotEmpty) {
        final filterMap = FilterHelper.convertRowsToMap(request.filterRows);
        for (final filter in filterMap.entries) {
          for (final type in filter.value) {
            queryString += '&filter[${filter.key}]';
            final filterType = type.entries.first;
            queryString += '[${filterType.key}][]=${filterType.value}';
          }
        }
      }
      if (request.sortColumn != null && !request.sortColumn!.sort.isNone) {
        queryString +=
            '&sort=${request.sortColumn!.field},${request.sortColumn!.sort.name}';
      }
      var response = await http.get(
          Uri.parse("${Api.baseUrl}warehouse/dataTable$queryString"),
          headers: {
            "content-type": "application/json",
            'X-Requested-With': 'XMLHttpRequest',
          });
      if (response.statusCode == 200) {
        final parsedData = jsonDecode(response.body);
        final _data = parsedData["data"];
        final rows = _data.map<PlutoRow>((rowData) {
          print(rowData);
          return PlutoRow.fromJson(rowData);
        });

        return PlutoLazyPaginationResponse(
          totalPage: parsedData['recordsTotal'],
          rows: rows.toList(),
        );
      } else {
        return PlutoLazyPaginationResponse(
          totalPage: 0,
          rows: [],
        );
      }
    } catch (e) {
      print(e);
      return PlutoLazyPaginationResponse(
        totalPage: 0,
        rows: [],
      );
    }
  }
}
