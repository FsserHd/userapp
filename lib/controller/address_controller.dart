

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/controller/home_controller.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/model/address/adders_response_model.dart';
import 'package:userapp/model/address/address_model.dart';
import 'package:userapp/model/common/common_response_model.dart';
import 'package:userapp/navigation/page_navigation.dart';
import 'package:userapp/utils/preference_utils.dart';

import '../constants/app_colors.dart';
import '../constants/app_style.dart';
import '../constants/lang.dart';
import '../model/service/add_service_request.dart';
import '../model/zone/zone_response_model.dart';
import '../network/api_service.dart';
import '../utils/loader.dart';
import '../utils/validation_utils.dart';
import 'dart:math' as math;

class AddressController extends ControllerMVC{

  final GlobalKey<FormState> addressKey = GlobalKey<FormState>();
  //Network Service
  ApiService apiService = ApiService();
  AddressModel addressModel = AddressModel();
  AddressResponseModel addressResponseModel = AddressResponseModel();
  CommonResponseModel commonModel = CommonResponseModel();
  HomeController homeController = HomeController();
  var zoneResponseModel = ZoneResponseModel();
  var serviceZoneResponseModel = ZoneResponseModel();
  bool isServiceAvailable = true;
  var request = AddServiceRequest();

  addAddress(BuildContext context) async {
    print(addressModel.toJson());
    if(ValidationUtils.emptyValidation(addressModel.mobile!) &&
        ValidationUtils.emptyValidation(addressModel.name!) && ValidationUtils.emptyValidation(addressModel.addresstype!)) {
      addressModel.userId = await PreferenceUtils.getUserId();
      Loader.show();
      apiService.addAddress(addressModel).then((value) {
        Loader.hide();
        Navigator.pop(context);
        Navigator.pop(context);
      }).catchError((e) {
        Loader.hide();
        //ValidationUtils.showAppToast(S.of(context, "something_wrong"));
        print(e);
      });
    }else{
      ValidationUtils.showAppToast("All Fields are required.");
    }
  }

  editAddress(BuildContext context,String addressId) async {
    print(addressModel.toJson());
    if(ValidationUtils.emptyValidation(addressModel.mobile!) &&
        ValidationUtils.emptyValidation(addressModel.name!) && ValidationUtils.emptyValidation(addressModel.addresstype!)) {
      addressModel.userId = await PreferenceUtils.getUserId();
      Loader.show();
      apiService.editAddress(addressModel,addressId).then((value) {
        Loader.hide();
        Navigator.pop(context);
        Navigator.pop(context);
      }).catchError((e) {
        Loader.hide();
        //ValidationUtils.showAppToast(S.of(context, "something_wrong"));
        print(e);
      });
    }else{
      ValidationUtils.showAppToast("All Fields are required.");
    }
  }



  listAddress(BuildContext context){
    Loader.show();
    apiService.listAddress().then((value){
      Loader.hide();
      if(value.success!){
       setState(() {
         addressResponseModel = value;
       });
      }else{
        addressResponseModel  = AddressResponseModel();
      }
      notifyListeners();
    }).catchError((e){
      Loader.hide();
     // ValidationUtils.showAppToast(S.of(context, "something_wrong"));
      print(e);
    });
  }

  getDistanceAndTime(String vendorLat,String vendorLong, Data addressBean) async {
    String? distance = "";
    try {
      String? latitude = await PreferenceUtils.getLatitude();
      String? longitude = await PreferenceUtils.getLongitude();
      double fromLatitude = double.parse(latitude!);
      double fromLongitude = double.parse(longitude!);

      // Replace with your destination coordinates
      double toLatitude = double.parse(vendorLat); // Example: San Francisco
      double toLongitude = double.parse(vendorLong);

      double distanceInKm = _calculateDistance(fromLatitude, fromLongitude, toLatitude, toLongitude);
      double averageSpeedKmPerH = 50; // Average speed in km/h
      double travelTimeH = distanceInKm / averageSpeedKmPerH;
      addressBean.distance = '${distanceInKm.toStringAsFixed(2)} km';
      setState(() {  addressBean.distance;});
    } catch (e) {
      print('Error: $e');
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Radius of the Earth in km
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);
    double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
            math.cos(_degToRad(lat1)) * math.cos(_degToRad(lat2)) *
                math.sin(dLon / 2) * math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) {
    return deg * (math.pi / 180);
  }


  checkZone(BuildContext context,String latitude,String longitude, Data addressBean, String type){
    Loader.show();
    apiService.getZone(latitude,longitude).then((value){
      Loader.hide();
      if(value.success!){
        zoneResponseModel = value;
        if(zoneResponseModel.data == "no_matched"){
          ValidationUtils.showAppToast("Unfortunately, we do not provide service at that location at this time.");
        }else{
          PreferenceUtils.saveZoneId(zoneResponseModel.data!);
          PreferenceUtils.saveLocation(addressBean.address!);
          PreferenceUtils.saveLatitude(addressBean.latitude!);
          PreferenceUtils.saveLongitude(addressBean.longitude!);
          if(type=="home"){
          PageNavigation.gotoDashboard(context);
          }else{
            Navigator.pop(context,addressBean.address);
          }
        }
        notifyListeners();
      }else{
        //ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }

  serviceCheckZone(BuildContext context,String latitude,String longitude){
    Loader.show();
    apiService.getZone(latitude,longitude).then((value){
      Loader.hide();
      if(value.success!){
        serviceZoneResponseModel = value;
        if(serviceZoneResponseModel.data == "no_matched"){
          setState(() {
            isServiceAvailable = false;
          });
          ValidationUtils.showAppToast("Sorry current location service not available. Please change location");
        }else{
          setState(() {
            isServiceAvailable = true;
          });
        }
        notifyListeners();
      }else{
       // ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }

  deleteAddress(BuildContext context,String id){
    Loader.show();
    apiService.deleteAddress(id).then((value){
      Loader.hide();
        setState(() {
          commonModel = value;
        });
        listAddress(context);
      notifyListeners();
    }).catchError((e){
      Loader.hide();
     // ValidationUtils.showAppToast(S.of(context, "something_wrong"));
      print(e);
    });
  }

  getZone(BuildContext context,String latitude,String longitude, String currentLocation){
    Loader.show();
    apiService.getZone(latitude,longitude).then((value){
      Loader.hide();
      if(value.success!){
        zoneResponseModel = value;
        if(zoneResponseModel.data == "no_matched"){
          PreferenceUtils.saveZoneId('0');
          _showInvalidZoneBottomSheet(context,currentLocation);
        }else{
          PreferenceUtils.saveZoneId(zoneResponseModel.data!);
          PreferenceUtils.saveLocation(currentLocation);
          PreferenceUtils.saveLatitude(latitude);
          PreferenceUtils.saveLongitude(longitude);
          PreferenceUtils.saveZoneId(zoneResponseModel.data!);
          PageNavigation.gotoDashboard(context);
        }
        notifyListeners();
      }else{
        // ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }
  void _showInvalidZoneBottomSheet(BuildContext context, String currentLocation) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 240,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Address',
                style: AppStyle.font14MediumBlack87..override(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                currentLocation!,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Current not delivery this location',
                  style: AppStyle.font14MediumBlack87..override(fontSize: 14,color: Colors.red),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: (){
                  // _con.createOrder(context);

                  PageNavigation.gotoAddressPage(context,"home").then((value){
                    PreferenceUtils.getZoneId().then((zoneId) {
                      print(zoneId);
                      if(zoneId!="0") {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        PageNavigation.gotoDashboard(context);
                      }
                    });
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.themeColor, // Gray fill color
                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  ),
                  child: Center(
                    child:   Text("Change Location",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}