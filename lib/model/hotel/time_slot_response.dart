


class TimeSlotResponse {
  bool? status;
  String? message;
  Data? data;

  TimeSlotResponse({this.status, this.message, this.data});

  TimeSlotResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<HourlyPrices>? hourlyPrices;

  Data({this.hourlyPrices});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['hourlyPrices'] != null) {
      hourlyPrices = <HourlyPrices>[];
      json['hourlyPrices'].forEach((v) {
        hourlyPrices!.add(new HourlyPrices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hourlyPrices != null) {
      data['hourlyPrices'] = this.hourlyPrices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HourlyPrices {
  int? id;
  int? vendorId;
  int? hotelId;
  int? roomId;
  int? hourId;
  int? hour;
  int? price;
  String? createdAt;
  String? updatedAt;
  int? serialNumber;

  HourlyPrices(
      {this.id,
        this.vendorId,
        this.hotelId,
        this.roomId,
        this.hourId,
        this.hour,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.serialNumber});

  HourlyPrices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    hotelId = json['hotel_id'];
    roomId = json['room_id'];
    hourId = json['hour_id'];
    hour = json['hour'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    serialNumber = json['serial_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['hotel_id'] = this.hotelId;
    data['room_id'] = this.roomId;
    data['hour_id'] = this.hourId;
    data['hour'] = this.hour;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['serial_number'] = this.serialNumber;
    return data;
  }
}

