class ServiceResponseModel {
  bool? success;
  List<Service>? data;
  String? message;

  ServiceResponseModel({this.success, this.data, this.message});

  ServiceResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Service>[];
      json['data'].forEach((v) {
        data!.add(new Service.fromJson(v));
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

class Service {
  String? id;
  String? fromname;
  String? fphoneno;
  String? fromtime;
  String? serviceCode;
  String? fromlocation;
  String? toname;
  String? tophoneno;
  String? tolocation;
  String? description;
  String? status;
  String? distance1;
  String? deliveryfees;
  String? deliveryStatus;
  String? userid;
  String? fromLatitude;
  String? fromLongitude;
  String? toLatitude;
  String? toLongitude;
  String? driverId;
  String? paymentMode;
  String? otp;
  String? types;
 // List<Types>? types;
  String? createdAt;

  Service(
      {this.id,
        this.fromname,
        this.fphoneno,
        this.fromtime,
        this.fromlocation,
        this.toname,
        this.tophoneno,
        this.tolocation,
        this.description,
        this.status,
        this.distance1,
        this.deliveryfees,
        this.userid,
        this.fromLatitude,
        this.fromLongitude,
        this.toLatitude,
        this.toLongitude,
        this.types,
        this.createdAt,this.deliveryStatus,this.driverId,this.paymentMode,this.serviceCode,this.otp});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromname = json['fromname'];
    serviceCode = json['serviceCode'];
    fphoneno = json['fphoneno'];
    fromtime = json['fromtime'];
    fromlocation = json['fromlocation'];
    driverId = json['driver_id'];
    toname = json['toname'];
    tophoneno = json['tophoneno'];

    tolocation = json['tolocation'];
    description = json['description'];
    otp = json['otp'];
    status = json['status'];
    distance1 = json['distance1'];
    deliveryfees = json['deliveryfees'];
    userid = json['userid'];
    fromLatitude = json['from_latitude'];
    fromLongitude = json['from_longitude'];
    toLatitude = json['to_latitude'];
    toLongitude = json['to_longitude'];
    types = json['types'];
    paymentMode = json['paymentMode'];

    createdAt = json['created_at'];
    deliveryStatus = json['delivery_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fromname'] = this.fromname;
    data['fphoneno'] = this.fphoneno;
    data['fromtime'] = this.fromtime;
    data['fromlocation'] = this.fromlocation;
    data['toname'] = this.toname;
    data['tophoneno'] = this.tophoneno;

    data['tolocation'] = this.tolocation;
    data['description'] = this.description;
    data['status'] = this.status;
    data['distance1'] = this.distance1;
    data['deliveryfees'] = this.deliveryfees;
    data['userid'] = this.userid;
    data['from_latitude'] = this.fromLatitude;
    data['from_longitude'] = this.fromLongitude;
    data['to_latitude'] = this.toLatitude;
    data['to_longitude'] = this.toLongitude;
    data['types'] = this.types;
    data['paymentMode'] = this.paymentMode;

    data['created_at'] = this.createdAt;
    return data;
  }
}

class Types {
  String? name;
  String? image;

  Types({this.name, this.image});

  Types.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
