
class AddServiceRequest {
  String? fromname;
  String? fphoneno;
  String? fromtime;
  String? fromlocation;
  String? toname;
  String? tophoneno;
  String? totime;
  String? tolocation;
  String? description;
  String? status;
  String? distance1;
  String? deliveryfees;
  String? userid;
  String? zoneId;
  String? fLatitude;
  String? fLongitude;
  String? tLatitude;
  String? tLongitude;
  String? paymentMode;
  String? types;
  String? maincategory;
  String? serviceCode;

  AddServiceRequest(
      {this.fromname,
        this.fphoneno,
        this.fromtime,
        this.fromlocation,
        this.toname,
        this.tophoneno,
        this.totime,
        this.tolocation,
        this.description,
        this.status,
        this.distance1,
        this.deliveryfees,
        this.userid,this.fLatitude,this.fLongitude,this.tLatitude,this.tLongitude,this.types,this.zoneId,this.serviceCode,this.maincategory});

  AddServiceRequest.fromJson(Map<String, dynamic> json) {
    fromname = json['fromname'];
    fphoneno = json['fphoneno'];
    fromtime = json['fromtime'];
    fromlocation = json['fromlocation'];
    toname = json['toname'];
    tophoneno = json['tophoneno'];
    totime = json['totime'];
    tolocation = json['tolocation'];
    description = json['description'];
    status = json['status'];
    distance1 = json['distance1'];
    deliveryfees = json['deliveryfees'];
    userid = json['userid'];
    fLatitude = json['fLatitude'];
    fLongitude = json['fLongitude'];
    tLatitude = json['tLatitude'];
    tLongitude = json['tLongitude'];
    paymentMode = json['paymentMode'];
    types = json['types'];
    zoneId = json['zoneId'];
    serviceCode = json['serviceCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromname'] = this.fromname;
    data['fphoneno'] = this.fphoneno;
    data['fromtime'] = this.fromtime;
    data['fromlocation'] = this.fromlocation;
    data['toname'] = this.toname;
    data['tophoneno'] = this.tophoneno;
    data['totime'] = this.totime;
    data['tolocation'] = this.tolocation;
    data['description'] = this.description;
    data['maincategory'] = this.maincategory;
    data['status'] = this.status;
    data['distance1'] = this.distance1;
    data['deliveryfees'] = this.deliveryfees;
    data['userid'] = this.userid;
    data['fLatitude'] = this.fLatitude;
    data['fLongitude'] = this.fLongitude;
    data['tLatitude'] = this.tLatitude;
    data['tLongitude'] = this.tLongitude;
    data['types'] = this.types;
    data['zoneId'] = this.zoneId;
    data['paymentMode'] = this.paymentMode;
    data['serviceCode'] = this.serviceCode;
    return data;
  }
}
