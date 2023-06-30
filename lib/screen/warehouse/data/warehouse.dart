class Warehouse {
  int? id;
  String? name;
  String? code;
  String? address;
  String? pic;
  String? picPhone;
  String? phone;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Warehouse({
    this.id,
    this.name,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.address,
    this.code,
    this.phone,
    this.pic,
    this.picPhone,
  });

  Warehouse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    pic = json['pic'];
    phone = json['phone'];
    picPhone = json['pic_phone'];
    address = json['address'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['address'] = address;
    data['pic'] = pic;
    data['pic_phone'] = picPhone;
    data['phone'] = phone;
    data['is_active'] = (isActive == true) ? 1 : 0;
    return data;
  }
}
