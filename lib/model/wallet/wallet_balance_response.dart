class WalletBalanceResponse {
  bool? success;
  List<Data>? data;
  String? message;

  WalletBalanceResponse({this.success, this.data, this.message});

  WalletBalanceResponse.fromJson(Map<String, dynamic> json) {
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
  String? balance;
  String? walletId;

  Data({this.userId, this.balance, this.walletId});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    balance = json['balance'];
    walletId = json['wallet_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['balance'] = this.balance;
    data['wallet_id'] = this.walletId;
    return data;
  }
}
