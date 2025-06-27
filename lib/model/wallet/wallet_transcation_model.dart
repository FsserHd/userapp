

class WalletTranscationModel {
  bool? success;
  List<Data>? data;
  String? message;

  WalletTranscationModel({this.success, this.data, this.message});

  WalletTranscationModel.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? transactionsId;
  String? type;
  String? amount;
  String? balance;
  String? status;
  String? date;
  Null? accessVendor;
  Null? productId;

  Data(
      {this.userId,
        this.transactionsId,
        this.type,
        this.amount,
        this.balance,
        this.status,
        this.date,
        this.accessVendor,
        this.productId});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    transactionsId = json['transactions_id'];
    type = json['type'];
    amount = json['amount'];
    balance = json['balance'];
    status = json['status'];
    date = json['date'];
    accessVendor = json['access_vendor'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['transactions_id'] = this.transactionsId;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['balance'] = this.balance;
    data['status'] = this.status;
    data['date'] = this.date;
    data['access_vendor'] = this.accessVendor;
    data['product_id'] = this.productId;
    return data;
  }
}
