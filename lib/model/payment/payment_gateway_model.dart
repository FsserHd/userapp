

class PaymentGatewayModel {
  bool? success;
  List<Data>? data;
  String? message;
  String? cod;

  PaymentGatewayModel({this.success, this.data, this.message});

  PaymentGatewayModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    cod = json['cod'];
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
  String? name;
  String? description;
  String? zoneId;
  String? image;
  String? merchantid;
  String? merchantkey;
  String? saltkey;
  String? status;

  Data(
      {this.name,
        this.description,
        this.zoneId,
        this.merchantid,
        this.merchantkey,
        this.saltkey,this.image,this.status});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    zoneId = json['zone_id'];
    merchantid = json['merchantid'];
    merchantkey = json['merchantkey'];
    saltkey = json['saltkey'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['zone_id'] = this.zoneId;
    data['merchantid'] = this.merchantid;
    data['merchantkey'] = this.merchantkey;
    data['saltkey'] = this.saltkey;
    data['image'] = this.image;
    return data;
  }
}
