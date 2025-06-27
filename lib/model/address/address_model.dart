

class AddressModel {
  String? userId;
  String? name;
  String? address;
  String? addresstype;
  String? latitude;
  String? longitude;
  String? mobile;

  AddressModel(
      {this.userId,
        this.name,
        this.address,
        this.addresstype,
        this.latitude,
        this.longitude,
        this.mobile});

  AddressModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    address = json['address'];
    addresstype = json['addresstype'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['addresstype'] = this.addresstype;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['mobile'] = this.mobile;
    return data;
  }
}
