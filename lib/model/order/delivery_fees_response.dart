
class DeliveryFeesResponse {
  bool? success;
  Data? data;
  String? message;

  DeliveryFeesResponse({this.success, this.data, this.message});

  DeliveryFeesResponse.fromJson(Map<String, dynamic> json) {
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
  String? amount;
  String? tax;

  Data({this.amount,this.tax});

  Data.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    tax = json['tax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    return data;
  }
}
