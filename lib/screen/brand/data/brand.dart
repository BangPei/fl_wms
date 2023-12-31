class Brand {
  int? id;
  String? name;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Brand({this.id, this.name, this.isActive, this.createdAt, this.updatedAt});

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['is_active'] = (isActive == true) ? 1 : 0;
    return data;
  }
}
