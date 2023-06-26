import 'package:fl_wms/screen/category/data/category.dart';
import 'package:fl_wms/service/api.dart';

class CategoryApi {
  static Future<List<Category>> getCategories() async {
    final client = await Api.restClient();
    var data = client.getCategories();
    return data;
  }

  static Future<Category> getCategory(int id) async {
    final client = await Api.restClient();
    var data = client.getCategory(id);
    return data;
  }

  static Future postCategory(Category category) async {
    final client = await Api.restClient();
    var data = client.postCategory(Category);
    return data;
  }

  static Future putCategory(int id, Category category) async {
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
