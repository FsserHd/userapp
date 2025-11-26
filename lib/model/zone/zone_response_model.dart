class ZoneResponseModel {
  bool? success;
  String? data;
  List<ZoneData>? zonedata;

  ZoneResponseModel({this.success, this.data, this.zonedata});

  ZoneResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'];
    if (json['zonedata'] != null) {
      zonedata = <ZoneData>[];
      json['zonedata'].forEach((v) {
        zonedata!.add(new ZoneData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data;
    if (this.zonedata != null) {
      data['zonedata'] = this.zonedata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ZoneData {
  String? id;
  String? name;

  ZoneData({this.id, this.name});

  ZoneData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
