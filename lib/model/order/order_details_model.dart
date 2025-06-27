
import 'package:userapp/model/product/product_model.dart';

class OrderDetailsModel {
  bool? success;
  OrderDetails? data;
  String? message;

  OrderDetailsModel({this.success, this.data, this.message});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new OrderDetails.fromJson(json['data']) : null;
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

class OrderDetails {
  String? id;
  List<ProductDetails>? productDetails;
  List<Addon>? addOnDetails;
  AddressUser? addressUser;
  AddressShop? addressShop;
  Payment? payment;
  String? orderDate;
  String? status;
  String? discount;
  String? orderType;
  String? deliverySlot;
  String? userId;
  String? saleCode;
  bool? instanceDelivery;
  String? rating;
  String? driverId;
  String? otp;
  String? driverRating;
  String? deliveryTime;
  String? deliveryAssigned;
  String? deliveryState;
  String? driverName;
  String? shopTypeId;

  OrderDetails(
      {this.id,
        this.productDetails,
        this.addressUser,
        this.addressShop,
        this.payment,
        this.orderDate,
        this.status,
        this.discount,
        this.orderType,
        this.deliverySlot,
        this.userId,
        this.saleCode,
        this.instanceDelivery,
        this.rating,
        this.driverId,
        this.otp,
        this.driverRating,
        this.deliveryTime,
        this.driverName,
        this.shopTypeId,this.deliveryState,this.deliveryAssigned,this.addOnDetails});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['productDetails'] != null) {
      productDetails = <ProductDetails>[];
      json['productDetails'].forEach((v) {
        productDetails!.add(new ProductDetails.fromJson(v));
      });
    }
    if (json['addOn'] != null) {
      addOnDetails = <Addon>[];
      json['addOn'].forEach((v) {
        addOnDetails!.add(new Addon.fromJson(v));
      });
    }
    addressUser = json['addressUser'] != null
        ? new AddressUser.fromJson(json['addressUser'])
        : null;
    addressShop = json['addressShop'] != null
        ? new AddressShop.fromJson(json['addressShop'])
        : null;
    payment =
    json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    orderDate = json['orderDate'];
    status = json['status'];
    discount = json['discount'];
    orderType = json['orderType'];
    deliverySlot = json['delivery_slot'];
    userId = json['userId'];
    saleCode = json['saleCode'];
    instanceDelivery = json['instanceDelivery'];
    rating = json['rating'];
    driverId = json['driverId'];
    otp = json['otp'];
    driverRating = json['driverRating'];
    deliveryTime = json['deliveryTime'];
    deliverySlot = json['deliverySlot'];
    driverName = json['driverName'];
    deliveryAssigned = json['delivery_assigned'];
    deliveryState = json['delivery_state'];
    shopTypeId = json['shopTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.productDetails != null) {
      data['productDetails'] =
          this.productDetails!.map((v) => v.toJson()).toList();
    }
    if (this.addressUser != null) {
      data['addressUser'] = this.addressUser!.toJson();
    }
    if (this.addressShop != null) {
      data['addressShop'] = this.addressShop!.toJson();
    }
    if (this.payment != null) {
      data['payment'] = this.payment!.toJson();
    }
    data['orderDate'] = this.orderDate;
    data['status'] = this.status;
    data['discount'] = this.discount;
    data['orderType'] = this.orderType;
    data['delivery_slot'] = this.deliverySlot;
    data['userId'] = this.userId;
    data['saleCode'] = this.saleCode;
    data['instanceDelivery'] = this.instanceDelivery;
    data['rating'] = this.rating;
    data['driverId'] = this.driverId;
    data['otp'] = this.otp;
    data['driverRating'] = this.driverRating;
    data['deliveryTime'] = this.deliveryTime;
    data['deliverySlot'] = this.deliverySlot;
    data['driverName'] = this.driverName;
    data['shopTypeId'] = this.shopTypeId;
    return data;
  }
}

class ProductDetails {
  String? id;
  String? productName;
  String? price;
  String? strike;
  int? offer;
  String? quantity;
  int? qty;
  String? variant;
  String? variantValue;
  String? userId;
  String? cartId;
  String? unit;
  String? shopId;
  String? image;
  double? tax;
  String? discount;
  double? packingCharge;

  ProductDetails(
      {this.id,
        this.productName,
        this.price,
        this.strike,
        this.offer,
        this.quantity,
        this.qty,
        this.variant,
        this.variantValue,
        this.userId,
        this.cartId,
        this.unit,
        this.shopId,
        this.image,
        this.tax,
        this.discount,
        this.packingCharge});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    price = json['price'];
    strike = json['strike'];
    offer = json['offer'];
    quantity = json['quantity'];
    qty = json['qty'];
    variant = json['variant'];
    variantValue = json['variantValue'];
    userId = json['userId'];
    cartId = json['cartId'];
    unit = json['unit'];
    shopId = json['shopId'];
    image = json['image'];
    tax = json['tax'].toDouble();
    discount = json['discount'].toString();
    packingCharge = json['packingCharge'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['price'] = this.price;
    data['strike'] = this.strike;
    data['offer'] = this.offer;
    data['quantity'] = this.quantity;
    data['qty'] = this.qty;
    data['variant'] = this.variant;
    data['variantValue'] = this.variantValue;
    data['userId'] = this.userId;
    data['cartId'] = this.cartId;
    data['unit'] = this.unit;
    data['shopId'] = this.shopId;
    data['image'] = this.image;
    data['tax'] = this.tax;
    data['discount'] = this.discount;
    data['packingCharge'] = this.packingCharge;
    return data;
  }
}

class AddressUser {
  Null? id;
  String? addressSelect;
  double? latitude;
  double? longitude;
  Null? isDefault;
  Null? username;
  String? phone;
  String? userId;

  AddressUser(
      {this.id,
        this.addressSelect,
        this.latitude,
        this.longitude,
        this.isDefault,
        this.username,
        this.phone,
        this.userId});

  AddressUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressSelect = json['addressSelect'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isDefault = json['isDefault'];
    username = json['username'];
    phone = json['phone'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['addressSelect'] = this.addressSelect;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['isDefault'] = this.isDefault;
    data['username'] = this.username;
    data['phone'] = this.phone;
    data['userId'] = this.userId;
    return data;
  }
}

class AddressShop {
  String? id;
  String? addressSelect;
  String? username;
  String? logo;
  String? company;
  String? phone;
  double? latitude;
  double? longitude;

  AddressShop(
      {this.id,
        this.addressSelect,
        this.username,
        this.phone,
        this.latitude,
        this.longitude,this.logo,this.company});

  AddressShop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressSelect = json['addressSelect'];
    username = json['username'];
    phone = json['phone'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    logo = json['logo'];
    company = json['subtitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['addressSelect'] = this.addressSelect;
    data['username'] = this.username;
    data['phone'] = this.phone;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

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
    discount = json['discount'].toDouble();
    vendorDiscount = json['vendorDiscount'].toDouble();
    km = json['km'];
    deliveryFees = json['delivery_fees'];
    deliveryTips = json['delivery_tips'];
    tax = json['tax'].toDouble();
    packingCharge = json['packingCharge'].toDouble();
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
    return data;
  }
}
