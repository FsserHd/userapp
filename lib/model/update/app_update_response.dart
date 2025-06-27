

class AppUpdateResponse {
  bool? success;
  bool? isAllow;
  bool? isMaintenance;
  bool? isForceUpdate;
  String? message;

  AppUpdateResponse(
      {this.success, this.isAllow, this.isForceUpdate, this.message,this.isMaintenance});

  AppUpdateResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    isAllow = json['is_allow'];
    isMaintenance = json['is_maintanence'];
    isForceUpdate = json['is_force_update'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['is_allow'] = this.isAllow;
    data['is_force_update'] = this.isForceUpdate;
    data['is_maintanence'] = this.isMaintenance;
    data['message'] = this.message;
    return data;
  }
}
