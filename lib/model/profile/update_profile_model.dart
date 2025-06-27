
class UpdateProfileModel {
  String? name;
  String? mobile;
  String? email;
  String? dob;
  String? gender;

  UpdateProfileModel(
      {this.name, this.mobile, this.email, this.dob, this.gender});

  UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    dob = json['dob'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    return data;
  }
}
