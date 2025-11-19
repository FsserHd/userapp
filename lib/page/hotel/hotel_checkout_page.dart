


import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:userapp/model/hotel/booking_request.dart';
import 'package:userapp/page/payment/hotel_payment_page.dart';
import 'package:userapp/utils/time_utils.dart';
import 'package:userapp/utils/validation_utils.dart';

import '../../constants/api_constants.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/hotel_controller.dart';
import '../../model/hotel/hotel_details_response.dart';
import '../../model/hotel/hotel_response.dart';
import '../../utils/preference_utils.dart';

class HotelCheckoutPage extends StatefulWidget {

  Hotels hotelData;
  Rooms roomData;
  BookingRequest bookingRequest;


  HotelCheckoutPage(this.hotelData, this.roomData,this.bookingRequest, {super.key});

  @override
  _HotelCheckoutPageState createState() => _HotelCheckoutPageState();
}

class _HotelCheckoutPageState extends StateMVC<HotelCheckoutPage> {

  late HotelController _con;


  _HotelCheckoutPageState() : super(HotelController()) {
    _con = controller as HotelController;
  }

  CarouselSliderController _controller = CarouselSliderController();
  int currentIndex = 0;
  List<String>? amenitiesList;
  var tax = 5;
  var paymentMode  = "Choose Payment Mode";
  var razorpay = Razorpay();
  LatLng? vendorAddress;
  late GoogleMapController mapController;
  final _placesApiKey = 'AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY'; // Replace with your API key

  void handlePaymentErrorResponse(PaymentFailureResponse response){
    // showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");

  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){
    // showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
    _con.booking(context,widget.bookingRequest);

  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    //showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vendorAddress = LatLng(double.parse(widget.hotelData.latitude!), double.parse(widget.hotelData.longitude!));
    amenitiesList = List<String>.from(jsonDecode(widget.roomData.amenities!));
    _con.getProfile();
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
        title: Text("CheckOut",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 80,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatefulBuilder(
                      builder: (context, setStateSB) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hotel Image with Favorite Icon
                            CarouselSlider(
                              items: widget.roomData.images!.map((e) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: const BoxDecoration(color: Colors.white),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: Image.network(
                                          e,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                              carouselController: _controller,
                              options: CarouselOptions(
                                height: 150.0,
                                autoPlay: true,
                                enlargeCenterPage: false,
                                autoPlayCurve: Curves.easeInOut,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                viewportFraction: 1.0,
                                onPageChanged: (index, reason) {
                                  setStateSB(() {
                                    currentIndex = index;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: widget.roomData.images!.asMap().entries.map((entry) {
                                return GestureDetector(
                                  onTap: () => _controller.animateToPage(entry.key),
                                  child: Container(
                                    width: 60.0,
                                    height: 40.0,
                                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: currentIndex == entry.key ? AppColors.themeColor : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        entry.value,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column: Hotel Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Hotel Name
                                Text(
                                  widget.roomData.roomTitle ?? "",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.roomData.hotelName ?? "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black26,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Rating + Direction Icon
                                Row(
                                  children: [
                                    Container(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.star,
                                              color: Colors.white, size: 14),
                                          const SizedBox(width: 3),
                                          Text(
                                            widget.roomData.stars?.toString() ?? "0",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        // open google maps or direction
                                      },
                                      child: Row(
                                        children: const [
                                          Icon(Icons.directions,
                                              color: Colors.blueAccent, size: 16),
                                          SizedBox(width: 4),
                                          Text(
                                            "Direction",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                // Address
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.location_on_outlined,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        "${widget.hotelData.distance} • ${widget.hotelData.address!}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Price
                                Row(
                                  children: [
                                    Text(
                                      "${ApiConstants.currency}${widget.bookingRequest.price?.toString() ?? "0"}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Right Side: Mini Map
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: GoogleMap(
                                onMapCreated: _onMapCreated,
                                zoomGesturesEnabled: false,
                                scrollGesturesEnabled: false,
                                tiltGesturesEnabled: false,
                                rotateGesturesEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: vendorAddress!,
                                  zoom: 14.0,
                                ),
                                markers: {
                                  Marker(
                                    markerId: MarkerId(widget.hotelData.title!),
                                    position: vendorAddress!,
                                  ),
                                },
                                myLocationEnabled: false,
                                myLocationButtonEnabled: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.person_outline, color: Colors.teal),
                        SizedBox(width: 8),
                        Text(
                          "Guest Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 🧍 Name Field
                    TextField(
                      controller: _con.nameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.badge_outlined, color: Colors.teal),
                        labelText: "Full Name",
                        hintText: "Enter guest name",
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.teal, width: 2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // 📱 Mobile Field
                    TextField(
                      controller: _con.mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone_outlined, color: Colors.teal),
                        labelText: "Mobile Number",
                        hintText: "Enter your phone number",
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.teal, width: 2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // 📧 Email Field
                    TextField(
                      controller: _con.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined, color: Colors.teal),
                        labelText: "Email Address",
                        hintText: "Enter your email",
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.teal, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.teal.shade400, Colors.teal.shade700],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Check-in",
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white70, fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                "${TimeUtils.convertDayMonthYear(widget.bookingRequest.checkInDate!)} 11:00 AM",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Check-out",
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white70, fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                  "${TimeUtils.convertDayMonthYear(widget.bookingRequest.checkOutDate!)} 10:00 AM",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.meeting_room, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Rooms",
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white70, fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                "${widget.bookingRequest.rooms}",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Adults",
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white70, fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                "${widget.bookingRequest.adult}",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.child_care, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Children",
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white70, fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                "${widget.bookingRequest.children}",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Divider(color: Colors.white.withOpacity(0.3)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total Nights",
                                style: TextStyle(fontSize: 15, color: Colors.white70),
                              ),
                              Text(
                                "${widget.bookingRequest.nights}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),

                  ],
                ),
              ),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.white10, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${ApiConstants.currency}${widget.bookingRequest.price!.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.payment, color: Colors.white54, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                paymentMode,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_con.nameController.text.isEmpty) {
                          ValidationUtils.showAppToast("Name required.");
                          return;
                        }
                        if (_con.mobileController.text.isEmpty) {
                          ValidationUtils.showAppToast("Mobile Number required.");
                          return;
                        }

                        widget.bookingRequest.bookingName = _con.nameController.text;
                        widget.bookingRequest.bookingPhone = _con.mobileController.text;
                        widget.bookingRequest.bookingEmail = _con.emailController.text;
                        var totalPrice = widget.bookingRequest.price! +
                            ((widget.bookingRequest.price! * tax) / 100);

                        if (paymentMode == "Choose Payment Mode") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HotelPaymentPage(totalPrice),
                            ),
                          ).then((e) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (e == "online") {
                              setState(() {
                                paymentMode = e;
                              });
                            } else if (e == "cod") {
                              paymentMode = e;
                              _con.booking(context, widget.bookingRequest);
                            }
                          });
                        } else {
                          if (paymentMode == "online") {
                            _con.createOrderId(context, totalPrice.toString()).then((value) {
                              goOnlinePayment(_con.mobileController.text, totalPrice);
                            });
                          } else if (paymentMode == "cod") {
                            _con.booking(context, widget.bookingRequest);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent[700],
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 6,
                      ),
                      icon: const Icon(Icons.hotel, color: Colors.white, size: 18),
                      label: const Text(
                        "Book Now",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }

  goOnlinePayment(String phone,double price) async {

    var options = {
      'key': 'rzp_live_Qdir89rIuPxK1S',
      'amount': price * 100,
      'name': '',
      'order_id':_con.orderId,
      'description': 'Online Payment',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '${phone}'},
      'external': {
        'wallets': ['paytm']
      }
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);
  }


}
