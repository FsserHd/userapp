

class HomeModel {
  bool? success;
  Data? data;
  String? message;

  HomeModel({this.success, this.data, this.message});

  HomeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  List<Banner>? banner;
  List<Category>? category;
  List<VendorData>? vendor;
  FCode? fCode;

  Data({this.banner, this.category, this.vendor,this.fCode});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banner'] != null) {
      banner = <Banner>[];
      json['banner'].forEach((v) {
        banner!.add(new Banner.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(new Category.fromJson(v));
      });
    }
    if (json['vendor'] != null) {
      vendor = <VendorData>[];
      json['vendor'].forEach((v) {
        vendor!.add(new VendorData.fromJson(v));
      });
    }
    fCode = json['fcode'] != null ? new FCode.fromJson(json['fcode']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banner != null) {
      data['banner'] = this.banner!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banner {
  String? bannerMasterId;
  String? zoneid;
  String? title;
  String? image;
  String? vendorid;
  String? bannertype;
  String? link;

  Banner({this.bannerMasterId, this.zoneid, this.title, this.image,this.vendorid,this.bannertype,this.link});

  Banner.fromJson(Map<String, dynamic> json) {
    bannerMasterId = json['banner_master_id'];
    zoneid = json['zoneid'];
    link = json['link']!=null ? json['link']:"";
    bannertype = json['bannertype']!=null ? json['bannertype']:"";
    title = json['title'];
    image = json['image'];
    vendorid = json['vendorid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner_master_id'] = this.bannerMasterId;
    data['zoneid'] = this.zoneid;
    data['title'] = this.title;
    data['image'] = this.image;
    data['vendorid'] = this.vendorid;
    return data;
  }
}

class FCode {
  String? fCode;


  FCode({this.fCode});

  FCode.fromJson(Map<String, dynamic> json) {
    fCode = json['fcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fcode'] = this.fCode;
    return data;
  }
}

class Category {
  String? shopFocusId;
  String? zoneid;
  String? shopType;
  String? title;
  String? coverImage;

  Category({this.shopFocusId, this.zoneid, this.title, this.coverImage,this.shopType});

  Category.fromJson(Map<String, dynamic> json) {
    shopFocusId = json['shop_focus_id'];
    zoneid = json['zoneid'];
    shopType = json['shop_type'].toString();
    title = json['title'];
    coverImage = json['cover_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_focus_id'] = this.shopFocusId;
    data['zoneid'] = this.zoneid;
    data['title'] = this.title;
    data['shop_type'] = this.shopType;
    data['cover_image'] = this.coverImage;
    return data;
  }
}

class VendorData {
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
  String? type;
  String? livestatus;
  String? fcmtoken;
  String? duration;
  String? distance;
  String? distance1;
  String? discount;
  String? discountType;
  String? upTo;
  String? vendortype;
  String? openTime;
  String? closeTime;
  GeneralDetail? generalDetail;

  VendorData(
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
        this.generalDetail,this.type,this.discount,this.discountType,this.upTo,this.openTime,this.closeTime,this.vendortype});

  VendorData.fromJson(Map<String, dynamic> json) {
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
    openTime = json['opentime'];
    closeTime = json['closetime'];
    logo = json['logo'];
    type = json['type'].toString();
    subtitle = json['subtitle'];
    livestatus = json['livestatus'];
    fcmtoken = json['fcmtoken'];
    discount = json['discount'];
    vendortype = json['vendortype'];
    discountType = json['discount_type'];
    upTo = json['upTo'];
    generalDetail = json['general_detail'] != null
        ? new GeneralDetail.fromJson(json['general_detail'])
        : null;

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
  String? name;
  String? shopName;
  String? subTitle;
  String? alternativeMobile;
  String? openTime;
  String? closeTime;
  String? description;
  String? startedYear;
  String? address;
  bool? autoAssign;
  bool? driverAssign;

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
        this.handOverTime,
        this.name,
        this.shopName,
        this.subTitle,
        this.alternativeMobile,
        this.openTime,
        this.closeTime,
        this.description,
        this.startedYear,
        this.address,
        this.autoAssign,
        this.driverAssign});

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
    name = json['name'];
    shopName = json['shopName'];
    subTitle = json['subTitle'];
    alternativeMobile = json['alternativeMobile'];
    openTime = json['openTime'];
    closeTime = json['closeTime'];
    description = json['description'];
    startedYear = json['startedYear'];
    address = json['address'];
    autoAssign = json['autoAssign'];
    driverAssign = json['driverAssign'];
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
    data['name'] = this.name;
    data['shopName'] = this.shopName;
    data['subTitle'] = this.subTitle;
    data['alternativeMobile'] = this.alternativeMobile;
    data['openTime'] = this.openTime;
    data['closeTime'] = this.closeTime;
    data['description'] = this.description;
    data['startedYear'] = this.startedYear;
    data['address'] = this.address;
    data['autoAssign'] = this.autoAssign;
    data['driverAssign'] = this.driverAssign;
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

class BankDetails {
  String? bankName;
  String? accountNo;
  String? swiftCode;

  BankDetails({this.bankName, this.accountNo, this.swiftCode});

  BankDetails.fromJson(Map<String, dynamic> json) {
    bankName = json['bankName'];
    accountNo = json['accountNo'];
    swiftCode = json['swiftCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankName'] = this.bankName;
    data['accountNo'] = this.accountNo;
    data['swiftCode'] = this.swiftCode;
    return data;
  }
}

class KycSeller {
  Null? id;
  String? personalProof;
  String? selectedYear;
  String? businessType;
  String? holdersName;
  String? accountNumber;
  String? bankCode;
  String? branch;
  String? bankName;

  KycSeller(
      {this.id,
        this.personalProof,
        this.selectedYear,
        this.businessType,
        this.holdersName,
        this.accountNumber,
        this.bankCode,
        this.branch,
        this.bankName});

  KycSeller.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personalProof = json['personalProof'];
    selectedYear = json['selectedYear'];
    businessType = json['businessType'];
    holdersName = json['holdersName'];
    accountNumber = json['accountNumber'];
    bankCode = json['bankCode'];
    branch = json['branch'];
    bankName = json['bankName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['personalProof'] = this.personalProof;
    data['selectedYear'] = this.selectedYear;
    data['businessType'] = this.businessType;
    data['holdersName'] = this.holdersName;
    data['accountNumber'] = this.accountNumber;
    data['bankCode'] = this.bankCode;
    data['branch'] = this.branch;
    data['bankName'] = this.bankName;
    return data;
  }
}
