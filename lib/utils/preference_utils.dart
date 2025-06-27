

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils{

  static saveUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", userId);
  }

  static saveLatitude(String latitude) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("latitude", latitude);
  }

  static saveLocation(String latitude) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("location", latitude);
  }


  static saveLongitude(String longitude) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("longitude", longitude);
  }

  static Future<String?> getLatitude() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("latitude");
  }

  static Future<String?> getLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("location");
  }

  static Future<String?> getLongitude() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("longitude");
  }


  static saveUserToken(String userToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token",userToken);
  }

  static saveAddressId(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("addressId",id);
  }

  static saveUserPhone(String phone) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("phone",phone);
  }

  static getUserPhone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("phone");
  }

  static saveShopId(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("shopId",id);
  }

  static getShopId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("shopId");
  }

  static getAddressId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("addressId");
  }

  static Future<String?> getUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }

  static saveZoneId(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("zoneId",id);
  }

  static Future<String?> getZoneId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("zoneId");
  }

  static saveFCode(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("fcode",id);
  }

  static Future<String?> getFCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("fcode");
  }

  static saveFocusId(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("focus_id",id);
  }

  static Future<String?> getFocusId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("focus_id");
  }

}