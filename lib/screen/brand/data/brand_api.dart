import 'package:fl_wms/screen/brand/data/brand.dart';
import 'package:fl_wms/service/api.dart';

class BrandApi {
  static Future<List<Brand>> getBrands() async {
    final client = await Api.restClient();
    var data = client.getBrands();
    return data;
  }

  static Future<Brand> getBrand(int id) async {
    final client = await Api.restClient();
    var data = client.getBrand(id);
    return data;
  }

  static Future postBrand(Brand brand) async {
    final client = await Api.restClient();
    var data = client.postBrand(brand);
    return data;
  }

  static Future putBrand(int id, Brand brand) async {
    final client = await Api.restClient();
    var data = client.putBrand(id, brand);
    return data;
  }

  static Future deleteBrand(int id) async {
    final client = await Api.restClient();
    var data = client.deleteBrand(id);
    return data;
  }
}
