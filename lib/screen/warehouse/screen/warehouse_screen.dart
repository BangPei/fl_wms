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
  late final PlutoGridStateManager stateManager;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: PlutoGrid(
        columns: [
          PlutoColumn(
            title: "Expedition",
            field: "expedition_name",
            type: PlutoColumnType.text(),
          ),
          PlutoColumn(
            title: "Date",
            field: "date",
            type: PlutoColumnType.date(format: "dd MMMM yyyy"),
          ),
          PlutoColumn(
            title: "Total Package",
            field: "total_package",
            type: PlutoColumnType.number(),
          ),
          PlutoColumn(
            title: "Picked",
            field: "picked",
            type: PlutoColumnType.number(),
          ),
          PlutoColumn(
            title: "Left",
            field: "left",
            type: PlutoColumnType.number(),
          ),
          PlutoColumn(
            title: "Status",
            field: "status",
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
        onLoaded: (event) {
          stateManager = event.stateManager;
          // stateManager.setPage(5);
          // stateManager.setPageSize(5);
          stateManager.setShowColumnFilter(true);
        },
        onChanged: (event) {
          print(event);
        },
        createFooter: (state) {
          return PlutoLazyPagination(
            initialPage: 1,
            initialFetch: true,
            fetchWithSorting: true,
            fetchWithFiltering: true,
            pageSizeToMove: 1,
            fetch: fetch,
            stateManager: state,
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
      int recordTotal = 0;
      int length = 10;
      int start = (request.page - 1) * length;
      Map<String, dynamic> map = {
        "draw": request.page.toString(),
        "columns[0][data]": "id",
        "columns[0][searchable]": "true",
        "columns[0][orderable]": "true",
        "columns[0][search][regex]": "false",
        "columns[1][data]": "name",
        "columns[1][searchable]": "true",
        "columns[1][orderable]": "true",
        "columns[1][search][regex]": "false",
        "columns[2][data]": "is_active",
        "columns[2][searchable]": "true",
        "columns[2][orderable]": "true",
        "columns[2][search][regex]": "false",
        "columns[3][data]": "id",
        "columns[3][search][regex]": "false",
        "order[0][column]": "0",
        "order[0][dir]": "asc",
        "start": start.toString(),
        "length": length.toString(),
      };
      var url =
          Uri.http("192.168.100.2:8000", "/api/daily-task/dataTable", map);
      var response = await http.get(url, headers: {
        "content-type": "application/json",
        'X-Requested-With': 'XMLHttpRequest',
      });
      if (response.statusCode == 200) {
        final parsedData = jsonDecode(response.body);
        recordTotal = parsedData['recordsTotal'];
        final _data = parsedData["data"];
        print(recordTotal.toString());
        final rows = _data.map<PlutoRow>((rowData) {
          rowData['expedition_name'] = rowData["expedition"]["name"];
          rowData['total_receipt'] = rowData["receipts"].length;
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
