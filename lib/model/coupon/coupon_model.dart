

class CouponModel {
  bool? success;
  List<Coupon>? data;
  String? message;

  CouponModel({this.success, this.data, this.message});

  CouponModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Coupon>[];
      json['data'].forEach((v) {
        data!.add(new Coupon.fromJson(v));
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

class Coupon {
  String? couponId;
  String? zoneId;
  String? vendorId;
  String? title;
  String? discountType;
  String? code;
  String? discount;
  String? minimumPurchasedAmount;

  Coupon(
      {this.couponId,
        this.zoneId,
        this.vendorId,
        this.title,
        this.code,
        this.discount,
        this.minimumPurchasedAmount,this.discountType});

  Coupon.fromJson(Map<String, dynamic> json) {
    couponId = json['coupon_id'];
    zoneId = json['zone_id'];
    vendorId = json['vendor_id'];
    title = json['title'];
    discountType = json['discountType'];
    code = json['code'];
    discount = json['discount'];
    minimumPurchasedAmount = json['minimumPurchasedAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coupon_id'] = this.couponId;
    data['zone_id'] = this.zoneId;
    data['vendor_id'] = this.vendorId;
    data['title'] = this.title;
    data['code'] = this.code;
    data['discount'] = this.discount;
    data['minimumPurchasedAmount'] = this.minimumPurchasedAmount;
    return data;
  }
}
