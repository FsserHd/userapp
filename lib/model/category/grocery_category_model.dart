

class GroceryCategoryModel {
  List<GroceryData>? data;
  bool? success;
  String? message;

  GroceryCategoryModel({this.data, this.success, this.message});

  GroceryCategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GroceryData>[];
      json['data'].forEach((v) {
        data!.add(new GroceryData.fromJson(v));
      });
    }
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class GroceryData {
  String? categoryId;
  String? categoryName;
  String? status;
  String? vendorId;
  String? banner;

  GroceryData(
      {this.categoryId,
        this.categoryName,
        this.status,
        this.vendorId,
        this.banner});

  GroceryData.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    status = json['status'];
    vendorId = json['vendorId'];
    banner = json['banner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['status'] = this.status;
    data['vendorId'] = this.vendorId;
    data['banner'] = this.banner;
    return data;
  }
}
