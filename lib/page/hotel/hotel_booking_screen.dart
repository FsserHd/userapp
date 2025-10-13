

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/model/hotel/booking_request.dart';
import 'package:userapp/utils/validation_utils.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../navigation/page_navigation.dart';
import '../../utils/preference_utils.dart';
import '../auth/login/inside_login_page.dart';

class HotelBookingScreen extends StatefulWidget {

  const HotelBookingScreen({super.key});

  @override
  State<HotelBookingScreen> createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {

  List<String> imageList = ["https://thee4square.com/images/123.jpg","https://thee4square.com/images/123.jpg"];
  DateTime? checkIn;
  DateTime? checkOut;
  int adults = 1;
  int children = 0;
  int rooms = 1;
  String? location = "";
  var checkInController = TextEditingController();
  var checkOutController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PreferenceUtils.getLocation().then((value){
      setState(() {
        location = value;
      });
    });
  }



  Future<void> _pickDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(picked);

      setState(() {
        if (isCheckIn) {
          checkIn = picked;
          checkInController.text = formattedDate; // ✅ Now shows 14/09/2025
        } else {
          checkOut = picked;
          checkOutController.text = formattedDate; // ✅ Now shows 14/09/2025
        }
      });
    }
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
        title: Text("Hotel Bookings",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            CarouselSlider(
              options: CarouselOptions(
                height: 150.0,
                autoPlay: true,
                enlargeCenterPage: false,
                aspectRatio: 32 / 12,
                autoPlayCurve: Curves.easeInOut,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
              items: imageList.map((e) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: GestureDetector(
                        onTap: (){

                        },
                        child: Image.network(
                          e,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Welcome to your next \n",
                          style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 24),
                        ),
                        TextSpan(
                          text: "4 Square",
                          style: AppStyle.font14MediumBlack87.override(color: AppColors.themeColor,fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Discover the Perfect Stay with WanderStay",
                    style: AppStyle.font14RegularBlack87.override(color: Colors.orange,fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  // Location Field
                  InkWell(
                    onTap: () async {
                      String?  userId = await PreferenceUtils.getUserId();
                      if(userId ==null){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InsideLoginPage(),
                          ),
                        );
                      }else {
                        PageNavigation.gotoAddressPage(context, "hotel");
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade500),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  location!,
                                  style: AppStyle.font14RegularBlack87.override(fontSize: 10),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Change Location",
                                    style: AppStyle.font14RegularBlack87.override(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Check-in / Check-out


                  // Guests and Rooms
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Adults"),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (adults > 1) adults--;
                                      });
                                    },
                                    icon: Icon(Icons.remove_circle_outline),
                                  ),
                                  Text(
                                    "$adults",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        adults++;
                                      });
                                    },
                                    icon:  Icon(Icons.add_circle_outline),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Children"),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (children > 1) children--;
                                      });
                                    },
                                    icon: Icon(Icons.remove_circle_outline),
                                  ),
                                  Text(
                                    "$children",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        children++;
                                      });
                                    },
                                    icon: Icon(Icons.add_circle_outline),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Rooms"),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (rooms > 1) rooms--;
                                      });
                                    },
                                    icon: Icon(Icons.remove_circle_outline),
                                  ),
                                  Text(
                                    "$rooms",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        rooms++;
                                      });
                                    },
                                    icon: Icon(Icons.add_circle_outline),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Find Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {

                          var bookingRequest = BookingRequest();
                          bookingRequest.adult = adults;
                          bookingRequest.children = children;
                          bookingRequest.rooms = rooms;
                          bookingRequest.bookingAddress  = location;
                          PageNavigation.gotoHotelVendorPage(context,bookingRequest);
                      },
                      child: const Text(
                        "FIND",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
