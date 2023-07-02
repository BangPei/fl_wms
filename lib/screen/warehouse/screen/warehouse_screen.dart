import 'dart:convert';
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
            title: "Code",
            field: "code",
            type: const PlutoColumnTypeText(),
            readOnly: true,
          ),
          PlutoColumn(
            title: "Warehouse",
            field: "name",
            type: const PlutoColumnTypeText(),
          ),
          PlutoColumn(
            title: "Pic",
            field: "pic",
            readOnly: true,
            type: const PlutoColumnTypeText(),
          ),
          PlutoColumn(
            title: "Pic Phone",
            field: "pic_phone",
            readOnly: true,
            type: const PlutoColumnTypeText(),
          ),
          PlutoColumn(
            title: "phone",
            field: "phone",
            readOnly: true,
            type: const PlutoColumnTypeText(),
          ),
          PlutoColumn(
            title: "Address",
            field: "address",
            readOnly: true,
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
                        ? "Selesai"
                        : "Berjalan",
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
      // print((request.filterRows).first.cells.values);
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
      var url = Uri.http("192.168.0.163:8000", "/api/warehouse/dataTable", map);
      var response = await http.get(url, headers: {
        "content-type": "application/json",
        'X-Requested-With': 'XMLHttpRequest',
      });
      if (response.statusCode == 200) {
        final parsedData = jsonDecode(response.body);
        recordTotal = parsedData['recordsTotal'];
        final data = parsedData["data"];
        final rows = data.map<PlutoRow>((rowData) {
          return PlutoRow.fromJson(rowData);
        });
        int totalPage = (recordTotal / length).ceil();
        return PlutoLazyPaginationResponse(
          totalPage: totalPage,
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
