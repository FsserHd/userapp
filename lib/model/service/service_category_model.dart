
class ServiceCategoryModel {
  bool? success;
  List<ServiceCategory>? data;
  String? message;

  ServiceCategoryModel({this.success, this.data, this.message});

  ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ServiceCategory>[];
      json['data'].forEach((v) {
        data!.add(new ServiceCategory.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class ServiceCategory {
  String? id;
  String? name;
  String? image;
  String? description;
  String? zoneId;
  String? minPrice;
  String? maxPrice;
  String? maincategory;
  String? paymenttype;
  String? createdAt;
  String? status;

  ServiceCategory(
      {this.id,
        this.name,
        this.image,
        this.description,
        this.zoneId,
        this.minPrice,
        this.maxPrice,
        this.createdAt,
        this.status,this.paymenttype,this.maincategory});

  ServiceCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    maincategory = json['maincategory'];
    description = json['description'];
    image = json['image'];
    zoneId = json['zone_id'];
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
    createdAt = json['created_at'];
    paymenttype = json['paymenttype'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['maincategory'] = this.maincategory;
    data['image'] = this.image;
    data['zone_id'] = this.zoneId;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}

