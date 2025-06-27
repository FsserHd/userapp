

class AddressResponseModel {
  bool? success;
  List<Data>? data;
  String? message;

  AddressResponseModel({this.success, this.data, this.message});

  AddressResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? addressId;
  String? userId;
  String? name;
  String? address;
  String? addresstype;
  String? distance = "";
  String? latitude;
  String? longitude;
  String? mobile;
  String? date;

  Data(
      {this.addressId,
        this.userId,
        this.name,
        this.address,
        this.addresstype,
        this.latitude,
        this.longitude,
        this.mobile,
        this.date});

  Data.fromJson(Map<String, dynamic> json) {
    addressId = json['address_id'];
    userId = json['user_id'];
    name = json['name'];
    address = json['address'];
    addresstype = json['addresstype'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    mobile = json['mobile'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_id'] = this.addressId;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['addresstype'] = this.addresstype;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['mobile'] = this.mobile;
    data['date'] = this.date;
    return data;
  }
}
