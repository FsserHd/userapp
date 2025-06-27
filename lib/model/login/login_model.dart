

class LoginModel {
  String? phone;
  String? otp;

  LoginModel({this.phone, this.otp});

  LoginModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['otp'] = this.otp;
    return data;
  }
}
