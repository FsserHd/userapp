
import '../home/home_model.dart';

class VendorModel {
  bool? success;
  List<VendorData>? data;
  String? message;

  VendorModel({this.success, this.data, this.message});

  VendorModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <VendorData>[];
      json['data'].forEach((v) {
        data!.add(new VendorData.fromJson(v));
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
  String? vendorId;
  String? name;
  String? email;
  String? fssaiNo;
  String? company;
  String? ratingNum;
  String? ratingTotal;
  String? displayName;
  String? address1;
  String? status;
  String? phone;
  String? latitude;
  String? longitude;
  String? logo;
  String? subtitle;
  String? livestatus;
  String? fcmtoken;
  GeneralDetail? generalDetail;
  bool? shopopenstatus;

  Data(
      {this.vendorId,
        this.name,
        this.email,
        this.fssaiNo,
        this.company,
        this.ratingNum,
        this.ratingTotal,
        this.displayName,
        this.address1,
        this.status,
        this.phone,
        this.latitude,
        this.longitude,
        this.logo,
        this.subtitle,
        this.livestatus,
        this.fcmtoken,
        this.generalDetail,
        this.shopopenstatus});

  Data.fromJson(Map<String, dynamic> json) {
    vendorId = json['vendor_id'];
    name = json['name'];
    email = json['email'];
    fssaiNo = json['fssai_no'];
    company = json['company'];
    ratingNum = json['rating_num'];
    ratingTotal = json['rating_total'];
    displayName = json['display_name'];
    address1 = json['address1'];
    status = json['status'];
    phone = json['phone'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    logo = json['logo'];
    subtitle = json['subtitle'];
    livestatus = json['livestatus'];
    fcmtoken = json['fcmtoken'];
    generalDetail = json['general_detail'] != null
        ? new GeneralDetail.fromJson(json['general_detail'])
        : null;
    shopopenstatus = json['shopopenstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vendor_id'] = this.vendorId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['fssai_no'] = this.fssaiNo;
    data['company'] = this.company;
    data['rating_num'] = this.ratingNum;
    data['rating_total'] = this.ratingTotal;
    data['display_name'] = this.displayName;
    data['address1'] = this.address1;
    data['status'] = this.status;
    data['phone'] = this.phone;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['logo'] = this.logo;
    data['subtitle'] = this.subtitle;
    data['livestatus'] = this.livestatus;
    data['fcmtoken'] = this.fcmtoken;
    if (this.generalDetail != null) {
      data['general_detail'] = this.generalDetail!.toJson();
    }
    data['shopopenstatus'] = this.shopopenstatus;
    return data;
  }
}

class GeneralDetail {
  String? id;
  String? storeName;
  String? subtitle;
  String? email;
  String? fssaiNumber;
  String? ownerName;
  String? companyLegalName;
  String? mobile;
  String? alterMobile;
  String? pickupAddress;
  String? pinCode;
  String? landmark;
  String? latitude;
  String? longitude;
  String? openingTime;
  String? closingTime;
  Holidays? holidays;
  String? business;
  String? zoneId;
  String? handOverTime;

  GeneralDetail(
      {this.id,
        this.storeName,
        this.subtitle,
        this.email,
        this.fssaiNumber,
        this.ownerName,
        this.companyLegalName,
        this.mobile,
        this.alterMobile,
        this.pickupAddress,
        this.pinCode,
        this.landmark,
        this.latitude,
        this.longitude,
        this.openingTime,
        this.closingTime,
        this.holidays,
        this.business,
        this.zoneId,
        this.handOverTime});

  GeneralDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['storeName'];
    subtitle = json['subtitle'];
    email = json['email'];
    fssaiNumber = json['fssaiNumber'];
    ownerName = json['ownerName'];
    companyLegalName = json['companyLegalName'];
    mobile = json['mobile'];
    alterMobile = json['alterMobile'];
    pickupAddress = json['pickupAddress'];
    pinCode = json['pinCode'];
    landmark = json['landmark'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    openingTime = json['openingTime'];
    closingTime = json['closingTime'];
    holidays = json['holidays'] != null
        ? new Holidays.fromJson(json['holidays'])
        : null;
    business = json['business'];
    zoneId = json['zoneId'];
    handOverTime = json['handOverTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['storeName'] = this.storeName;
    data['subtitle'] = this.subtitle;
    data['email'] = this.email;
    data['fssaiNumber'] = this.fssaiNumber;
    data['ownerName'] = this.ownerName;
    data['companyLegalName'] = this.companyLegalName;
    data['mobile'] = this.mobile;
    data['alterMobile'] = this.alterMobile;
    data['pickupAddress'] = this.pickupAddress;
    data['pinCode'] = this.pinCode;
    data['landmark'] = this.landmark;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['openingTime'] = this.openingTime;
    data['closingTime'] = this.closingTime;
    if (this.holidays != null) {
      data['holidays'] = this.holidays!.toJson();
    }
    data['business'] = this.business;
    data['zoneId'] = this.zoneId;
    data['handOverTime'] = this.handOverTime;
    return data;
  }
}

class Holidays {
  bool? monVal;
  bool? tueVal;
  bool? wedVal;
  bool? thurVal;
  bool? friVal;
  bool? satVal;
  bool? sunVal;

  Holidays(
      {this.monVal,
        this.tueVal,
        this.wedVal,
        this.thurVal,
        this.friVal,
        this.satVal,
        this.sunVal});

  Holidays.fromJson(Map<String, dynamic> json) {
    monVal = json['monVal'];
    tueVal = json['tueVal'];
    wedVal = json['wedVal'];
    thurVal = json['thurVal'];
    friVal = json['friVal'];
    satVal = json['satVal'];
    sunVal = json['sunVal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monVal'] = this.monVal;
    data['tueVal'] = this.tueVal;
    data['wedVal'] = this.wedVal;
    data['thurVal'] = this.thurVal;
    data['friVal'] = this.friVal;
    data['satVal'] = this.satVal;
    data['sunVal'] = this.sunVal;
    return data;
  }
}
