

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/model/common/common_response_model.dart';
import 'package:userapp/model/driver/driver_model.dart';
import 'package:userapp/model/order/delivery_fees_response.dart';
import 'package:userapp/model/service/add_service_request.dart';
import 'package:userapp/model/service/service_banner_model.dart';
import 'package:userapp/model/service/service_response_model.dart';
import 'package:userapp/navigation/page_navigation.dart';

import '../model/profile/profile_model.dart';
import '../model/service/service_category_model.dart';
import '../model/zone/zone_information_model.dart';
import '../network/api_service.dart';
import '../network/dio_client.dart';
import '../utils/loader.dart';
import '../utils/preference_utils.dart';
import '../utils/validation_utils.dart';
import 'dart:math' as math;

class ServiceController extends ControllerMVC{

  final GlobalKey<FormState> serviceKey = GlobalKey<FormState>();

  //Network Service
  ApiService apiService = ApiService();

  var addServiceRequest = AddServiceRequest();
  var serviceCategoryModel = ServiceCategoryModel();
  var serviceBannerModel = ServiceBannerModel();
  var serviceResponseModel = ServiceResponseModel();
  var deliverFeesModel = DeliveryFeesResponse();
  var driverModel = DriverModel();
  var commonModel = CommonResponseModel();
  var zoneInformationModel = ZoneInformationModel();
  var profileModel = ProfileModel();
  var isData = true;
  double serviceCharge = 0.0;
  ServiceCategory? selectedCategory;
  var fromLocation = "From Location";
  var fromNameController = TextEditingController();
  var fromPhoneController = TextEditingController();
  var toNameController = TextEditingController();
  var toPhoneController = TextEditingController();
  var orderId = "";

  getZoneInformation(BuildContext context){

    Loader.show();
    apiService.getZoneInformation().then((value){
      Loader.hide();
      if(value.success!){
        setState(() {
          zoneInformationModel = value;
        });
        notifyListeners();
      }else{
        //ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
    notifyListeners();
  }

  getServiceCategory(BuildContext context){
    Loader.show();
    apiService.getServiceCategory().then((value){
      Loader.hide();
      if(value.success!){
        setState(() {
          serviceCategoryModel = value;
          selectedCategory = serviceCategoryModel.data![0];
        });
        notifyListeners();
      }else{
       // ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }

  getServiceBanner(BuildContext context){
    Loader.show();
    apiService.getServiceBanner().then((value){
      Loader.hide();
      if(value.success!){
        setState(() {
          serviceBannerModel = value;
        });
        notifyListeners();
      }else{
        //ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }

  addService(BuildContext context, List<String> selectCategoryList, List<ServiceCategory> selectedCategoryIndices, String serviceInput, ServiceCategory? selectedCategory){
    print(addServiceRequest.fromname!);
    print(addServiceRequest.fphoneno!);
    print(addServiceRequest.fromtime!);
    print(addServiceRequest.fromlocation!);
    print(addServiceRequest.toname!);
    print(addServiceRequest.tophoneno!);
    print(addServiceRequest.tolocation!);
    print(addServiceRequest.description!);
    if(ValidationUtils.emptyValidation(addServiceRequest.fromname!)
    && ValidationUtils.emptyValidation(addServiceRequest.fphoneno!)
    && ValidationUtils.emptyValidation(addServiceRequest.fromtime!)
    && ValidationUtils.emptyValidation(addServiceRequest.fromlocation!)
    && ValidationUtils.emptyValidation(addServiceRequest.toname!)
    && ValidationUtils.emptyValidation(addServiceRequest.tophoneno!)
    && ValidationUtils.emptyValidation(addServiceRequest.tolocation!)
    && ValidationUtils.emptyValidation(addServiceRequest.description!)){
      PageNavigation.gotoServiceCheckoutPage(context,addServiceRequest,selectCategoryList,selectedCategoryIndices,serviceInput,selectedCategory);
    }else{
      ValidationUtils.showAppToast("All are fields required");
    }
  }

  Future<String?> getDistanceAndTime(String fLat,String fLong, String tLat, String tLong) async {
    String? distance = "";
    try {

      // Replace with your destination coordinates
      double toLatitude = double.parse(tLat); // Example: San Francisco
      double toLongitude = double.parse(tLong);
      double fromLatitude = double.parse(fLat);
      double fromLongitude = double.parse(fLong);

      double distanceInKm = _calculateDistance(fromLatitude, fromLongitude, toLatitude, toLongitude);
      double averageSpeedKmPerH = 50; // Average speed in km/h
       distance = '${distanceInKm.toStringAsFixed(2)}';
      print(distanceInKm);
      return distance;
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String?> getDistance2(String fLat,String fLong, String tLat, String tLong) async {
    String orgin = "${fLat},${fLong}";
    String destination = "${tLat},${tLong}";
    final url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$orgin&destinations=$destination&key=AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY';
    final dioClient = DioClient();
    final response = await dioClient.get(url);
    if (response.statusCode == 200) {
      print(json.decode(response.toString()));
      final data = json.decode(response.toString());
      final dis = data['rows'][0]['elements'][0]['distance']['text'];
      final dur = data['rows'][0]['elements'][0]['duration']['text'];
      return dis;
    } else {
      print('Error: ${response.statusCode}');
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


  checkOutService(BuildContext context,AddServiceRequest request) async {
    Loader.show();
    String? serviceId = await generateOrderId();
    request.serviceCode = serviceId;
    apiService.checkOutService(request).then((value){
      Loader.hide();
      if(value.success!){
        PageNavigation.gotoSuccessPage(context);
      }else{
       // ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }

  Future<String?> generateOrderId() async{
    String? orderId = "FSSER";
    String? fCode = await PreferenceUtils.getFCode();
    String? zoneId = await PreferenceUtils.getZoneId();
    orderId = "$orderId$fCode$zoneId";
    return orderId;
  }

  listService(BuildContext context){
    Loader.show();
    apiService.listService().then((value){
      Loader.hide();
      if(value.success!){
        setState(() {
          serviceResponseModel = value;
        });
        notifyListeners();
      }else{
       // ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
    notifyListeners();
  }

  listServiceById(BuildContext context,String id){
    Loader.show();
    apiService.listServiceById(id).then((value){
      Loader.hide();
      if(value.success!){
        setState(() {
          serviceResponseModel = value;
        });
        notifyListeners();
      }else{
      //  ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
    notifyListeners();
  }


  getDriverDetails(BuildContext context,String driverId){

    Loader.show();
    apiService.getDriverDetails(driverId).then((value){
      Loader.hide();
      if(value.success!){
        setState(() {
          driverModel = value;
        });
        notifyListeners();
      }else{
       // ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
    notifyListeners();
  }


  getServiceDeliveryFees(BuildContext context,String km, String? maincategory){
    Loader.show();
    apiService.getServiceCharge(km,maincategory).then((value){
      Loader.hide();
      if(value.success!){
        setState(() {
          deliverFeesModel = value;
          double tax = (int.parse(deliverFeesModel.data!.amount!) * int.parse(deliverFeesModel.data!.tax!))/100;
          serviceCharge = double.parse(deliverFeesModel.data!.amount!) + tax.round();
        });
        notifyListeners();
      }else{
        //ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
    notifyListeners();
  }


  getProfile(){
    Loader.show();
    apiService.getProfile().then((value) async {
      Loader.hide();
      if(value.success!){
        profileModel = value;
        PreferenceUtils.saveUserPhone(profileModel.data!.phone!);
        String? currentLocation = await PreferenceUtils.getLocation();
        String? latitude = await PreferenceUtils.getLatitude();
        String? longitude = await PreferenceUtils.getLongitude();
        String? zoneId = await PreferenceUtils.getZoneId();
        addServiceRequest.fromname = profileModel.data!.name!;
        addServiceRequest.fphoneno = profileModel.data!.phone!;
        fromLocation = currentLocation!;
        addServiceRequest.fromlocation = fromLocation;
        addServiceRequest.fLatitude = latitude;
        addServiceRequest.fLongitude =longitude;
        addServiceRequest.zoneId =zoneId;
        fromNameController.text = profileModel.data!.name!;
        fromPhoneController.text = profileModel.data!.phone!;
        notifyListeners();
      }else{
      //  ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }

  getToProfile(){
    Loader.show();
    apiService.getProfile().then((value) async {
      Loader.hide();
      if(value.success!){
        profileModel = value;
        PreferenceUtils.saveUserPhone(profileModel.data!.phone!);
        String? currentLocation = await PreferenceUtils.getLocation();
        String? latitude = await PreferenceUtils.getLatitude();
        String? longitude = await PreferenceUtils.getLongitude();
        String? zoneId = await PreferenceUtils.getZoneId();
        addServiceRequest.tolocation = currentLocation!;
        addServiceRequest.toname = profileModel.data!.name!;
        addServiceRequest.tophoneno = profileModel.data!.phone!;
        toNameController.text = profileModel.data!.name!;
        toPhoneController.text = profileModel.data!.phone!;
        notifyListeners();
      }else{
       // ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }


  Future<bool> createOrderId(BuildContext context, String amount) async {
    try {
      Loader.show();
      final value = await apiService.createOrderId(amount);
      Loader.hide();
      orderId = value.id!;
      notifyListeners();
      return true; // Return true when the order ID is successfully created
    } catch (e) {
      print(e);
      Loader.hide();
      return false; // Return false in case of an error
    }
  }


}