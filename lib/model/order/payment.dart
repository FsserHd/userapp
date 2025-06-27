

import 'package:userapp/model/product/product_model.dart';

class Payment {
  Null? id;
  Null? status;
  String? paymentType;
  String? method;
  int? grandTotal;
  int? subTotal;
  double? discount;
  double? vendorDiscount;
  String? km;
  int? deliveryFees;
  int? deliveryTips;
  double? tax;
  double? packingCharge;


  Payment(
      {this.id,
        this.status,
        this.paymentType,
        this.method,
        this.grandTotal,
        this.subTotal,
        this.discount,
        this.km,
        this.deliveryFees,
        this.deliveryTips,
        this.tax,
        this.packingCharge,this.vendorDiscount});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    paymentType = json['paymentType'];
    method = json['method'];
    grandTotal = json['grand_total'];
    subTotal = json['sub_total'];
    discount = json['discount'];
    km = json['km'];
    deliveryFees = json['delivery_fees'];
    deliveryTips = json['delivery_tips'];
    tax = json['tax'];
    vendorDiscount = json['vendorDiscount'];
    packingCharge = json['packingCharge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['paymentType'] = this.paymentType;
    data['method'] = this.method;
    data['grand_total'] = this.grandTotal;
    data['sub_total'] = this.subTotal;
    data['discount'] = this.discount;
    data['km'] = this.km;
    data['delivery_fees'] = this.deliveryFees;
    data['delivery_tips'] = this.deliveryTips;
    data['tax'] = this.tax;
    data['packingCharge'] = this.packingCharge;
    data['vendorDiscount'] = this.vendorDiscount;
    return data;
  }
}
