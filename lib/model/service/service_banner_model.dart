

class ServiceBannerModel {
  bool? success;
  Data? data;
  String? message;

  ServiceBannerModel({this.success, this.data, this.message});

  ServiceBannerModel.fromJson(Map<String, dynamic> json) {
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
  List<ServiceBanner>? banner;

  Data({this.banner});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banner'] != null) {
      banner = <ServiceBanner>[];
      json['banner'].forEach((v) {
        banner!.add(new ServiceBanner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banner != null) {
      data['banner'] = this.banner!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceBanner {
  String? bannerMasterId;
  String? zoneid;
  String? title;
  Null? shopType;
  String? image;

  ServiceBanner(
      {this.bannerMasterId,
        this.zoneid,
        this.title,
        this.shopType,
        this.image});

  ServiceBanner.fromJson(Map<String, dynamic> json) {
    bannerMasterId = json['banner_master_id'];
    zoneid = json['zoneid'];
    title = json['title'];
    shopType = json['shop_type'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner_master_id'] = this.bannerMasterId;
    data['zoneid'] = this.zoneid;
    data['title'] = this.title;
    data['shop_type'] = this.shopType;
    data['image'] = this.image;
    return data;
  }
}
