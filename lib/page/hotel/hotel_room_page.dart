
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/model/hotel/booking_request.dart';
import 'package:userapp/model/hotel/time_slot_response.dart';
import 'package:userapp/navigation/page_navigation.dart';

import '../../constants/api_constants.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/hotel_controller.dart';
import '../../model/hotel/hotel_details_response.dart';
import '../../model/hotel/hotel_response.dart';

class HotelRoomPage extends StatefulWidget {

  Hotels hotelData;
  Rooms roomData;
  BookingRequest bookingRequest;
  HotelRoomPage(this.hotelData, this.roomData,this.bookingRequest, {super.key});


  @override
  _HotelRoomPageState createState() => _HotelRoomPageState();
}

class _HotelRoomPageState extends StateMVC<HotelRoomPage> {

  late HotelController _con;


  _HotelRoomPageState() : super(HotelController()) {
    _con = controller as HotelController;
  }


  CarouselSliderController _controller = CarouselSliderController();
  int currentIndex = 0;
  var checkInController = TextEditingController();
  var checkInTimeController = TextEditingController();
  DateTime? checkIn;
  TimeOfDay? checkInTime;
  HourlyPrices? selectedPrice;
  late GoogleMapController mapController;
  final _placesApiKey = 'AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY'; // Replace with your API key
  LatLng? vendorAddress;
  List<String>? amenitiesList;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // checkInController.text = widget.bookingRequest.checkInDate!;
    vendorAddress = LatLng(double.parse(widget.hotelData.latitude!), double.parse(widget.hotelData.longitude!));
    amenitiesList = List<String>.from(jsonDecode(widget.roomData.amenities!));
  }

  Future<void> _pickDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);

      setState(() {
        if (isCheckIn) {
          checkIn = picked;
          checkInController.text = formattedDate; // ✅ Now shows 14/09/2025
        //  _con.checkIn(context, widget.roomData.id.toString(), widget.bookingRequest.checkInDate!, checkInTimeController.text);
        }
      });
    }
  }

  Future<void> _pickTime(BuildContext context, bool isCheckIn) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      final selectedTime =
      DateTime(now.year, now.month, now.day, picked.hour, picked.minute);

      String formattedTime = DateFormat('hh:mm a').format(selectedTime); // e.g., 02:45 PM
      print(formattedTime);
      setState(() {
          checkInTime = picked;
          checkInTimeController.text = formattedTime;
          _con.checkIn(context, widget.roomData.id.toString(), checkInController.text, checkInTimeController.text);
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    final DateTime checkIn = DateFormat("dd-MM-yyyy").parse(widget.bookingRequest.checkInDate!);
    final DateTime checkOut = DateFormat("dd-MM-yyyy").parse(widget.bookingRequest.checkOutDate!);
    final int nights = checkOut.difference(checkIn).inDays;
    // Calculate nights difference
   // int nights = DateTime.parse(widget.bookingRequest.checkOutDate!).difference(DateTime.parse(widget.bookingRequest.checkInDate!)).inDays;


    return Scaffold(
      backgroundColor: AppColors.dashboardBgColor,
      appBar:  AppBar(
        backgroundColor: AppColors.themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.roomData.roomTitle!,style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
              left: 0,
              right: 0,
              bottom: 80,
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 Title Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Your Stay Details",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.calendar_today_outlined, color: Colors.teal),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 🔹 Check-in and Check-out Dates
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDateBox(
                                context,
                                title: "Check-In",
                                date: DateFormat("dd MMM yyyy").format(checkIn) + " 11:00 AM",
                                icon: Icons.login_rounded,
                              ),
                              SizedBox(width: 2,),
                              Container(
                                height: 45,
                                width: 1.2,
                                color: Colors.grey.shade300,
                              ),
                              SizedBox(width: 2,),
                              _buildDateBox(
                                context,
                                title: "Check-Out",
                                date: DateFormat("dd MMM yyyy").format(checkOut)+ " 10:00 AM",
                                icon: Icons.logout_rounded,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // 🔹 Nights Info
                          Center(
                            child: Text(
                              "$nights ${nights > 1 ? 'Nights' : 'Night'} Stay",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // 🔹 Guests & Rooms Info
                          GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _buildInfoCard(
                                icon: Icons.people_alt_outlined,
                                label: "Adults",
                                value: "${widget.bookingRequest.adult}",
                                color: Colors.teal,
                              ),
                              _buildInfoCard(
                                icon: Icons.child_care_outlined,
                                label: "Children",
                                value: "${widget.bookingRequest.children}",
                                color: Colors.orangeAccent,
                              ),
                              _buildInfoCard(
                                icon: Icons.meeting_room_outlined,
                                label: "Rooms",
                                value: "${widget.bookingRequest.rooms}",
                                color: Colors.blueAccent,
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Room & Amenties",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2,),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // 🛏 Beds
                      Row(
                        children: [
                          Icon(Icons.bed, color: Colors.teal, size: 20),
                          SizedBox(width: 5),
                          Text("${widget.roomData.bed} Beds",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87)),
                        ],
                      ),
                      // 🚿 Bathroom
                      Row(
                        children: [
                          Icon(Icons.bathtub_outlined, color: Colors.teal, size: 20),
                          SizedBox(width: 5),
                          Text("${widget.roomData.bathroom} Bathroom",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87)),
                        ],
                      ),
                    ],
                  ),
                ),
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
                  )
                ],
              ),
            ),
          )),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 💰 Price Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${ApiConstants.currency}${widget.bookingRequest.price}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.nightlight_round,
                                size: 14, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(
                              "${widget.bookingRequest.nights ?? 1} night(s)",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.meeting_room_outlined,
                                size: 14, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(
                              "${widget.bookingRequest.rooms ?? 1} room(s)",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // 🟩 Book Now Button
                    ElevatedButton.icon(
                      onPressed: () {
                        widget.bookingRequest.roomId = widget.roomData.id.toString();
                        widget.bookingRequest.priceId = "0";
                        widget.bookingRequest.hotelId = widget.hotelData.id.toString();
                        widget.bookingRequest.vendorId = widget.hotelData.vendorId.toString();
                        widget.bookingRequest.gateway = 1;
                        widget.bookingRequest.checkInTime = "11:00 AM";
                        widget.bookingRequest.hours = "24";

                        PageNavigation.gotoHotelCheckoutPage(
                            context, widget.hotelData, widget.roomData, widget.bookingRequest);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.white, size: 16),
                      label: const Text(
                        "Book Now",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }


  // 🔹 Small Widget for date section
  Widget _buildDateBox(BuildContext context,
      {required String title, required String date, required IconData icon}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.teal, size: 20),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              date,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
