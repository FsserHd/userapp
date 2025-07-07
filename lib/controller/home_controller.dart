
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/model/category/grocery_category_model.dart';
import 'package:userapp/model/chat/chat_request.dart';
import 'package:userapp/model/chat/chat_response.dart';
import 'package:userapp/model/common/common_response_model.dart';
import 'package:userapp/model/database/cart_product_model.dart';
import 'package:userapp/model/driver/driver_model.dart';
import 'package:userapp/model/order/order_details_model.dart';
import 'package:userapp/model/order/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:userapp/model/product/product_model.dart';
import 'package:userapp/model/profile/profile_model.dart';
import 'package:userapp/model/search/search_model.dart';
import 'package:userapp/model/zone/zone_information_model.dart';
import 'package:userapp/model/zone/zone_response_model.dart';
import 'package:userapp/page/dashboard/dashboard_page.dart';
import 'package:userapp/utils/preference_utils.dart';
import 'package:userapp/utils/validation_utils.dart';
import '../constants/app_colors.dart';
import '../constants/app_style.dart';
import '../database/database_helper.dart';

import '../model/category/category_model.dart';

import '../model/home/home_model.dart';
import '../model/product/grocery_product_model.dart';
import '../model/vendor/vendor_model.dart';
import '../model/vendor/vendor_type_response.dart';
import '../navigation/page_navigation.dart';
import '../network/api_service.dart';
import '../network/dio_client.dart';
import '../utils/loader.dart';
import 'dart:math' as math;

class HomeController extends ControllerMVC{

  //Network Service
  ApiService apiService = ApiService();
  var homeModel = HomeModel();
  var orderModel = OrderModel();
  var orderDetailsModel = OrderDetailsModel();
  var driverModel = DriverModel();
  var zoneInformationModel = ZoneInformationModel();
  var vendorModel = VendorModel();
  var searchModel = SearchModel();
  var categoryModel = CategoryModel();
  var commonResponseModel = CommonResponseModel();
  var zoneResponseModel = ZoneResponseModel();
  var productModel = ProductModel();
  var profileModel = ProfileModel();
  var chatResponse = ChatResponse();
  List<VendorType> vendorTypeList = [];
  var chatRequest = ChatRequest();
  var groceryProductModel = GroceryProductModel();
  var groceryCategoryModel = GroceryCategoryModel();
  String distance = "0.0";
  String duration = '';
  var dbHelper = DatabaseHelper();
  var cartCount = 0;
  var totalPrice = 0.0;
  var isData = false;
  var isLoading = false;
  LatLng? vendorAddress;
  LatLng? shippingAddress;
  List<VendorData> vendorList = [];
  final Set<Polyline> polylines = {};

  filterVendor(String s,String action){
    vendorList.clear();
    if(action != "clear"){
      homeModel.data!.vendor!.forEach((e){
        if(s == e.vendortype){
          vendorList.add(e);
        }
      });
    }else{
      vendorList.addAll(homeModel.data!.vendor!);
    }
    notifyListeners();
  }

  getAllCount(){
    dbHelper.getCartCount().then((value){
      setState(() {
        cartCount = value!;
      });
    });
    notifyListeners();
  }

  updateFcmToken(BuildContext context,String token){
    apiService.updateFcmToken(token).then((value) {
      commonResponseModel = value;
      notifyListeners();
    }).catchError((e) {
     // ValidationUtils.showAppToast("Something went wrong.");
      print(e);
    });
  }

  Future<void> getTotalPrice() async {

    double total = 0.0;
    final db = await dbHelper.database;
    List<Map<String, dynamic>> singleDigitRows = await db.query('product');

    for (var row in singleDigitRows) {
      double? price = row['price'] != null ? double.tryParse(row['price'].toString()) : null;
      int? qty = row['qty'];

      if (price != null && qty != null) {
        total += price * qty;
      }
    }
    setState(() {
      totalPrice = total;
      print(totalPrice);
    });

    notifyListeners();
  }

  homeData(BuildContext context) async {
    Loader.show();
    String? zoneId = await PreferenceUtils.getZoneId();
    if(zoneId !="0") {
      apiService.homeData(zoneId!).then((value) async {
        Loader.hide();
        if (value.success!) {

            homeModel = value;
            PreferenceUtils.saveFCode(homeModel.data!.fCode!.fCode!);
            List<Future<void>> futures = []; // To keep track of async operations.
            String? latitude = await PreferenceUtils.getLatitude();
            String? longitude = await PreferenceUtils.getLongitude();
            String origin = "${latitude},${longitude}";
            // Use a for-loop instead of forEach
            for (var element in homeModel.data!.vendor!) {
              String destination = "${element.latitude},${element.longitude}";

              futures.add(getDistance(origin, destination, "AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY").then((value) {
                element.distance1 = distance;
                element.distance = distance;
                element.duration = duration;
                vendorList.add(element);
              }));
            }
            await Future.wait(futures); // Wait for all async operations to complete.
            // Sort vendors: First by live status, then by distance.
            vendorList.sort((a, b) {
              // Ensure live vendors come first
              if (a.livestatus == "true" && b.livestatus == "false") return -1;
              if (a.livestatus == "false" && b.livestatus == "true") return 1;

              // Function to extract numeric distance
              double extractDistance(String? distance) {
                if (distance == null) return double.infinity; // Place null values at the end
                return double.tryParse(distance.replaceAll(RegExp(r'[^0-9.]'), '')) ?? double.infinity;
              }

              double distanceA = extractDistance(a.distance1);
              double distanceB = extractDistance(b.distance1);

              // Sort in ascending order of distance
              return distanceA.compareTo(distanceB);
            });


            // vendorList.sort((a, b) {
            //     if (a.livestatus == "true" && b.livestatus == "false") {
            //       return -1;
            //     } else if (a.livestatus == "false" && b.livestatus == "true") {
            //       return 1;
            //     }
            //     return a.distance1!.compareTo(b.distance1!);
            // });
            await Future.wait(futures); // Wait for all async operations to complete.
          notifyListeners();
        } else {
         // ValidationUtils.showAppToast("Something wrong");
        }
      }).catchError((e) {
        print(e);
        Loader.hide();
      });
    }else{

    }
  }

  Future<void> getDistance(String origin, String destination, String apiKey) async {
    final url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$origin&destinations=$destination&key=$apiKey';
    final dioClient = DioClient();
    final response = await dioClient.get(url);
    if (response.statusCode == 200) {
      print(json.decode(response.toString()));
      final data = json.decode(response.toString());
      final dis = data['rows'][0]['elements'][0]['distance']['text'];
      final dur = data['rows'][0]['elements'][0]['duration']['text'];
      distance = dis;
      duration = dur;
      print('Distance: $distance');
      print('Duration: $duration');
      notifyListeners();
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> getDistance2(String latitude,String longitude) async {
    String? lat = await PreferenceUtils.getLatitude();
    String? longi = await PreferenceUtils.getLongitude();
    String orgin = "${lat},${longi}";
    String destination = "${latitude},${longitude}";
    final url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$orgin&destinations=$destination&key=AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY';
    final dioClient = DioClient();
    final response = await dioClient.get(url);
    if (response.statusCode == 200) {
      print(json.decode(response.toString()));
      final data = json.decode(response.toString());
      final dis = data['rows'][0]['elements'][0]['distance']['text'];
      final dur = data['rows'][0]['elements'][0]['duration']['text'];
      distance = dis;
      duration = dur;
      print('Distance: $distance');
      print('Duration: $duration');
      notifyListeners();
    } else {
      print('Error: ${response.statusCode}');
    }
  }


  Future<void> getDistanceAndTime(String vendorLat,String vendorLong) async {
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

      setState(() {
        distance = distanceInKm.toString();
        duration = '${(travelTimeH * 60).toStringAsFixed(2)} min';
        print("distance: $distance, duration: $duration");
      });
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

  getMyOrders(BuildContext context) async {
    Loader.show();
    await apiService.getMyOrder().then((value){
      isLoading = true;
      Loader.hide();
      if(value.success!){
           setState(() {
             orderModel = value;
           });
      }else{
        //ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
    notifyListeners();
  }

  Future<bool> getOrderDetails(BuildContext context,String saleCode) async {
    Loader.show();
    await apiService.getOrderDetails(saleCode).then((value) {
      isLoading = true;
      Loader.hide();
      if(value.success!){
        setState(()  {
          orderDetailsModel = value;
          vendorAddress = LatLng(orderDetailsModel.data!.addressShop!.latitude!, orderDetailsModel.data!.addressShop!.longitude!);
          shippingAddress = LatLng(orderDetailsModel.data!.addressUser!.latitude!, orderDetailsModel.data!.addressUser!.longitude!);
         // List<LatLng> curvedPolyline = _createArc(vendorAddress!, shippingAddress!);

          if(orderDetailsModel.data!.deliveryState == "on_picked" || orderDetailsModel.data!.deliveryState == "on_reached" || orderDetailsModel.data!.deliveryState == "on_finish"){
            getDriverDetails(context, orderDetailsModel.data!.deliveryAssigned!);
          }else{
            _getVendorToShippingRoute();
            // polylines.add(Polyline(
            //   polylineId: PolylineId('line1'),
            //   visible: true,
            //   points: [ vendorAddress!,  shippingAddress!],
            //   color: Colors.blue,
            //   width: 2,
            // ));
          }
        });
        return true;
      }else{
        //ValidationUtils.showAppToast("Something wrong");
        return true;
      }
    }).catchError((e){
      print(e);
      Loader.hide();
      return true;
    });
    notifyListeners();
    return true;
  }

  List<LatLng> _createArc(LatLng start, LatLng end, {double curvature = 0.2}) {
    List<LatLng> points = [];

    double lat1 = start.latitude * pi / 180;
    double lon1 = start.longitude * pi / 180;

    double lat2 = end.latitude * pi / 180;
    double lon2 = end.longitude * pi / 180;

    double d = 2 * asin(sqrt(pow(sin((lat1 - lat2) / 2), 2) +
        cos(lat1) * cos(lat2) * pow(sin((lon1 - lon2) / 2), 2)));

    double f = 1.0 / 20.0; // controls the number of points (more points = smoother curve)
    double a = sin((1.0 - curvature) * d) / sin(d);
    double b = sin(curvature * d) / sin(d);

    for (double t = 0; t <= 1.0; t += f) {
      double lat = a * lat1 + b * lat2;
      double lon = a * lon1 + b * lon2;

      points.add(LatLng(lat * 180 / pi, lon * 180 / pi));
      a = sin((1.0 - (curvature + t)) * d) / sin(d);
      b = sin((curvature + t) * d) / sin(d);
    }

    return points;
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
        //ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
    notifyListeners();
  }

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

  listVendorById(String id) async {
    Loader.show();
    String? zoneId = await PreferenceUtils.getZoneId();
    apiService.listVendorById(id,zoneId!).then((value) async {
      Loader.hide();
      if(value.success!){

          vendorModel = value;
          List<Future<void>> futures = []; // To keep track of async operations.
          String? latitude = await PreferenceUtils.getLatitude();
          String? longitude = await PreferenceUtils.getLongitude();
          String origin = "${latitude},${longitude}";
          // Use a for-loop instead of forEach
          for (var element in vendorModel.data!) {
            String destination = "${element.latitude},${element.longitude}";

            futures.add(getDistance(origin, destination, "AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY").then((value) {
              element.distance1 = distance;
              element.distance = distance;
              element.duration = duration;
              vendorList.add(element);
            }));
          }
          await Future.wait(futures); // Wait for all async operations to complete.
          // Sort vendors: First by live status, then by distance.
          vendorList.sort((a, b) {
            // Ensure live vendors come first
            if (a.livestatus == "true" && b.livestatus == "false") return -1;
            if (a.livestatus == "false" && b.livestatus == "true") return 1;

            // Function to extract numeric distance
            double extractDistance(String? distance) {
              if (distance == null) return double.infinity; // Place null values at the end
              return double.tryParse(distance.replaceAll(RegExp(r'[^0-9.]'), '')) ?? double.infinity;
            }

            double distanceA = extractDistance(a.distance1);
            double distanceB = extractDistance(b.distance1);

            // Sort in ascending order of distance
            return distanceA.compareTo(distanceB);
          });


          // vendorList.sort((a, b) {
          //     if (a.livestatus == "true" && b.livestatus == "false") {
          //       return -1;
          //     } else if (a.livestatus == "false" && b.livestatus == "true") {
          //       return 1;
          //     }
          //     return a.distance1!.compareTo(b.distance1!);
          // });
          await Future.wait(futures); // Wait for all async operations to complete.
        notifyListeners();
      }else{
        //ValidationUtils.showAppToast("");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }

  listVendorCategories(String vendorBean){
    Loader.show();
    apiService.listVendorCategories(vendorBean).then((value){
      Loader.hide();
      if(value.success!){
        setState(() {
          categoryModel = value;
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

  Future<Productdetails?> getProductQty(Productdetails productBean) async {
    final db = await dbHelper.database;
    List<Map<String, dynamic>> singleDigitRows = await db.query('product');
    for (var row in singleDigitRows) {
      print(row['id']);
      if (int.parse(productBean.id!) == row['id']) {
        productBean.qty = row['qty'];
        print(productBean.qty);
        break;
      }
    }
    return productBean;
  }

  Future<GroceryVariant?> getGroceryProductQty(GroceryVariant variant) async {
    final db = await dbHelper.database;
    List<Map<String, dynamic>> singleDigitRows = await db.query('product');
    for (var row in singleDigitRows) {
      print(row['id']);
      if (int.parse(variant.variantId!) == row['id']) {
        variant.qty = row['qty'];
        print(variant.qty);
        break;
      }else{
        variant.qty = 0;
      }
    }
    return variant;
  }

  listCategoryProduct(String vendorId,String categoryId) async {
    Loader.show();
    try {
      var value = await apiService.listCategoryProduct(vendorId, categoryId);
      Loader.hide();
      if (value.success! && value.data!=null) {
        setState(() {
          productModel = value;
        });
        await Future.wait(productModel.data!.map((product) async {
          await Future.wait(product.productdetails!.map((details) async {
            var updatedDetails = await getProductQty(details);
            setState(() {
              details.qty = updatedDetails!.qty;
            });
          }).toList());
        }).toList());
      } else {

      }
    } catch (e) {
      print(e);
      Loader.hide();
      //ValidationUtils.showAppToast("Something went wrong");
    }
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
                  if(Platform.isAndroid) {
                    PageNavigation.gotoAddressPage(context, "home").then((
                        value) {
                      PreferenceUtils.getZoneId().then((zoneId) {
                        print(zoneId);
                        if (zoneId != "0") {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          PageNavigation.gotoDashboard(context);
                        }
                      });
                    });
                  }else{
                    PageNavigation.gotoSelectedLocationPage(context);
                  }
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


  listGroceryCategory(String vendorId) async {
    Loader.show();
    try {
      var value = await apiService.listGroceryCategory(vendorId);
      Loader.hide();
      if (value.success!) {
        setState(() {
          groceryCategoryModel = value;
        });
      } else {
        //ValidationUtils.showAppToast("Something went wrong");
      }
    } catch (e) {
      print(e);
      Loader.hide();
      //ValidationUtils.showAppToast("Something went wrong");
    }
  }

  listGroceryCategoryProduct(String vendorId,String categoryId) async {
    Loader.show();
    try {
      var value = await apiService.listGroceryCategoryProduct(vendorId, categoryId);
      Loader.hide();
      if (value.success!) {
        setState(() {
          groceryProductModel = value;
        });
        await Future.wait(groceryProductModel.data!.map((product) async {
          await Future.wait(product.productdetails!.map((details) async {
            await Future.wait(details.variant!.map((variant) async{
              var updatedDetails = await getGroceryProductQty(variant);
              if(updatedDetails!.qty!=null) {
                setState(() {
                  variant.qty = updatedDetails!.qty;
                });
              }else{
                setState(() {
                  variant.qty = 0;
                });
              }
            }).toList());
          }).toList());
        }).toList());
      } else {
        //ValidationUtils.showAppToast("Something went wrong");
      }
    } catch (e) {
      print(e);
      Loader.hide();
      //ValidationUtils.showAppToast("Something went wrong");
    }
  }

  getProfile(BuildContext context){
    Loader.show();
    apiService.getProfile().then((value){
      Loader.hide();
      if(value.success!){
        profileModel = value;
        if(profileModel.data!.status == "failed"){
          _showModalBottomSheet(context);
        }
        PreferenceUtils.saveUserPhone(profileModel.data!.phone!);
        notifyListeners();
      }else{
       // ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return Container(
          height: 160,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  leading: Image.asset("assets/images/blockuser.png"),
                  title: Text('Sorry! you are not allowed place the orders',style: AppStyle.font14MediumBlack87.override(fontSize: 14),),
                ),
                SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    PageNavigation.openWhatsApp(profileModel.data!.fphone!, "");
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.themeColor, // Gray fill color
                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    ),
                    child: Center(
                      child:   Text("Support",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  addOrderChat(ChatRequest chatRequest){
    Loader.show();
    apiService.addOrderChat(chatRequest).then((value){
      Loader.hide();
      if(value.success!){
        listOrderChat(chatRequest.orderId!,chatRequest.type!,chatRequest.sender!);
      }else{
       /// ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }

  listOrderChat(String orderId, String type, String sender){
    Loader.show();
    apiService.listOrderChat(orderId,type,sender).then((value){
      Loader.hide();
      if(value.success!){
        setState(() {
          chatResponse = value;
        });
      }else{
        //ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }

  updateVendorRating(BuildContext context,String vendorId,String rating){

    apiService.updateVendorRating(vendorId,rating).then((value){

      if(value.success!){

      }else{
        //ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);

    });
  }

  Future<void> search(String keywords) async {
    try {
      vendorList.clear();
      Loader.show();

      final value2 = await apiService.search(keywords);
      Loader.hide();
      if (value2.success ?? false) {
        searchModel = value2;
        //await searchData(); // Assuming this function modifies data
        vendorList = searchModel.data!;
        notifyListeners();
      } else {
        vendorList.clear();
        ValidationUtils.showAppToast("No Shops found");
      }
    } catch (e) {
      Loader.hide();
      print(e);
      vendorList.clear();
    }
  }


  searchData(){
    searchModel.data!.forEach((element) async {
      String? latitude = await PreferenceUtils.getLatitude();
      String? longitude = await PreferenceUtils.getLongitude();
      String orgin = "${latitude},${longitude}";
      String designation = "${element.latitude},${element.longitude}";
      await getDistance(orgin, designation, "AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY").then((value) {
        element.distance1 = distance;
        element.distance = distance;
        element.duration = duration;
        vendorList.add(element);
      });
    });
  }

  listBannerVendor(String id) async {
    Loader.show();
    String? zoneId = await PreferenceUtils.getZoneId();
    apiService.listBannerVendor(id,zoneId!).then((value) async {
      Loader.hide();
      if(value.success!){

        vendorModel = value;
        List<Future<void>> futures = []; // To keep track of async operations.
        vendorModel.data!.forEach((element) async {
          String? latitude = await PreferenceUtils.getLatitude();
          String? longitude = await PreferenceUtils.getLongitude();
          String orgin = "${latitude},${longitude}";
          String designation = "${element.latitude},${element.longitude}";
          // getDistance(orgin, designation, "AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY");
          futures.add( getDistance(orgin, designation, "AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY").then((value) {
            element.distance1 = distance;
            element.distance = distance;
            element.duration = duration;
            vendorList.add(element);
          }));
        });
        await Future.wait(futures); // Wait for all async operations to complete.
        setState(() {
          vendorList.sort((a, b) {
            if (a.livestatus == "true" && b.livestatus == "false") {
              return -1;
            } else if (a.livestatus == "false" && b.livestatus == "true") {
              return 1;
            }
            return a.distance1!.compareTo(b.distance1!);
          });
        });
        notifyListeners();
      }else{
        //ValidationUtils.showAppToast("");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }

  List<LatLng> routePoints = [];
  Set<Polyline> polylines1 = {};

  Future<void> _getVendorToShippingRoute() async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${vendorAddress!.latitude},${vendorAddress!.longitude}&destination=${shippingAddress!.latitude},${shippingAddress!.longitude}&key=AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY';

    final response = await http.get(Uri.parse(url));
    print(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String encodedPolyline = data['routes'][0]['overview_polyline']['points'];
      setState(() {
        routePoints = _decodePolyline(encodedPolyline);
        polylines1.add(Polyline(
          polylineId: PolylineId("route"),
          points: routePoints,
          color: Colors.blue,
          width: 2,
        ));
      });
    } else {
      print("Error fetching route: ${response.body}");
    }
  }

  // Decode the encoded polyline into a list of LatLng points
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }

  listVendorTypes(){
    Loader.show();
    apiService.listVendorTypes().then((value){
      Loader.hide();
      if(value.success!){
        vendorTypeList = value.data!;
      }else{
        //ValidationUtils.showAppToast("Something wrong");
      }
      notifyListeners();
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }


}