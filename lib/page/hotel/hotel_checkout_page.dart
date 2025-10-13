


import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:userapp/model/hotel/booking_request.dart';
import 'package:userapp/page/payment/hotel_payment_page.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            bottom: 50,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hotel Name
                        Text(
                          widget.roomData.roomTitle ?? "",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Rating
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.white, size: 12),
                                  const SizedBox(width: 2),
                                  Text(
                                    widget.roomData.stars?.toString() ?? "0",
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        Text(
                          "${widget.hotelData.distance} - ${widget.hotelData.address!}",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),

                        // Price Section
                        Row(
                          children: [
                            Text(
                              "${ApiConstants.currency}${widget.bookingRequest.price!} + ${ApiConstants.currency}${((widget.bookingRequest.price! * tax) / 100)} GST",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "/ ${widget.bookingRequest.hours} hours",
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "Guest Information",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      controller: _con.nameController,
                      decoration: InputDecoration(
                        hintText: "Enter Name",
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey), // Default border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue, width: 2), // On focus
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      controller: _con.mobileController,
                      decoration: InputDecoration(
                        hintText: "Enter Mobile Number",
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey), // Default border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue, width: 2), // On focus
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      controller: _con.emailController,
                      decoration: InputDecoration(
                        hintText: "Enter Email",
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey), // Default border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue, width: 2), // On focus
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Check In Date:",
                          style:  TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "${widget.bookingRequest.checkInDate}",
                          style:  TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Check In Time:",
                          style:  TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "${widget.bookingRequest.checkInTime}",
                          style:  TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rooms:",
                          style:  TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "${widget.bookingRequest.rooms}",
                          style:  TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Adult:",
                          style:  TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "${widget.bookingRequest.adult}",
                          style:  TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Children:",
                          style:  TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "${widget.bookingRequest.children}",
                          style:  TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "Amenities",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        amenitiesList!.length,
                            (index) {
                          var amenity = amenitiesList![index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                const Icon(Icons.check, size: 16, color: Colors.teal),
                                const SizedBox(width: 6),
                                Text(
                                  ApiConstants.amenities[int.parse(amenity)],
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black87, // background like in your screenshot
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${ApiConstants.currency}${widget.bookingRequest.price! + ((widget.bookingRequest.price! * tax) / 100)}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              " - ${widget.bookingRequest.hours} Hours",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          "$paymentMode",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle room selection
                        if(_con.nameController.text.isEmpty){
                          ValidationUtils.showAppToast("Name required.");
                          return;
                        }
                        if(_con.mobileController.text.isEmpty){
                          ValidationUtils.showAppToast("Mobile Number required.");
                          return;
                        }
                        widget.bookingRequest.bookingName = _con.nameController.text;
                        widget.bookingRequest.bookingPhone = _con.mobileController.text;
                        widget.bookingRequest.bookingEmail = _con.emailController.text;
                        var totalPrice = widget.bookingRequest.price! + ((widget.bookingRequest.price! * tax) / 100);
                        if(paymentMode == "Choose Payment Mode") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HotelPaymentPage(totalPrice),
                            ),
                          ).then((e) {
                            FocusManager.instance.primaryFocus!.unfocus();
                            if (e == "online") {
                              setState(() {
                                paymentMode = e;
                              });
                            } else if (e == "cod") {
                              paymentMode = e;
                              _con.booking(context, widget.bookingRequest);
                            }
                          });
                        }else{
                          if (paymentMode == "online") {
                            _con.createOrderId(context, totalPrice.toString()).then((value){
                              goOnlinePayment(_con.mobileController.text,totalPrice);
                            });
                          } else if (paymentMode == "cod") {
                            _con.booking(context, widget.bookingRequest);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Book Now",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),
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
