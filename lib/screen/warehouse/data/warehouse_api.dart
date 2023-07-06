import 'package:fl_wms/screen/warehouse/data/warehouse.dart';
import 'package:fl_wms/service/api.dart';

class WarehouseApi {
  static Future<List<Warehouse>> getWarehouses() async {
    final client = await Api.restClient();
    var data = client.getWarehouses();
    return data;
  }

  static Future<Warehouse> getWarehouse(int id) async {
    final client = await Api.restClient();
    var data = client.getWarehouse(id);
    return data;
  }

  static Future<Warehouse> getWarehouseByCode(String code) async {
    final client = await Api.restClient();
    var data = client.getWarehouseByCode(code);
    return data;
  }

  static Future postWarehouse(Warehouse wa) async {
    final client = await Api.restClient();
    var data = client.postWarehouse(wa);
    return data;
  }

  static Future putWarehouse(int id, Warehouse wa) async {
    final client = await Api.restClient();
    var data = client.putWarehouse(id, wa);
    return data;
  }

  static Future deleteWarehouse(int id) async {
    final client = await Api.restClient();
    var data = client.deleteWarehouse(id);
    return data;
  }
}
