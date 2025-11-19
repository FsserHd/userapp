class HotelDetailsResponse {
  bool? status;
  String? message;
  Data? data;

  HotelDetailsResponse({this.status, this.message, this.data});

  HotelDetailsResponse.fromJson(Map<String, dynamic> json) {
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
  List<HotelImages>? hotelImages;
  List<Null>? hotelCounters;
  List<Null>? reviews;
  int? numOfReview;
  List<Rooms>? rooms;
  int? totalRooms;

  Data(
      {this.hotelImages,
        this.hotelCounters,
        this.reviews,
        this.numOfReview,
        this.rooms,
        this.totalRooms});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['hotelImages'] != null) {
      hotelImages = <HotelImages>[];
      json['hotelImages'].forEach((v) {
        hotelImages!.add(new HotelImages.fromJson(v));
      });
    }
    numOfReview = json['numOfReview'];
    if (json['rooms'] != null) {
      rooms = <Rooms>[];
      json['rooms'].forEach((v) {
        rooms!.add(new Rooms.fromJson(v));
      });
    }
    totalRooms = json['totalRooms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hotelImages != null) {
      data['hotelImages'] = this.hotelImages!.map((v) => v.toJson()).toList();
    }
    data['numOfReview'] = this.numOfReview;
    if (this.rooms != null) {
      data['rooms'] = this.rooms!.map((v) => v.toJson()).toList();
    }
    data['totalRooms'] = this.totalRooms;
    return data;
  }
}

class HotelImages {
  int? id;
  int? hotelId;
  String? image;
  String? createdAt;
  String? updatedAt;

  HotelImages(
      {this.id, this.hotelId, this.image, this.createdAt, this.updatedAt});

  HotelImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hotelId = json['hotel_id'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hotel_id'] = this.hotelId;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Rooms {
  int? roomId;
  int? id;
  int? hotelId;
  int? vendorId;
  String? featureImage;
  int? averageRating;
  Null? latitude;
  Null? longitude;
  int? status;
  int? bed;
  String? minPrice;
  String? maxPrice;
  int? adult;
  int? children;
  int? bathroom;
  int? numberOfRoomsOfThisSameType;
  int? preparationTime;
  int? area;
  String? prices;
  Null? additionalService;
  String? createdAt;
  String? updatedAt;
  String? roomTitle;
  String? roomSlug;
  String? amenities;
  int? stars;
  String? hotelImage;
  String? hotelName;
  String? hotelSlug;
  int? cityId;
  int? stateId;
  int? countryId;
  int? nights = 0;
  List<String>? images;
  List<HotelHourlyPrices>? hourlyPrices;

  Rooms(
      {this.roomId,
        this.id,
        this.hotelId,
        this.vendorId,
        this.featureImage,
        this.averageRating,
        this.latitude,
        this.longitude,
        this.status,
        this.bed,
        this.minPrice,
        this.maxPrice,
        this.adult,
        this.children,
        this.bathroom,
        this.numberOfRoomsOfThisSameType,
        this.preparationTime,
        this.area,
        this.prices,
        this.additionalService,
        this.createdAt,
        this.updatedAt,
        this.roomTitle,
        this.roomSlug,
        this.amenities,
        this.stars,
        this.hotelImage,
        this.hotelName,
        this.hotelSlug,
        this.cityId,
        this.stateId,
        this.countryId,
        this.images,
        this.hourlyPrices});

  Rooms.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    id = json['id'];
    hotelId = json['hotel_id'];
    vendorId = json['vendor_id'];
    featureImage = json['feature_image'];
    averageRating = json['average_rating'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    bed = json['bed'];
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
    adult = json['adult'];
    children = json['children'];
    bathroom = json['bathroom'];
    numberOfRoomsOfThisSameType = json['number_of_rooms_of_this_same_type'];
    preparationTime = json['preparation_time'];
    area = json['area'];
    prices = json['prices'];
    additionalService = json['additional_service'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    roomTitle = json['roomTitle'];
    roomSlug = json['roomSlug'];
    amenities = json['amenities'];
    hotelId = json['hotelId'];
    stars = json['stars'];
    hotelImage = json['hotelImage'];
    hotelName = json['hotelName'];
    hotelSlug = json['hotelSlug'];
    cityId = json['city_id'];
    stateId = json['state_id'];
    countryId = json['country_id'];
    images = json['images'].cast<String>();
    if (json['hourlyPrices'] != null) {
      hourlyPrices = <HotelHourlyPrices>[];
      json['hourlyPrices'].forEach((v) {
        hourlyPrices!.add(new HotelHourlyPrices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = this.roomId;
    data['id'] = this.id;
    data['hotel_id'] = this.hotelId;
    data['vendor_id'] = this.vendorId;
    data['feature_image'] = this.featureImage;
    data['average_rating'] = this.averageRating;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['bed'] = this.bed;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['adult'] = this.adult;
    data['children'] = this.children;
    data['bathroom'] = this.bathroom;
    data['number_of_rooms_of_this_same_type'] =
        this.numberOfRoomsOfThisSameType;
    data['preparation_time'] = this.preparationTime;
    data['area'] = this.area;
    data['prices'] = this.prices;
    data['additional_service'] = this.additionalService;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['roomTitle'] = this.roomTitle;
    data['roomSlug'] = this.roomSlug;
    data['amenities'] = this.amenities;
    data['hotelId'] = this.hotelId;
    data['stars'] = this.stars;
    data['hotelImage'] = this.hotelImage;
    data['hotelName'] = this.hotelName;
    data['hotelSlug'] = this.hotelSlug;
    data['city_id'] = this.cityId;
    data['state_id'] = this.stateId;
    data['country_id'] = this.countryId;
    data['images'] = this.images;
    if (this.hourlyPrices != null) {
      data['hourlyPrices'] = this.hourlyPrices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HotelHourlyPrices {
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
  String? date;
  bool? availability;

  HotelHourlyPrices(
      {this.id,
        this.vendorId,
        this.hotelId,
        this.roomId,
        this.hourId,
        this.hour,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.serialNumber,
        this.date,
        this.availability});

  HotelHourlyPrices.fromJson(Map<String, dynamic> json) {
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
    date = json['date'];
    availability = json['availability'];
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
    data['date'] = this.date;
    data['availability'] = this.availability;
    return data;
  }
}
