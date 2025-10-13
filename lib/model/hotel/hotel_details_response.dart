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
  int? numOfReview;
  List<Rooms>? rooms;
  List<TotalRooms>? totalRooms;

  Data(
      {this.hotelImages,
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
    if (json['totalRooms'] != null) {
      totalRooms = <TotalRooms>[];
      json['totalRooms'].forEach((v) {
        totalRooms!.add(new TotalRooms.fromJson(v));
      });
    }
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
    if (this.totalRooms != null) {
      data['totalRooms'] = this.totalRooms!.map((v) => v.toJson()).toList();
    }
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
  List<String>? images;

  Rooms(
      {this.roomId,
        this.id,
        this.hotelId,
        this.vendorId,
        this.featureImage,
        this.averageRating,
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
        this.images});

  Rooms.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    id = json['id'];
    hotelId = json['hotel_id'];
    vendorId = json['vendor_id'];
    featureImage = json['feature_image'];
    averageRating = json['average_rating'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = this.roomId;
    data['id'] = this.id;
    data['hotel_id'] = this.hotelId;
    data['vendor_id'] = this.vendorId;
    data['feature_image'] = this.featureImage;
    data['average_rating'] = this.averageRating;
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
    return data;
  }
}

class TotalRooms {
  int? id;

  TotalRooms({this.id});

  TotalRooms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
