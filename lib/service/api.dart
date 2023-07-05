import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fl_wms/models/datatable_model.dart';
import 'package:http/http.dart' as http;
import 'package:fl_wms/service/restclient.dart';

class Api {
  // static const String url = "192.168.0.163:8000";
  static const String url = "192.168.100.11:8000";

  static String baseUrl() => "http://$url/api/";

  static restClient() async {
    final dio = Dio();
    // dio.options.headers["Authorization"] = await Session.get("authorization");
    return RestClient(dio, baseUrl: baseUrl());
  }

  static Future<DataTableModel> getDataTable(
    String path, {
    int? draw = 1,
    int? start = 0,
    String? searchText = "",
    int? length = 10,
    int? orderColumn = 0,
    String? orderdir,
    Map<String, dynamic>? query,
  }) async {
    Map<String, dynamic> map = {
      "draw": draw.toString(),
      "columns[0][data]": "name",
      "columns[0][searchable]": "true",
      "columns[0][orderable]": "true",
      "columns[0][search][regex]": "false",
      "columns[1][data]": "is_active",
      "columns[1][searchable]": "true",
      "columns[1][orderable]": "true",
      "columns[1][search][regex]": "false",
      "columns[2][data]": "id",
      "columns[2][search][regex]": "false",
      "order[0][column]": orderColumn.toString(),
      "order[0][dir]": orderdir,
      "start": start.toString(),
      "length": length.toString(),
      "search[value]": searchText
    };
    var url = Uri.http(Api.url, path, query ?? map);
    var response = await http.get(url, headers: {
      "content-type": "application/json",
      'X-Requested-With': 'XMLHttpRequest',
    });
    final parsedData = jsonDecode(response.body);
    var dataTable = DataTableModel.fromJson(parsedData);
    return dataTable;
  }
}
