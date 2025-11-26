
class HotelBookingResponse {
  bool? status;
  String? message;
  List<HotelBookingData>? data;

  HotelBookingResponse({this.status, this.message, this.data});

  HotelBookingResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HotelBookingData>[];
      json['data'].forEach((v) {
        data!.add(new HotelBookingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HotelBookingData {
  int? id;
  String? orderNumber;
  int? userId;
  int? hotelId;
  int? roomId;
  int? vendorId;
  int? membershipId;
  int? adult;
  int? children;
  String? checkInDate;
  String? checkInTime;
  String? checkInDateTime;
  int? hour;
  String? checkOutDate;
  String? checkOutTime;
  int? preparationTime;
  String? nextBookingTime;
  String? checkOutDateTime;
  String? bookingName;

  String? bookingPhone;
  String? bookingAddress;

  String? serviceDetails;
  int? roomPrice;
  int? serviceCharge;
  String? total;
  String? rooms;
  String? nights;
  String? discount;
  String? tax;
  String? grandTotal;
  String? currencyText;
  String? currencyTextPosition;
  String? currencySymbol;
  String? currencySymbolPosition;
  String? paymentMethod;
  String? gatewayType;
  String? paymentStatus;
  String? invoice;
  String? createdAt;
  String? updatedAt;
  RoomInfos? roomInfos;
  int? isCancel;

  HotelBookingData(
      {this.id,
        this.orderNumber,
        this.userId,
        this.hotelId,
        this.roomId,
        this.vendorId,
        this.membershipId,
        this.adult,
        this.children,
        this.checkInDate,
        this.checkInTime,
        this.checkInDateTime,
        this.hour,
        this.checkOutDate,
        this.checkOutTime,
        this.preparationTime,
        this.nextBookingTime,
        this.checkOutDateTime,
        this.bookingName,

        this.bookingPhone,
        this.bookingAddress,

        this.serviceDetails,
        this.roomPrice,
        this.serviceCharge,
        this.total,
        this.discount,
        this.tax,
        this.grandTotal,
        this.currencyText,
        this.currencyTextPosition,
        this.currencySymbol,
        this.currencySymbolPosition,
        this.paymentMethod,
        this.gatewayType,
        this.paymentStatus,
        this.invoice,
        this.createdAt,
        this.updatedAt,
        this.roomInfos,this.rooms,this.nights,this.isCancel});

  HotelBookingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    userId = json['user_id'];
    hotelId = json['hotel_id'];
    roomId = json['room_id'];
    vendorId = json['vendor_id'];
    membershipId = json['membership_id'];
    adult = json['adult'];
    children = json['children'];
    checkInDate = json['check_in_date'];
    checkInTime = json['check_in_time'];
    checkInDateTime = json['check_in_date_time'];
    hour = json['hour'];
    checkOutDate = json['check_out_date'];
    checkOutTime = json['check_out_time'];
    preparationTime = json['preparation_time'];
    nextBookingTime = json['next_booking_time'];
    checkOutDateTime = json['check_out_date_time'];
    bookingName = json['booking_name'];

    bookingPhone = json['booking_phone'];
    bookingAddress = json['booking_address'];

    serviceDetails = json['service_details'];
    roomPrice = json['roomPrice'];
    serviceCharge = json['serviceCharge'];
    total = json['total'];
    discount = json['discount'];
    tax = json['tax'];
    rooms = json['rooms'];
    nights = json['nights'];
    grandTotal = json['grand_total'];
    currencyText = json['currency_text'];
    currencyTextPosition = json['currency_text_position'];
    currencySymbol = json['currency_symbol'];
    currencySymbolPosition = json['currency_symbol_position'];
    paymentMethod = json['payment_method'];
    gatewayType = json['gateway_type'];
    paymentStatus = json['payment_status'];
    invoice = json['invoice'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isCancel = json['is_cancel'];
    roomInfos = json['roomInfos'] != null
        ? new RoomInfos.fromJson(json['roomInfos'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_number'] = this.orderNumber;
    data['user_id'] = this.userId;
    data['hotel_id'] = this.hotelId;
    data['room_id'] = this.roomId;
    data['vendor_id'] = this.vendorId;
    data['membership_id'] = this.membershipId;
    data['adult'] = this.adult;
    data['children'] = this.children;
    data['check_in_date'] = this.checkInDate;
    data['check_in_time'] = this.checkInTime;
    data['check_in_date_time'] = this.checkInDateTime;
    data['hour'] = this.hour;
    data['check_out_date'] = this.checkOutDate;
    data['check_out_time'] = this.checkOutTime;
    data['preparation_time'] = this.preparationTime;
    data['next_booking_time'] = this.nextBookingTime;
    data['check_out_date_time'] = this.checkOutDateTime;
    data['booking_name'] = this.bookingName;

    data['booking_phone'] = this.bookingPhone;
    data['booking_address'] = this.bookingAddress;

    data['service_details'] = this.serviceDetails;
    data['roomPrice'] = this.roomPrice;
    data['serviceCharge'] = this.serviceCharge;
    data['total'] = this.total;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['grand_total'] = this.grandTotal;
    data['currency_text'] = this.currencyText;
    data['currency_text_position'] = this.currencyTextPosition;
    data['currency_symbol'] = this.currencySymbol;
    data['currency_symbol_position'] = this.currencySymbolPosition;
    data['payment_method'] = this.paymentMethod;
    data['gateway_type'] = this.gatewayType;
    data['payment_status'] = this.paymentStatus;
    data['invoice'] = this.invoice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.roomInfos != null) {
      data['roomInfos'] = this.roomInfos!.toJson();
    }
    return data;
  }
}

class RoomInfos {
  int? roomId;
  String? roomTitle;
  String? roomSlug;
  String? amenities;
  int? hotelId;
  int? stars;
  String? hotelImage;
  String? latitude;
  String? longitude;
  String? hotelName;
  String? hotelSlug;
  int? cityId;
  int? stateId;
  int? countryId;
  List<String>? images;

  RoomInfos(
      {this.roomId,
        this.roomTitle,
        this.roomSlug,
        this.amenities,
        this.hotelId,
        this.stars,
        this.hotelImage,
        this.latitude,
        this.longitude,
        this.hotelName,
        this.hotelSlug,
        this.cityId,
        this.stateId,
        this.countryId,
        this.images});

  RoomInfos.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    roomTitle = json['roomTitle'];
    roomSlug = json['roomSlug'];
    amenities = json['amenities'];
    hotelId = json['hotelId'];
    stars = json['stars'];
    hotelImage = json['hotelImage'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    hotelName = json['hotelName'];
    hotelSlug = json['hotelSlug'];
    cityId = json['city_id'];
    stateId = json['state_id'];
    countryId = json['country_id'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = this.roomId;
    data['roomTitle'] = this.roomTitle;
    data['roomSlug'] = this.roomSlug;
    data['amenities'] = this.amenities;
    data['hotelId'] = this.hotelId;
    data['stars'] = this.stars;
    data['hotelImage'] = this.hotelImage;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['hotelName'] = this.hotelName;
    data['hotelSlug'] = this.hotelSlug;
    data['city_id'] = this.cityId;
    data['state_id'] = this.stateId;
    data['country_id'] = this.countryId;
    data['images'] = this.images;
    return data;
  }
}
