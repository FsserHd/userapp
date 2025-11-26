

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
import '../address/address_page.dart';
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
  DateTimeRange? selectedRange;
  int adults = 2;
  int children = 0;
  int rooms = 1;
  String? location = "";
  var checkInController = TextEditingController();
  var checkOutController = TextEditingController();
  var bookingRequest = BookingRequest();

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

  void _updateAdults(int value) {
    setState(() {
      adults = value;
      rooms = (adults / 2).ceil(); // Ensure room count matches adults
    });
  }

  void _updateRooms(int value) {
    setState(() {
      rooms = value;
      int maxAdults = rooms * 2;
      if (adults > maxAdults) {
        adults = maxAdults; // Adjust adults if exceeding room capacity
      }
    });
  }




  String get formattedDateRange {
    if (selectedRange == null) return "Select Dates";
    final start = DateFormat("MMM dd").format(selectedRange!.start);
    final end = DateFormat("MMM dd").format(selectedRange!.end);
    bookingRequest.checkInDate = DateFormat("dd-MM-yyyy").format(selectedRange!.start);
    bookingRequest.checkOutDate = DateFormat("dd-MM-yyyy").format(selectedRange!.end);
    return "$start → $end";
  }

  Future<void> pickDateRange() async {
    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      // 🔹 Allow only from today onwards
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 1, 12, 31),

      initialDateRange: selectedRange ??
          DateTimeRange(
            start: DateTime(now.year, now.month, now.day),
            end: DateTime(now.year, now.month, now.day + 1),
          ),

      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedRange) {
      setState(() => selectedRange = picked);
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
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      "Find Your Perfect Stay 🏨",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Book your next destination in seconds",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Destination Field
                    InkWell(
                      onTap: () async {
                        // Navigate to location picker
                        String?  userId = await PreferenceUtils.getUserId();
                        if(userId ==null){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InsideLoginPage(),
                            ),
                          );
                        }else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddressPage("hotel"),
                            ),
                          ).then((value){
                            setState(() {
                              if(value!=null) {
                                location = value;
                              }
                            });
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: Colors.teal),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Destination",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                  Text(location!,
                                      style: TextStyle(
                                          fontSize: 15, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Date Range Picker
                    InkWell(
                      onTap: pickDateRange,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined,
                                color: Colors.teal),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Check-in / Check-out",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                  Text(formattedDateRange,
                                      style: const TextStyle(
                                          fontSize: 15, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Guests & Rooms
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _modernCounter("Adults", adults, (v) => _updateAdults(v)),
                        _modernCounter("Children", children, (v) => setState(() => children = v)),
                        _modernCounter("Rooms", rooms, (v) => _updateRooms(v)),
                      ],
                    ),
                  ),
                    const SizedBox(height: 24),

                    // Search Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          // Send booking request or navigate to next page
                          if(selectedRange!=null){

                          bookingRequest.adult = adults;
                          bookingRequest.children = children;
                          bookingRequest.rooms = rooms;
                          bookingRequest.bookingAddress  = location;
                          PageNavigation.gotoHotelVendorPage(context,bookingRequest);
                          }else{
                            ValidationUtils.showAppToast("Check-in & Check-out date required");
                          }
                        },
                        child: const Text(
                          "Find Hotels",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _modernCounter(String label, int value, Function(int) onChanged) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _circleButton(
              icon: Icons.remove,
              onTap: () {
                if (value > 0) onChanged(value - 1);
              },
            ),
            const SizedBox(width: 10),
            Text(
              "$value",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            _circleButton(
              icon: Icons.add,
              onTap: () => onChanged(value + 1),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(50),
    child: Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: Colors.teal),
    ),
  );
}


