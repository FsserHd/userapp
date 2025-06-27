import 'package:userapp/model/database/cart_product_model.dart';
import 'package:userapp/model/order/payment.dart';
import 'package:userapp/model/product/product_model.dart';

import '../address/address.dart';

class Checkout {
  String? id;
  List<CartProductModel> cart = <CartProductModel>[];
  List<Addon> addOn = <Addon>[];
  Address address = Address();
  Payment payment = Payment();
  double grandTotal = 0.0;
  double discount = 0.0;
  double offer = 0.0;
  double subTotal = 0.0;
  double tax = 0.0;
  String? userId;
  String? saleCode;
  String? couponCode;
  bool couponStatus = false;
  String? deliveryTimeSlot;
  String? deliveryTime;
  String? shopId;
  String? shopName;
  String? description;
  String? shopAddress;
  String? shopImage;
  String? subtitle;
  int shopTypeID = 0;
  double km = 0.0;
  double deliveryFees = 0.0;
  double deliveryTips = 0;
  String? shopLatitude;
  String? shopLongitude;
  int deliverType = 0;
  int focusId = 0;
  bool deliveryPossible = false;
  var uploadImage;
  String? zoneId;
  double packingCharge = 0.0;
  int handoverTime = 0;
  double distance = 0.0;
  int couponCheck = 0;
  String? couponAmount;

  Checkout();

  Checkout.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id']?.toString();
      cart = jsonMap['cart'] != null
          ? List.from(jsonMap['cart'])
          .map((element) => CartProductModel.fromJson(element))
          .toList()
          : [];
      addOn = jsonMap['addOn'] != null
          ? List.from(jsonMap['addOn'])
          .map((element) => Addon.fromJson(element))
          .toList()
          : [];
      address = jsonMap['address'] != null
          ? Address.fromJson(jsonMap['address'])
          : Address.fromJson({});
      payment = jsonMap['payment'] != null
          ? Payment.fromJson(jsonMap['payment'])
          : Payment.fromJson({});
      grandTotal = jsonMap['grand_total']?.toDouble() ?? 0;
      tax = jsonMap['tax']?.toDouble() ?? 0;
      couponAmount = jsonMap['couponAmount'];
      discount = jsonMap['discount']?.toDouble() ?? 0;
      description = jsonMap['description'];
      subTotal = jsonMap['sub_total']?.toDouble() ?? 0;
      userId = jsonMap['userID'];
      saleCode = jsonMap['saleCode'];
      couponCode = jsonMap['couponCode'];
      couponStatus = jsonMap['couponStatus'] ?? false;
      deliveryTimeSlot = jsonMap['deliveryTimeSlot'];
      deliveryTime = jsonMap['deliveryTime'];
      shopId = jsonMap['shopId'];
      shopName = jsonMap['shopName'];
      shopAddress = jsonMap['shopAddress'];
      subtitle = jsonMap['subtitle'];
      shopImage = jsonMap['shopImage'];
      shopTypeID = jsonMap['shopTypeID'] ?? 0;
      km = jsonMap['km']?.toDouble() ?? 0;
      deliveryFees = jsonMap['delivery_fees']?.toDouble() ?? 0;
      deliveryTips = jsonMap['delivery_tips']?.toDouble() ?? 0;
      shopLatitude = jsonMap['shopLatitude'];
      shopLongitude = jsonMap['shopLongitude'];
      deliverType = jsonMap['deliverType'] ?? 0;
      focusId = jsonMap['focusId'] ?? 0;
      deliveryPossible = jsonMap['deliveryPossible'] ?? false;
      uploadImage = jsonMap['uploadImage'];
      zoneId = jsonMap['zoneId'];
      packingCharge = jsonMap['packingCharge']?.toDouble() ?? 0;
    } catch (e) {
      id = '';
      grandTotal = 0;
      tax = 0;
      couponAmount = '';
      cart = [];
      address = Address.fromJson({});
      payment = Payment.fromJson({});
      userId = '';
      description = '';
      saleCode = '';
      couponCode = '';
      couponStatus = false;
      deliveryTimeSlot = '';
      deliveryTime = '';
      shopId = '';
      shopImage = '';
      subtitle = '';
      km = 0.0;
      deliveryFees = 0;
      deliveryTips = 0;
      shopLatitude = '';
      shopLongitude = '';
      deliverType = 0;
      focusId = 0;
      uploadImage = '';
      deliveryPossible = false;
    }
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "tax": tax,
    "cart": cart.map((element) => element.toJson()).toList(),
    "addOn": addOn.map((element) => element.toJson()).toList(),
    "address": address.toJson(),
    "payment": payment.toJson(),
    "grand_total": grandTotal,
    "sub_total": subTotal,
    "discount": discount,
    "userId": userId,
    "saleCode": saleCode,
    "couponCode": couponCode,
    "couponStatus": couponStatus,
    "deliveryTimeSlot": deliveryTimeSlot,
    "deliveryTime": deliveryTime,
    "description": description,
    "shopId": shopId,
    "shopName": shopName,
    "shopImage": shopImage,
    "km": km,
    "zoneId":zoneId,
    "subtitle": subtitle,
    "delivery_fees": deliveryFees,
    "delivery_tips": deliveryTips,
    "deliverType": deliverType,
    "focusId": focusId,
    "deliveryPossible": deliveryPossible,
    "uploadImage": uploadImage,
    "shopAddress": shopAddress,
    'packingCharge': packingCharge,
    "handoverTime": handoverTime,
    "couponAmount": couponAmount
  };

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "tax": tax,
      "cart": cart.map((element) => element.toJson()).toList(),
      "address": address.toJson(),
      "payment": payment.toJson(),
      "grand_total": grandTotal,
      "sub_total": subTotal,
      "discount": discount,
      "userId": userId,
      "saleCode": saleCode,
      "couponCode": couponCode,
      "couponStatus": couponStatus,
      "deliveryTimeSlot": deliveryTimeSlot,
      "deliveryTime": deliveryTime,
      "shopId": shopId,
      "shopName": shopName,
      "shopImage": shopImage,
      "shopTypeID": shopTypeID,
      "km": km,
      "zoneId":zoneId,
      "subtitle": subtitle,
      "delivery_fees": deliveryFees,
      "delivery_tips": deliveryTips,
      "shopLatitude": shopLatitude,
      "shopLongitude": shopLongitude,
      "deliverType": deliverType,
      "focusId": focusId,
      "shopAddress": shopAddress,
      "deliveryPossible": deliveryPossible,
      "zoneId": zoneId,
      "packingCharge": packingCharge,
      "handoverTime": handoverTime,
      "couponAmount": couponAmount
    };
  }

  @override
  bool operator ==(Object other) {
    return other is Checkout && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
