import 'package:fl_wms/screen/brand/data/brand.dart';
import 'package:fl_wms/screen/category/data/category.dart';
import 'package:fl_wms/screen/uom/data/uom.dart';

class Product {
  int? id;
  String? code;
  String? name;
  String? image;
  int? reminderQty;
  Brand? brand;
  Category? category;
  String? moving;
  bool? isActive;
  int? inExpiredDate;
  int? outExpiredDate;
  String? createdAt;
  String? updatedAt;
  List<ItemConvertion>? items;

  Product({
    this.id,
    this.code,
    this.name,
    this.image,
    this.reminderQty,
    this.brand,
    this.category,
    this.moving,
    this.isActive,
    this.inExpiredDate,
    this.outExpiredDate,
    this.createdAt,
    this.updatedAt,
    this.items,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    image = json['image'];
    reminderQty = json['reminder_qty'];
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    moving = json['moving'];
    isActive = json['is_active'];
    inExpiredDate = json['in_expired_date'];
    outExpiredDate = json['out_expired_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['items'] != null) {
      items = <ItemConvertion>[];
      json['items'].forEach((v) {
        items!.add(ItemConvertion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['image'] = image;
    data['reminder_qty'] = reminderQty;
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['moving'] = moving;
    data['is_active'] = isActive;
    data['in_expired_date'] = inExpiredDate;
    data['out_expired_date'] = outExpiredDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemConvertion {
  int? id;
  String? sku;
  String? name;
  int? qty;
  double? salePrice;
  String? createdAt;
  String? updatedAt;
  Uom? uom;

  ItemConvertion({
    this.id,
    this.sku,
    this.name,
    this.qty,
    this.salePrice,
    this.createdAt,
    this.updatedAt,
    this.uom,
  });

  ItemConvertion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sku = json['sku'];
    name = json['name'];
    qty = json['qty'];
    salePrice = json['sale_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    uom = json['uom'] != null ? Uom.fromJson(json['uom']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sku'] = sku;
    data['name'] = name;
    data['qty'] = qty;
    data['sale_price'] = salePrice;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (uom != null) {
      data['uom'] = uom!.toJson();
    }
    return data;
  }
}
