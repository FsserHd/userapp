class HotelResponse {
  bool? status;
  String? message;
  List<Hotels>? data;

  HotelResponse({this.status, this.message, this.data});

  HotelResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Hotels>[];
      json['data'].forEach((v) {
        data!.add(new Hotels.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hotels {
  int? id;
  int? vendorId;
  String? logo;
  int? averageRating;
  String? latitude;
  String? longitude;
  String? address;
  String? distance = "";
  int? status;
  int? minPrice;
  int? maxPrice;
  int? stars;
  String? createdAt;
  String? updatedAt;
  String? title;

  Hotels(
      {this.id,
        this.vendorId,
        this.logo,
        this.averageRating,
        this.address,
        this.latitude,
        this.longitude,
        this.status,
        this.minPrice,
        this.maxPrice,
        this.stars,
        this.createdAt,
        this.updatedAt,
        this.title});

  Hotels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    logo = json['logo'];
    address = json['address'];
    averageRating = json['average_rating'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
    stars = json['stars'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['logo'] = this.logo;
    data['address'] = this.address;
    data['average_rating'] = this.averageRating;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['stars'] = this.stars;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['title'] = this.title;
    return data;
  }
}
