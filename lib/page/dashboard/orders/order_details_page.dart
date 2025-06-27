

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/constants/api_constants.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/model/order/order_model.dart';
import 'package:userapp/navigation/page_navigation.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_style.dart';
import '../../../controller/home_controller.dart';
import 'package:http/http.dart' as http;

class OrderDetailsPage extends StatefulWidget {

  String saleCode;

  OrderDetailsPage(this.saleCode, {super.key});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends StateMVC<OrderDetailsPage> {

  late HomeController _con;

  _OrderDetailsPageState() : super(HomeController()) {
    _con = controller as HomeController;
  }

  late GoogleMapController mapController;

  late LatLng _driverAddress;
  String _address = '';
  BitmapDescriptor? _customStoreMarkerIcon;
  BitmapDescriptor? _customCustomerMarkerIcon;
  BitmapDescriptor? _customDriverMarkerIcon;
  double itemTotal = 0.0;
  double grantTotal = 0.0;
  double tax = 0.0;
  double _rating = 0.0;

  LatLng? vendorAddress = LatLng(10.0735, 78.7732);
  LatLng? dropAddress = LatLng(10.094202, 78.771626);


  final _placesApiKey = 'AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY'; // Replace with your API key
  final _geocoding = GoogleMapsGeocoding(apiKey: 'AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY'); // Replace with your API key

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _loadStoreMarkerIcon() async {
    final customMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(80, 80)), // Adjust size as needed
      'assets/images/store_small.png',
    );
    setState(() {
      _customStoreMarkerIcon = customMarker;
    });
  }

  Future<void> _loadCustomerMarkerIcon() async {
    final customMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(80, 80)), // Adjust size as needed
      'assets/images/home.png',
    );
    setState(() {
      _customCustomerMarkerIcon = customMarker;
    });
  }

  Future<void> _loadDriverMarkerIcon() async {
    final customMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(100, 100)), // Adjust size as needed
      'assets/images/delivery-bike.png',
    );
    setState(() {
      _customDriverMarkerIcon = customMarker;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadStoreMarkerIcon();
    _loadCustomerMarkerIcon();
    //_getCurrentLocation();
    _listenToDriverLocation();
    //getTotalCalculation();
    _con.getOrderDetails(context, widget.saleCode).then((value){
      _listenToDriverLocation();
    });
    _con.getZoneInformation(context);

  }



  Map<String, dynamic>? _documentData;

  void _listenToDriverLocation() {
    FirebaseFirestore.instance
        .collection('driverTrack')
        .doc(widget.saleCode)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          _documentData = documentSnapshot.data() as Map<String, dynamic>;
          print(_documentData!['latitude']);
          if(_documentData!['latitude'] !=0) {
            _driverAddress = LatLng(double.parse(_documentData!['latitude'].toString()),
                double.parse(_documentData!['longitude'].toString()));
            _loadDriverMarkerIcon();
            _getRoute();
         /*   _con.polylines.add(Polyline(
              polylineId: PolylineId('line1'),
              visible: true,
              points: [ vendorAddress!,_driverAddress ],
              color: Colors.blue,
              width: 2,
            ));*/
          }
        });
      } else {
        print('Document does not exist');
      }
    }, onError: (e) {
      print('Error fetching document: $e');
    });
  }


  // Fetch route data from Google Directions API
  Future<void> _getRoute() async {
    if(_con.orderDetailsModel.data!.deliveryState == "on_picked" || _con.orderDetailsModel.data!.deliveryState == "on_reached" || _con.orderDetailsModel.data!.deliveryState == "on_finish") {
      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${_driverAddress
          .latitude},${_driverAddress.longitude}&destination=${_con
          .shippingAddress!.latitude},${_con.shippingAddress!
          .longitude}&key=$_placesApiKey';

      final response = await http.get(Uri.parse(url));
      print(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String encodedPolyline = data['routes'][0]['overview_polyline']['points'];
        setState(() {
          _con.routePoints = _decodePolyline(encodedPolyline);
          _con.polylines1.add(Polyline(
            polylineId: PolylineId("route"),
            points: _con.routePoints,
            color: Colors.blue,
            width: 2,
          ));
        });
      } else {
        print("Error fetching route: ${response.body}");
      }
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dashboardBgColor,
      appBar:  AppBar(
        backgroundColor: AppColors.themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("#${widget.saleCode}",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              String orderId = "Order ID:"+widget.saleCode +"\n\n"+"Hello 4square";
              PageNavigation.openWhatsApp(_con.zoneInformationModel.data![0].phone!,orderId);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/images/whatsapp.png",height: 35,width: 35,),
            ),
          ),
        ],
      ),
      body: _con.orderDetailsModel.data!=null ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _con.orderDetailsModel.data!.deliveryState =="on_cancel" && _con.orderDetailsModel.data!.status=="Cancelled" ?
                Container():
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
                border: Border.all(
                  color: Colors.grey.shade300, // Light gray border color
                  width: 2.0, // Border width
                ),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.themeColor, // Background color
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0)), // Rounded corners
                      border: Border.all(
                        color: AppColors.themeColor, // Light gray border color
                        width: 2.0, // Border width
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center, // To align the texts to the start
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text(
                          //   "Order is ${_con.orderDetailsModel.data!.status!.toLowerCase()}",
                          //   maxLines: 1,overflow: TextOverflow.ellipsis,
                          //   style: AppStyle.font18BoldWhite.override(fontSize: 16,color: Colors.white),
                          // ),
                          SizedBox(height: 2),
                          _con.orderDetailsModel.data!.deliveryState=="on_track" ?Text(
                            "your order is preparing",
                            style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.white),
                          ): _con.orderDetailsModel.data!.deliveryState=="on_going" ?Text(
                           "your order is preparing",
                           style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.white),
                         ): _con.orderDetailsModel.data!.deliveryState=="on_picked" ? Text(
                           "your order is on the way",
                           style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.white),
                         ):_con.orderDetailsModel.data!.deliveryState=="on_reached" ? Text(
                            "your order is reached at door step",
                            style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.white),
                          ):_con.orderDetailsModel.data!.deliveryState=="on_finish" ? Text(
                            "your order is delivered",
                            style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.white),
                          ):_con.orderDetailsModel.data!.deliveryState=="on_ready" ? Text(
                            "your order is preparing",
                            style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.white),
                          ):_con.orderDetailsModel.data!.deliveryState== null ? Text(
                            "your order is preparing",
                            style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.white),
                          ):Container()
                        ],
                      ),
                    ),
                    width: double.infinity,
                  ),

                  Container(
                    height: 250,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      zoomGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                      polylines: _con.polylines1,
                      initialCameraPosition: CameraPosition(
                        target: _con.vendorAddress!,
                        zoom: 14.0,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId(_con.orderDetailsModel.data!.addressShop!.username!),
                          position: _con.vendorAddress!,
                          icon: _customStoreMarkerIcon!,
                        ),
                        Marker(
                          markerId: MarkerId(_con.orderDetailsModel.data!.addressUser!.addressSelect!),
                          position: _con.shippingAddress!,
                          icon: _customCustomerMarkerIcon!,
                        ),
                        if (_documentData != null && _documentData!['latitude'] != 0)
                          Marker(
                            markerId: MarkerId("driver"),
                            position: _driverAddress,
                            icon: _customDriverMarkerIcon!,
                          )
                      },
                      myLocationEnabled: true, // Enables the "my location" layer which shows the user's location
                      myLocationButtonEnabled: true, // Adds a button to move the camera to the user's location
                    ),
                  )

                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color
                        borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        border: Border.all(
                          color: Colors.grey.shade300, // Light gray border color
                          width: 2.0, // Border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                                        child: Image.network(_con.orderDetailsModel.data!.addressShop!.logo!,height: 50,width: 50,fit: BoxFit.fill,)),
                                    SizedBox(width: 10),
                                    Container(
                                      width: 180,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // To center the texts vertically
                                        crossAxisAlignment: CrossAxisAlignment.start, // To align the texts to the start
                                        children: [
                                          Text(
                                            _con.orderDetailsModel.data!.addressShop!.username!,
                                            maxLines: 2,overflow: TextOverflow.ellipsis,
                                            style: AppStyle.font18BoldWhite.override(fontSize: 14),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            _con.orderDetailsModel.data!.addressShop!.company!,
                                            maxLines: 1,overflow: TextOverflow.ellipsis,
                                            style: AppStyle.font14MediumBlack87.override(fontSize: 12),
                                          ),
                                          SizedBox(height: 2,),
                                          Row(
                                            children: [
                                              Text(
                                                "Rate",
                                                style: AppStyle.font14MediumBlack87.override(fontSize: 12),
                                              ),
                                              SizedBox(width: 5,),
                                              Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: RatingBar.builder(
                                                  initialRating: _rating,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: 18.0,
                                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                  itemBuilder: (context, _) => Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (rating) {
                                                    setState(() {
                                                      _rating = rating;
                                                      _con.updateVendorRating(context, _con.orderDetailsModel.data!.addressShop!.id!, _rating.toString());
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          PageNavigation.gotoDialPage(context, _con.orderDetailsModel.data!.addressShop!.phone!);
                                        },
                                        child: Column(
                                          children: [
                                            Icon(Icons.call,color: AppColors.themeColor,size: 16,),
                                            Text(
                                              "Call",
                                              style: AppStyle.font14MediumBlack87.override(fontSize: 10,color: AppColors.themeColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      InkWell(
                                        onTap: (){
                                          PageNavigation.gotoChatPage(context,widget.saleCode,"vendor","user");
                                        },
                                        child: Column(
                                          children: [
                                            Icon(Icons.chat_bubble_outline,color: AppColors.themeColor,size: 16,),
                                            Text(
                                              "Chat",
                                              style: AppStyle.font14MediumBlack87.override(fontSize: 10,color: AppColors.themeColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Image.asset("assets/images/address.png",height: 50,width: 50,),
                                SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // To center the texts vertically
                                  crossAxisAlignment: CrossAxisAlignment.start, // To align the texts to the start
                                  children: [
                                    Container(
                                      child: Text(
                                        _con.orderDetailsModel.data!.addressShop!.addressSelect!,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyle.font18BoldWhite.override(fontSize: 12),
                                      ),
                                      width: 250,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    _con.driverModel.data!=null ? Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color
                        borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        border: Border.all(
                          color: Colors.grey.shade300, // Light gray border color
                          width: 2.0, // Border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    // ClipRRect(
                                    //     child: Image.network(_con.driverModel.data!.image!,height: 50,width: 50,),borderRadius: BorderRadius.circular(10.0),),
                                    // SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // To center the texts vertically
                                      crossAxisAlignment: CrossAxisAlignment.start, // To align the texts to the start
                                      children: [
                                        Text(
                                          _con.driverModel.data!.name!,
                                          maxLines: 1,overflow: TextOverflow.ellipsis,
                                          style: AppStyle.font18BoldWhite.override(fontSize: 16),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          _con.driverModel.data!.phone!,
                                          style: AppStyle.font14MediumBlack87.override(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          PageNavigation.gotoDialPage(context, _con.driverModel.data!.phone!);
                                        },
                                        child: Column(
                                          children: [
                                            Icon(Icons.call,color: AppColors.themeColor,size: 16,),
                                            Text(
                                              "Call",
                                              style: AppStyle.font14MediumBlack87.override(fontSize: 10,color: AppColors.themeColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      InkWell(
                                        onTap: (){
                                          PageNavigation.gotoChatPage(context,widget.saleCode,"driver","user");
                                        },
                                        child: Column(
                                          children: [
                                            Icon(Icons.chat_bubble_outline,color: AppColors.themeColor,size: 16,),
                                            Text(
                                              "Chat",
                                              style: AppStyle.font14MediumBlack87.override(fontSize: 10,color: AppColors.themeColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ):Container(),
                    SizedBox(height: 10,),
                    Text("Menu Details",style: TextStyle(color: Colors.black,fontFamily: AppStyle.robotoBold,fontSize: 16),),
                    SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color
                        borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        border: Border.all(
                          color: Colors.grey.shade300, // Light gray border color
                          width: 2.0, // Border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            itemCount: _con.orderDetailsModel.data!.productDetails!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context,pIndex){
                              var productBean =_con.orderDetailsModel.data!.productDetails![pIndex];
                              return Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset("assets/images/non_veg.png",height: 12,width: 12,),
                                        SizedBox(width: 5,),
                                        Row(
                                          children: [
                                            Text(productBean.qty.toString()+"x",style  : AppStyle.font14MediumBlack87.override(fontSize: 13,color: Colors.grey),),
                                            SizedBox(width: 2,),
                                            Text(productBean.productName!,style  : AppStyle.font14MediumBlack87.override(fontSize: 13),),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      ApiConstants.currency+productBean.price!,
                                      style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),
                    _con.orderDetailsModel.data!.addOnDetails!.isNotEmpty ?  SizedBox(height: 10,):Container(),
                    _con.orderDetailsModel.data!.addOnDetails!.isNotEmpty ? Text("Add On Details",style: TextStyle(color: Colors.black,fontFamily: AppStyle.robotoBold,fontSize: 16),):Container(),
                    _con.orderDetailsModel.data!.addOnDetails!.isNotEmpty ?   SizedBox(height: 10,):Container(),
                    _con.orderDetailsModel.data!.addOnDetails!.isNotEmpty ? Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color
                        borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        border: Border.all(
                          color: Colors.grey.shade300, // Light gray border color
                          width: 2.0, // Border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            itemCount: _con.orderDetailsModel.data!.addOnDetails!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context,pIndex){
                              var productBean =_con.orderDetailsModel.data!.addOnDetails![pIndex];
                              return Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset("assets/images/non_veg.png",height: 12,width: 12,),
                                        SizedBox(width: 5,),
                                        Row(
                                          children: [
                                            Text(productBean.qty.toString()+"x",style  : AppStyle.font14MediumBlack87.override(fontSize: 13,color: Colors.grey),),
                                            SizedBox(width: 2,),
                                            Text(productBean.name!,style  : AppStyle.font14MediumBlack87.override(fontSize: 13),),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      ApiConstants.currency+productBean.price!,
                                      style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ):Container(),
                    SizedBox(height: 10,),
                    Text("Bill Details",style: TextStyle(color: Colors.black,fontFamily: AppStyle.robotoBold,fontSize: 16),),
                    SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color
                        borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        border: Border.all(
                          color: Colors.grey.shade300, // Light gray border color
                          width: 2.0, // Border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Item Total",
                                  style: AppStyle.font18BoldWhite.override(fontSize: 16),
                                ),
                                Text(
                                  ApiConstants.currency+(_con.orderDetailsModel.data!.payment!.subTotal! + (_con.orderDetailsModel.data!.addOnDetails?.fold(0, (sum, item) => sum! + (int.parse(item.price!) * item.qty!)) ?? 0)).toString(),
                                  style: AppStyle.font14MediumBlack87.override(fontSize: 16),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Tax",
                                  style: AppStyle.font18BoldWhite.override(fontSize: 14,color: Colors.black),
                                ),
                                Text(
                                  ApiConstants.currency+_con.orderDetailsModel.data!.payment!.tax!.round().toString(),
                                  style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.black),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Delivery Fees",
                                  style: AppStyle.font18BoldWhite.override(fontSize: 14,color: Colors.black),
                                ),
                                Text(
                                  ApiConstants.currency+_con.orderDetailsModel.data!.payment!.deliveryFees!.round().toString(),
                                  style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.black),
                                ),
                              ],
                            ),
                            _con.orderDetailsModel.data!.payment!.discount!=0 ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Discount",
                                  style: AppStyle.font18BoldWhite.override(fontSize: 14,color: Colors.green),
                                ),
                                Text(
                                  ApiConstants.currency+_con.orderDetailsModel.data!.payment!.discount!.round().toString(),
                                  style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.green),
                                ),
                              ],
                            ):Container(),
                            _con.orderDetailsModel.data!.payment!.vendorDiscount!=0 ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Shop Discount",
                                  style: AppStyle.font18BoldWhite.override(fontSize: 14,color: Colors.green),
                                ),
                                Text(
                                  ApiConstants.currency+_con.orderDetailsModel.data!.payment!.vendorDiscount!.round().toString(),
                                  style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.green),
                                ),
                              ],
                            ):Container(),
                            _con.orderDetailsModel.data!.payment!.deliveryTips!=0 ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Tips",
                                  style: AppStyle.font18BoldWhite.override(fontSize: 14,color: Colors.orange),
                                ),
                                Text(
                                  ApiConstants.currency+_con.orderDetailsModel.data!.payment!.deliveryTips.toString(),
                                  style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.orange),
                                ),
                              ],
                            ):Container(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Packing Charges",
                                  style: AppStyle.font18BoldWhite.override(fontSize: 14,color: Colors.black),
                                ),
                                Text(
                                  ApiConstants.currency+_con.orderDetailsModel.data!.payment!.packingCharge!.round().toString(),
                                  style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.black),
                                ),
                              ],
                            ),
                            Divider(color: Colors.grey,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Grant Total",
                                  style: AppStyle.font18BoldWhite.override(fontSize: 16),
                                ),
                                Text(
                                  ApiConstants.currency+_con.orderDetailsModel.data!.payment!.grandTotal.toString(),
                                  style: AppStyle.font14MediumBlack87.override(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ):Container(),
    );
  }
}
