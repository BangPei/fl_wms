import 'package:fl_wms/screen/uom/data/uom.dart';
import 'package:fl_wms/service/api.dart';

class UomApi {
  static Future<List<Uom>> getUoms() async {
    final client = await Api.restClient();
    var data = client.getUoms();
    return data;
  }

  static Future<Uom> getUom(int id) async {
    final client = await Api.restClient();
    var data = client.getUom(id);
    return data;
  }

  static Future postUom(Uom uom) async {
    final client = await Api.restClient();
    var data = client.postUom(uom);
    return data;
  }

  static Future putUom(int id, Uom uom) async {
    final client = await Api.restClient();
    var data = client.putUom(id, uom);
    return data;
  }

  static Future deleteUom(int id) async {
    final client = await Api.restClient();
    var data = client.deleteUom(id);
    return data;
  }
}
