

class OrderModel {
  bool? success;
  List<Data>? data;
  String? message;

  OrderModel({this.success, this.data, this.message});

  OrderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? userid;
  String? saleCode;
  List<ProductDetails>? productDetails;
  ShippingAddress? shippingAddress;
  String? shipping;
  String? paymentType;
  String? paymentStatus;
  String? paymentTimestamp;
  double? grandTotal;
  String? saleDatetime;
  String? delivaryDatetime;
  String? orderType;
  String? logo;
  String? status;
  String? deliveryState;
  String? deliveryAssigned;
  String? otp;
  String? cookingtime;
  String? rating;
  Vendor? vendor;
  String? shopTypeId;
  Duration remainingTime = Duration();
  bool isCooking = false;

  Data(
      {this.userid,
        this.saleCode,
        this.productDetails,
        this.shippingAddress,
        this.shipping,
        this.paymentType,
        this.paymentStatus,
        this.paymentTimestamp,
        this.grandTotal,
        this.saleDatetime,
        this.delivaryDatetime,
        this.orderType,
        this.status,
        this.otp,
        this.rating,
        this.vendor,
        this.shopTypeId,this.logo,this.deliveryAssigned,this.deliveryState,this.cookingtime});

  Data.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    saleCode = json['sale_code'];
    if (json['product_details'] != null) {
      productDetails = <ProductDetails>[];
      json['product_details'].forEach((v) {
        productDetails!.add(new ProductDetails.fromJson(v));
      });
    }
    shippingAddress = json['shipping_address'] != null
        ? new ShippingAddress.fromJson(json['shipping_address'])
        : null;
    shipping = json['shipping'];
    cookingtime = json['cooking_time'];
    paymentType = json['payment_type'];
    paymentStatus = json['payment_status'];
    paymentTimestamp = json['payment_timestamp'];
    grandTotal = json['grand_total'].toDouble();
    saleDatetime = json['sale_datetime'];
    delivaryDatetime = json['delivary_datetime'];
    orderType = json['orderType'];
    deliveryState = json['delivery_state'];
    deliveryAssigned = json['delivery_assigned'];
    status = json['status'];
    otp = json['otp'];
    rating = json['rating'];
    logo = json['logo'];
    vendor =
    json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
    shopTypeId = json['shopTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['sale_code'] = this.saleCode;
    if (this.productDetails != null) {
      data['product_details'] =
          this.productDetails!.map((v) => v.toJson()).toList();
    }
    if (this.shippingAddress != null) {
      data['shipping_address'] = this.shippingAddress!.toJson();
    }
    data['shipping'] = this.shipping;
    data['payment_type'] = this.paymentType;
    data['payment_status'] = this.paymentStatus;
    data['payment_timestamp'] = this.paymentTimestamp;
    data['grand_total'] = this.grandTotal;
    data['sale_datetime'] = this.saleDatetime;
    data['delivary_datetime'] = this.delivaryDatetime;
    data['orderType'] = this.orderType;
    data['status'] = this.status;
    data['otp'] = this.otp;
    data['rating'] = this.rating;
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.toJson();
    }
    data['shopTypeId'] = this.shopTypeId;
    return data;
  }
}

class ProductDetails {
  String? id;
  String? productName;
  String? price;
  int? qty;
  double? tax;


  ProductDetails(
      {this.id,
        this.productName,
        this.price,
        this.tax,
        this.qty,
});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    price = json['price'];
    qty = json['qty'];
    tax = json['tax'].toDouble();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['price'] = this.price;
    data['qty'] = this.qty;
    return data;
  }
}

class ShippingAddress {
  String? id;
  String? addressSelect;
  double? latitude;
  double? longitude;
  String? isDefault;
  String? username;
  String? phone;
  String? userId;

  ShippingAddress(
      {this.id,
        this.addressSelect,
        this.latitude,
        this.longitude,
        this.isDefault,
        this.username,
        this.phone,
        this.userId});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
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

class Vendor {
  String? storeName;
  String? mobile;
  String? subTitle;
  String? address;
  String? latitude;
  String? longitude;

  Vendor({this.storeName, this.mobile, this.latitude, this.longitude,this.address,this.subTitle});

  Vendor.fromJson(Map<String, dynamic> json) {
    storeName = json['storeName'];
    mobile = json['mobile'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    subTitle = json['subTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storeName'] = this.storeName;
    data['mobile'] = this.mobile;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
