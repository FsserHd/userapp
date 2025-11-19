class HotelDetailsBookingResponse {
  bool? status;
  String? message;
  BookingDetailsData? data;

  HotelDetailsBookingResponse({this.status, this.message, this.data});

  HotelDetailsBookingResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new BookingDetailsData.fromJson(json['data']) : null;
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

class BookingDetailsData {
  Details? details;
  RoomContentInfo? roomContentInfo;
  HotelContentInfo? hotelContentInfo;
  List<OfflineGateways>? offlineGateways;

  BookingDetailsData(
      {this.details,
        this.roomContentInfo,
        this.hotelContentInfo,
        this.offlineGateways});

  BookingDetailsData.fromJson(Map<String, dynamic> json) {
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;

    roomContentInfo = json['roomContentInfo'] != null
        ? new RoomContentInfo.fromJson(json['roomContentInfo'])
        : null;
    hotelContentInfo = json['hotelContentInfo'] != null
        ? new HotelContentInfo.fromJson(json['hotelContentInfo'])
        : null;
    if (json['offlineGateways'] != null) {
      offlineGateways = <OfflineGateways>[];
      json['offlineGateways'].forEach((v) {
        offlineGateways!.add(new OfflineGateways.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }

    if (this.roomContentInfo != null) {
      data['roomContentInfo'] = this.roomContentInfo!.toJson();
    }
    if (this.hotelContentInfo != null) {
      data['hotelContentInfo'] = this.hotelContentInfo!.toJson();
    }

    if (this.offlineGateways != null) {
      data['offlineGateways'] =
          this.offlineGateways!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
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

  Details(
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
        this.updatedAt});

  Details.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class RoomContentInfo {
  int? id;
  int? languageId;
  int? roomId;
  int? roomCategory;
  String? title;
  String? slug;

  String? amenities;
  String? description;

  String? metaDescription;
  String? createdAt;
  String? updatedAt;

  RoomContentInfo(
      {this.id,
        this.languageId,
        this.roomId,
        this.roomCategory,
        this.title,
        this.slug,

        this.amenities,
        this.description,

        this.metaDescription,
        this.createdAt,
        this.updatedAt});

  RoomContentInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageId = json['language_id'];
    roomId = json['room_id'];
    roomCategory = json['room_category'];
    title = json['title'];
    slug = json['slug'];

    amenities = json['amenities'];
    description = json['description'];

    metaDescription = json['meta_description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['language_id'] = this.languageId;
    data['room_id'] = this.roomId;
    data['room_category'] = this.roomCategory;
    data['title'] = this.title;
    data['slug'] = this.slug;

    data['amenities'] = this.amenities;
    data['description'] = this.description;

    data['meta_description'] = this.metaDescription;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class HotelContentInfo {
  int? id;
  int? languageId;
  int? hotelId;
  int? categoryId;
  int? countryId;
  int? stateId;
  int? cityId;
  String? title;
  String? slug;
  String? address;
  String? amenities;
  String? description;

  String? createdAt;
  String? updatedAt;

  HotelContentInfo(
      {this.id,
        this.languageId,
        this.hotelId,
        this.categoryId,
        this.countryId,
        this.stateId,
        this.cityId,
        this.title,
        this.slug,
        this.address,
        this.amenities,
        this.description,

        this.createdAt,
        this.updatedAt});

  HotelContentInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageId = json['language_id'];
    hotelId = json['hotel_id'];
    categoryId = json['category_id'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    title = json['title'];
    slug = json['slug'];
    address = json['address'];
    amenities = json['amenities'];
    description = json['description'];

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['language_id'] = this.languageId;
    data['hotel_id'] = this.hotelId;
    data['category_id'] = this.categoryId;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['address'] = this.address;
    data['amenities'] = this.amenities;
    data['description'] = this.description;

    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class OfflineGateways {
  String? name;

  OfflineGateways({this.name});

  OfflineGateways.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
