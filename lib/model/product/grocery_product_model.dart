

class GroceryProductModel {
  bool? success;
  List<Data>? data;
  String? message;

  GroceryProductModel({this.success, this.data, this.message});

  GroceryProductModel.fromJson(Map<String, dynamic> json) {
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
  String? subcategoryName;
  String? image;
  List<GroceryProductdetails>? productdetails;

  Data({this.id, this.subcategoryName, this.image, this.productdetails});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subcategoryName = json['subcategory_name'];
    image = json['image'];
    if (json['productdetails'] != null) {
      productdetails = <GroceryProductdetails>[];
      json['productdetails'].forEach((v) {
        productdetails!.add(new GroceryProductdetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subcategory_name'] = this.subcategoryName;
    data['image'] = this.image;
    if (this.productdetails != null) {
      data['productdetails'] =
          this.productdetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GroceryProductdetails {
  String? id;
  int? qty=0;
  String? productName;
  List<GroceryVariant>? variant;
  String? productType;
  int? selectedIndex= 0;

  GroceryProductdetails({this.id, this.productName, this.variant, this.productType});

  GroceryProductdetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    if (json['variant'] != null) {
      variant = <GroceryVariant>[];
      json['variant'].forEach((v) {
        variant!.add(new GroceryVariant.fromJson(v));
      });
    }
    productType = json['productType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    if (this.variant != null) {
      data['variant'] = this.variant!.map((v) => v.toJson()).toList();
    }
    data['productType'] = this.productType;
    return data;
  }
}

class GroceryVariant {
  String? variantId;
  String? productId;
  String? quantity;
  String? name;
  int? qty = 0;
  String? unit;
  String? salePrice;
  String? strikePrice;
  String? purchasePrice;
  String? discount;
  int? packingCharge;
  double? tax;
  String? type;
  bool? selected;
  String? image;

  GroceryVariant(
      {this.variantId,
        this.productId,
        this.quantity,
        this.name,
        this.unit,
        this.salePrice,
        this.strikePrice,
        this.discount,
        this.packingCharge,
        this.tax,
        this.type,
        this.selected,
        this.image,this.qty,this.purchasePrice});

  GroceryVariant.fromJson(Map<String, dynamic> json) {
    variantId = json['variant_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    name = json['name'];
    unit = json['unit'];
    salePrice = json['sale_price'];
    strikePrice = json['strike_price'];

    discount = json['discount'];
    packingCharge = json['packingCharge'];
    tax = json['tax'].toDouble();
    type = json['type'];
    selected = json['selected'];
    qty = json['qty'];
    image = json['image'];
    purchasePrice = json['purchase_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['variant_id'] = this.variantId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['name'] = this.name;
    data['unit'] = this.unit;
    data['sale_price'] = this.salePrice;
    data['strike_price'] = this.strikePrice;
    data['purchase_price'] = this.purchasePrice;
    data['discount'] = this.discount;
    data['packingCharge'] = this.packingCharge;
    data['tax'] = this.tax;
    data['type'] = this.type;
    data['selected'] = this.selected;
    data['image'] = this.image;
    data['qty'] = this.qty;
    return data;
  }
}
