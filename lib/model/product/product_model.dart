
class ProductModel {
  bool? success;
  List<Data>? data;
  String? message;

  ProductModel({this.success, this.data, this.message});

  ProductModel.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? categoryName;
  List<Productdetails>? productdetails;

  Data({this.id, this.categoryName, this.productdetails});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    if (json['productdetails'] != null) {
      productdetails = <Productdetails>[];
      json['productdetails'].forEach((v) {
        productdetails!.add(new Productdetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    if (this.productdetails != null) {
      data['productdetails'] =
          this.productdetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Productdetails {
  String? id;
  String? productName;
  String? fromTime;
  String? toTime;
  int? qty=0;
  String? description;
  List<Variant>? variant;
  List<Addon>? addon;
  String? status;

  Productdetails(
      {this.id,
        this.productName,
        this.fromTime,
        this.toTime,
        this.description,
        this.variant,
        this.addon,
        this.status});

  Productdetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    fromTime = json['fromTime'];
    toTime = json['toTime'];
    description = json['description'];
    if (json['variant'] != null) {
      variant = <Variant>[];
      json['variant'].forEach((v) {
        variant!.add(new Variant.fromJson(v));
      });
    }
    if (json['addon'] != null) {
      addon = <Addon>[];
      json['addon'].forEach((v) {
        addon!.add(new Addon.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['fromTime'] = this.fromTime;
    data['toTime'] = this.toTime;
    data['description'] = this.description;
    if (this.variant != null) {
      data['variant'] = this.variant!.map((v) => v.toJson()).toList();
    }
    if (this.addon != null) {
      data['addon'] = this.addon!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Variant {
  String? variantId;
  String? productId;
  String? quantity;
  int? qty =0;
  String? name;
  String? discount;
  String? unit;
  String? image;
  int? numOfImgs;
  String? salePrice;
  String? strikePrice;
  String? type;
  bool? selected;
  String? foodType;
  int? packingCharge;
  double? tax;

  Variant(
      {this.variantId,
        this.productId,
        this.quantity,
        this.name,

        this.discount,
        this.unit,
        this.image,
        this.numOfImgs,
        this.salePrice,

        this.type,
        this.selected,
        this.foodType,
        this.packingCharge,this.tax,this.strikePrice});

  Variant.fromJson(Map<String, dynamic> json) {
    variantId = json['variant_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    name = json['name'];
    tax = json['tax'].toDouble();

    discount = json['discount'];
    unit = json['unit'];
    image = json['image'];
    numOfImgs = json['num_of_imgs'];
    salePrice = json['sale_price'];
    strikePrice = json['strike_price'];

    type = json['type'];
    selected = json['selected'];
    foodType = json['foodType'];
    packingCharge = json['packingCharge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['variant_id'] = this.variantId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['name'] = this.name;

    data['discount'] = this.discount;
    data['unit'] = this.unit;
    data['image'] = this.image;
    data['num_of_imgs'] = this.numOfImgs;
    data['sale_price'] = this.salePrice;
    data['strike_price'] = this.strikePrice;
    data['type'] = this.type;
    data['selected'] = this.selected;
    data['foodType'] = this.foodType;
    data['packingCharge'] = this.packingCharge;
    return data;
  }
}

class Addon {
  String? addonId;
  String? productId;
  String? name;
  String? price;
  String? type;
  int? qty = 0;
  bool? selected;
  String? foodType;

  Addon(
      {this.addonId,
        this.productId,
        this.name,
        this.price,
        this.type,
        this.selected,
        this.foodType});

  Addon.fromJson(Map<String, dynamic> json) {
    addonId = json['addon_id'];
    productId = json['product_id'];
    name = json['name'];
    price = json['price'];
    type = json['type'];
    selected = json['selected'];
    foodType = json['foodType'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addon_id'] = this.addonId;
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['type'] = this.type;
    data['selected'] = this.selected;
    data['foodType'] = this.foodType;
    return data;
  }
}
