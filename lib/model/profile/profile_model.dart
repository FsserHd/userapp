
class ProfileModel {
  bool? success;
  Data? data;
  String? message;

  ProfileModel({this.success, this.data, this.message});

  ProfileModel.fromJson(Map<String, dynamic> json) {
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
  String? isCodEnabled;
  String? id;
  String? name;
  String? email;
  String? walletAmount;
  String? phone;
  String? fphone;
  String? gender;
  String? dob;
  String? status;
  bool? auth;
  String? image;
  String? isLogout;

  Data(
      {this.isCodEnabled,
        this.id,
        this.name,
        this.email,
        this.walletAmount,
        this.phone,
        this.status,
        this.auth,
        this.image,this.dob,this.gender,this.fphone,this.isLogout});

  Data.fromJson(Map<String, dynamic> json) {
    isCodEnabled = json['is_cod_enabled'];
    id = json['id'];
    name = json['name']!=null ?json['name']:"";
    email = json['email']!=null ? json['email']:"";
    walletAmount = json['walletAmount'];
    phone = json['phone']!=null ? json['phone']:"";
    fphone = json['fphone']!=null ? json['fphone']:"";
    status = json['status'];
    auth = json['auth'];
    isLogout = json['is_logout']!=null ? json['is_logout']:"";
    image = json['image'];
    dob = json['dob']!=null ? json['dob']:"";
    gender = json['gender']!=null ? json['gender']:"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_cod_enabled'] = this.isCodEnabled;
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['walletAmount'] = this.walletAmount;
    data['phone'] = this.phone;
    data['status'] = this.status;
    data['auth'] = this.auth;
    data['image'] = this.image;
    return data;
  }
}
