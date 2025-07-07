


class VendorTypeResponse {
  bool? success;
  List<VendorType>? data;
  String? message;

  VendorTypeResponse({this.success, this.data, this.message});

  VendorTypeResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <VendorType>[];
      json['data'].forEach((v) {
        data!.add(new VendorType.fromJson(v));
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

class VendorType {
  String? id;
  String? name;
  String? createdAt;

  VendorType({this.id, this.name, this.createdAt});

  VendorType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    return data;
  }
}
