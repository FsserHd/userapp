

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/model/hotel/booking_request.dart';
import 'package:userapp/model/hotel/hotel_booking_response.dart';
import 'package:userapp/model/hotel/hotel_details_booking_response.dart';
import 'package:userapp/model/hotel/hotel_response.dart';
import 'package:userapp/model/hotel/time_slot_response.dart';
import 'package:userapp/navigation/page_navigation.dart';

import '../model/hotel/hotel_details_response.dart';
import '../model/profile/profile_model.dart';
import '../model/zone/zone_information_model.dart';
import '../network/api_service.dart';
import '../network/dio_client.dart';
import '../utils/loader.dart';
import '../utils/preference_utils.dart';

class HotelController extends ControllerMVC{

  ApiService apiService = ApiService();

  List<Hotels> hotelList = [];
  List<Hotels> allHotelList = [];
  List<Rooms> roomList = [];
  List<HourlyPrices> timeSlots = [];
  String distance = "0.0";
  String duration = '';
  var nameController = TextEditingController();
  var mobileController = TextEditingController();
  var emailController = TextEditingController();
  var profileModel = ProfileModel();
  List<HotelBookingData> myBookingList = [];
  var  bookingDetailsData = BookingDetailsData();
  var orderId = "";

  getHotels(BuildContext context) async {
    Loader.show();
    await apiService.getHotels().then((value) async {
      Loader.hide();
      List<Future<void>> futures = []; // To keep track of async operations.
      String? latitude = await PreferenceUtils.getLatitude();
      String? longitude = await PreferenceUtils.getLongitude();
      String origin = "${latitude},${longitude}";
      for (var element in value.data!) {
        String destination = "${element.latitude},${element.longitude}";
        futures.add(getDistance(origin, destination, "AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY").then((value) {
          element.distance = distance;
          hotelList.add(element);
          allHotelList = hotelList;

        }));
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
    notifyListeners();
  }

  String selectedSort = "Low to High";
  double selectedMin = 0;
  double selectedMax = 5000;

  void clearPriceFilters(BuildContext context) {
    selectedSort = "Low to High";
    selectedMin = 0;
    selectedMax = 5000;
    notifyListeners();
    hotelList.clear();
    getHotels(context);
    Navigator.pop(context);
  }

  void applyPriceFilter(String sortOrder, double minPrice, double maxPrice) {
    // Sort logic
    hotelList.sort((a, b) {
      if (sortOrder == "Low to High") {
        return a.minPrice!.compareTo(b.minPrice!);
      } else {
        return b.minPrice!.compareTo(a.minPrice!);
      }
    });

    // Filter logic
    hotelList = hotelList
        .where((hotel) =>
    hotel.minPrice! >= minPrice && hotel.minPrice! <= maxPrice)
        .toList();

    notifyListeners();
  }

  List<int> selectedRatings = [];

  void applyRatingFilter() {
    if (selectedRatings.isEmpty) {
      hotelList = List.from(allHotelList);
    } else {
      hotelList = allHotelList
          .where((hotel) => selectedRatings.contains(hotel.stars))
          .toList();
    }

    notifyListeners();
  }

  void clearRatingFilter(BuildContext context) {
    selectedRatings.clear();
    hotelList = List.from(allHotelList);
    Navigator.pop(context);
    notifyListeners();
  }

  double selectedMinDistance = 0;
  double selectedMaxDistance = 100;

  void applyDistanceFilter(double minKm, double maxKm) {
    selectedMinDistance = minKm;
    selectedMaxDistance = maxKm;

    hotelList = allHotelList.where((hotel) {
      // Remove "km", extra spaces, convert to lowercase
      String raw = hotel.distance
          ?.toLowerCase()
          .replaceAll("km", "")
          .trim() ??
          "0";

      // Convert to double
      final distance = double.tryParse(raw) ?? 0;

      print("Parsed distance: $distance");

      return distance >= minKm && distance <= maxKm;
    }).toList();

    notifyListeners();
  }



  void clearDistanceFilter(BuildContext context) {
    selectedMinDistance = 0;
    selectedMaxDistance = 100;
    hotelList = List.from(allHotelList);
    notifyListeners();
    Navigator.pop(context);
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


  getHotelDetails(BuildContext context,String hotelId, BookingRequest bookingRequest) async {
    Loader.show();
    await apiService.getHotelDetails(hotelId,bookingRequest).then((value) async {
      Loader.hide();
      roomList = value.data!.rooms!;
    }).catchError((e){
      print(e);
      Loader.hide();
    });
    notifyListeners();
  }

  checkIn(BuildContext context,String roomId,String date,String time) async {
    Loader.show();
    await apiService.checkIn(roomId,date,time).then((value) async {
      Loader.hide();
      timeSlots = value.data!.hourlyPrices!;
    }).catchError((e){
      print(e);
      Loader.hide();
    });
    notifyListeners();
  }

  getProfile(){
    Loader.show();
    apiService.getProfile().then((value){
      Loader.hide();
      if(value.success!){
        setState(() {
          profileModel = value;
        });
        setState(() {
          mobileController.text = profileModel.data!.phone!;
          nameController.text = profileModel.data!.name!;
          emailController.text = profileModel.data!.email!;
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

  booking(BuildContext context, BookingRequest bookingRequest) async {
    bookingRequest.checkOutTime = "10:00 AM";
    print(bookingRequest.toJson());
    Loader.show();
    await apiService.hotelBooking(bookingRequest).then((value) async {
      Loader.hide();
      PageNavigation.gotoHotelSuccessPage(context);
    }).catchError((e){
      print(e);
      Loader.hide();
    });
    notifyListeners();
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

  myBooking(BuildContext context) async {
    Loader.show();
    await apiService.myBooking().then((value) async {
      Loader.hide();
      myBookingList = value.data!;
    }).catchError((e){
      print(e);
      Loader.hide();
    });
    notifyListeners();
  }

  DateTime? checkInn;
  DateTime? checkOut;
  int nights = 0;
  List<String>? amenitiesList;
  bool canCancel = true;

  myBookingDetails(BuildContext context,String roomId) async {
    Loader.show();
    await apiService.myBookingDetails(roomId).then((value) async {
      Loader.hide();
      bookingDetailsData = value.data!;
      checkInn = DateFormat("yyyy-MM-dd").parse(bookingDetailsData.details!.checkInDate!);
      checkOut = DateFormat("yyyy-MM-dd").parse(bookingDetailsData.details!.checkOutDate!);
      if (checkInn != null) {
        canCancel = isCancelAllowed(bookingDetailsData.details!.checkInDate!);
        setState(() {});
      }
      nights = checkOut!.difference(checkInn!).inDays;
      amenitiesList = List<String>.from(jsonDecode(bookingDetailsData.roomContentInfo!.amenities!));
    }).catchError((e){
      print(e);
      Loader.hide();
    });
    notifyListeners();
  }

  bool isCancelAllowed(String checkInDateString) {
    try {
      // Parse check-in date
      DateTime checkInDate = DateTime.parse(checkInDateString);

      // Add fixed check-in time (11:00 AM)
      DateTime checkInDateTime = DateTime(
        checkInDate.year,
        checkInDate.month,
        checkInDate.day,
        11, // 11 AM cutoff time
        0,
        0,
      );

      DateTime now = DateTime.now();

      return now.isBefore(checkInDateTime); // true → allowed
    } catch (e) {
      return true; // fallback
    }
  }

  var zoneInformationModel = ZoneInformationModel();

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

  cancelBooking(BuildContext context, String id) async {
    Loader.show();
    await apiService.cancelBooking(id).then((value) async {
      Loader.hide();
      PageNavigation.gotoHotelSuccessPage(context);
    }).catchError((e){
      print(e);
      Loader.hide();
    });
    notifyListeners();
  }



}