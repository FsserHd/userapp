

class ZoneInformationModel {
  bool? success;
  List<Data>? data;
  String? message;

  ZoneInformationModel({this.success, this.data, this.message});

  ZoneInformationModel.fromJson(Map<String, dynamic> json) {
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
  String? franchiseid;
  String? phone;

  Data({this.franchiseid, this.phone});

  Data.fromJson(Map<String, dynamic> json) {
    franchiseid = json['franchiseid'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['franchiseid'] = this.franchiseid;
    data['phone'] = this.phone;
    return data;
  }
}
