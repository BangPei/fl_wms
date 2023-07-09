import 'package:fl_wms/screen/brand/data/brand.dart';
import 'package:fl_wms/screen/category/data/category.dart';
import 'package:fl_wms/screen/uom/data/uom.dart';

class Product {
  int? id;
  String? sku;
  String? name;
  String? image;
  int? qty;
  int? reminderQty;
  double? salePrice;
  Brand? brand;
  Category? category;
  Uom? uom;
  String? moving;
  bool? isActive;
  int? inExpiredDate;
  int? outExpiredDate;
  String? createdAt;
  String? updatedAt;

  Product(
      {this.id,
      this.sku,
      this.name,
      this.image,
      this.qty,
      this.reminderQty,
      this.salePrice,
      this.brand,
      this.category,
      this.uom,
      this.moving,
      this.isActive,
      this.inExpiredDate,
      this.outExpiredDate,
      this.createdAt,
      this.updatedAt});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sku = json['sku'];
    name = json['name'];
    image = json['image'];
    qty = json['qty'];
    reminderQty = json['reminder_qty'];
    salePrice = json['sale_price'];
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    uom = json['uom'] != null ? Uom.fromJson(json['uom']) : null;
    moving = json['moving'];
    isActive = json['is_active'];
    inExpiredDate = json['in_expired_date'];
    outExpiredDate = json['out_expired_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sku'] = sku;
    data['name'] = name;
    data['image'] = image;
    data['qty'] = qty;
    data['reminder_qty'] = reminderQty;
    data['sale_price'] = salePrice;
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (uom != null) {
      data['uom'] = uom!.toJson();
    }
    data['moving'] = moving;
    data['is_active'] = isActive;
    data['in_expired_date'] = inExpiredDate;
    data['out_expired_date'] = outExpiredDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
