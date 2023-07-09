import 'package:fl_wms/screen/product/data/product.dart';
import 'package:fl_wms/service/api.dart';

class ProductApi {
  static Future<List<Product>> getProducts() async {
    final client = await Api.restClient();
    var data = client.getProducts();
    return data;
  }

  static Future<Product> getProduct(int id) async {
    final client = await Api.restClient();
    var data = client.getProduct(id);
    return data;
  }

  static Future<Product> getProductBySku(String sku) async {
    final client = await Api.restClient();
    var data = client.getProductByCode(sku);
    return data;
  }

  static Future postProduct(Product product) async {
    final client = await Api.restClient();
    var data = client.postProduct(product);
    return data;
  }

  static Future putProduct(int id, Product product) async {
    final client = await Api.restClient();
    var data = client.putProduct(id, product);
    return data;
  }

  static Future deleteProduct(int id) async {
    final client = await Api.restClient();
    var data = client.deleteProduct(id);
    return data;
  }
}
