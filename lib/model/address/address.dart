class Address {
  Null? id;
  String? addressSelect;
  double? latitude;
  double? longitude;
  Null? isDefault;
  String? username;
  String? phone;
  String? userId;

  Address(
      {this.id,
        this.addressSelect,
        this.latitude,
        this.longitude,
        this.isDefault,
        this.username,
        this.phone,
        this.userId});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressSelect = json['addressSelect'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isDefault = json['isDefault'];
    username = json['username'];
    phone = json['phone'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['addressSelect'] = this.addressSelect;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['isDefault'] = this.isDefault;
    data['username'] = this.username;
    data['phone'] = this.phone;
    data['userId'] = this.userId;
    return data;
  }
}
