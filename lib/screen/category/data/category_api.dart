import 'package:fl_wms/screen/category/data/item_category.dart';
import 'package:fl_wms/service/api.dart';

class CategoryApi {
  static Future<List<ItemCategory>> getCategories() async {
    final client = await Api.restClient();
    var data = client.getCategories();
    return data;
  }

  static Future<ItemCategory> getCategory(int id) async {
    final client = await Api.restClient();
    var data = client.getCategory(id);
    return data;
  }

  static Future postCategory(ItemCategory category) async {
    final client = await Api.restClient();
    var data = client.postCategory(category);
    return data;
  }

  static Future putCategory(int id, ItemCategory category) async {
    final client = await Api.restClient();
    var data = client.putCategory(id, category);
    return data;
  }

  static Future deleteCategory(int id) async {
    final client = await Api.restClient();
    var data = client.deleteCategory(id);
    return data;
  }
}
