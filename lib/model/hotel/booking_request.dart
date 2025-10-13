

class BookingRequest {
  int? gateway;
  int? price;
  String? vendorId;
  String? priceId;
  String? hours;
  String? hotelId;
  String? roomId;
  String? checkInTime;
  String? checkInDate;
  String? checkOutDate;
  int? adult;
  int? children;
  int? rooms;
  int? userId;
  String? bookingName;
  String? bookingEmail;
  String? bookingPhone;
  String? bookingAddress;

  BookingRequest(
      {this.gateway,
        this.price,
        this.vendorId,
        this.hotelId,
        this.roomId,
        this.checkInTime,
        this.checkInDate,
        this.adult,
        this.children,
        this.bookingName,
        this.checkOutDate,
        this.bookingEmail,
        this.bookingPhone,
        this.bookingAddress,this.rooms,this.hours,this.userId,this.priceId});

  BookingRequest.fromJson(Map<String, dynamic> json) {
    gateway = json['gateway'];
    price = json['price'];
    vendorId = json['vendor_id'];
    hotelId = json['hotel_id'];
    priceId = json['price_id'];
    roomId = json['room_id'];
    userId = json['user_id'];
    checkInTime = json['checkInTime'];
    checkInDate = json['checkInDate'];
    checkOutDate = json['checkOutDate'];
    adult = json['adult'];
    children = json['children'];
    bookingName = json['booking_name'];
    bookingEmail = json['booking_email'];
    bookingPhone = json['booking_phone'];
    bookingAddress = json['booking_address'];
    hours = json['hours'];
    rooms = json['rooms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gateway'] = this.gateway;
    data['price'] = this.price;
    data['vendor_id'] = this.vendorId;
    data['hotel_id'] = this.hotelId;
    data['room_id'] = this.roomId;
    data['checkInTime'] = this.checkInTime;
    data['checkInDate'] = this.checkInDate;
    data['checkOutDate'] = this.checkOutDate;
    data['adult'] = this.adult;
    data['children'] = this.children;
    data['booking_name'] = this.bookingName;
    data['booking_email'] = this.bookingEmail;
    data['booking_phone'] = this.bookingPhone;
    data['booking_address'] = this.bookingAddress;
    data['hours'] = this.hours;
    data['rooms'] = this.rooms;
    data['user_id'] = this.userId;
    data['price_id'] = this.priceId;
    return data;
  }
}
