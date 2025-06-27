
class OtpModel {
  bool? success;
  int? otp;
  String? message;

  OtpModel({this.success, this.otp, this.message});

  OtpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    otp = json['otp'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['otp'] = this.otp;
    data['message'] = this.message;
    return data;
  }
}
