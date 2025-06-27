

class VendorDetailsModel {
  bool? success;
  Data? data;
  String? message;

  VendorDetailsModel({this.success, this.data, this.message});

  VendorDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? company;
  String? displayName;
  String? address;
  String? latitude;
  String? longitude;
  String? focusId;

  String? discount;
  String? discountType;
  String? upTo;
  String? logo;
  String? zoneId;

  Data(
      {this.company,
        this.displayName,
        this.address,
        this.latitude,
        this.longitude,
        this.logo,this.zoneId,this.discount,this.discountType,this.upTo,this.focusId});

  Data.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    displayName = json['display_name'];
    displayName = json['display_name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    logo = json['logo'];
    zoneId = json['zone_id'];
    discount = json['discount'];
    focusId = json['focus_id'];
    discountType = json['discount_type'];
    upTo = json['upTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company'] = this.company;
    data['display_name'] = this.displayName;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['logo'] = this.logo;
    return data;
  }
}
