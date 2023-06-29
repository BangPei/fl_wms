class Uom {
  int? id;
  String? name;
  String? alias;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Uom(
      {this.id,
      this.name,
      this.alias,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  Uom.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alias = json['alias'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['alias'] = alias;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
