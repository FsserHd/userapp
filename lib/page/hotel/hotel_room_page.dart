
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


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // checkInController.text = widget.bookingRequest.checkInDate!;
    vendorAddress = LatLng(double.parse(widget.hotelData.latitude!), double.parse(widget.hotelData.longitude!));
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
              bottom: selectedPrice!=null ? 60 : 0,
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
                            ApiConstants.currency + (widget.roomData.minPrice?.toString() ?? "0"),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "/ Min Price",
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: checkInController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Check-in",
                            hintText: "DD/MM/YY",
                            suffixIcon: Icon(Icons.calendar_today_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onTap: () => _pickDate(context, true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: checkInTimeController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Check-In-Time",
                            hintText: "HH:MM",
                            suffixIcon: Icon(Icons.calendar_today_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onTap: () => _pickTime(context, false),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  if(_con.timeSlots.isNotEmpty)
                  Text(
                    "Select Duration",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10,),
                  if(_con.timeSlots.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<HourlyPrices>(
                          hint: const Text("Select Duration"),
                          value: selectedPrice,
                          isExpanded: true,
                          items: _con.timeSlots.map((priceData) {
                            return DropdownMenuItem<HourlyPrices>(
                              value: priceData, // keep the full object
                              child: Text(
                                "${priceData.hour} Hours - ${ApiConstants.currency}${priceData.price}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPrice = value; // store whole object
                            });
                          },
                        ),
                      ),
                    ),
                  SizedBox(height: 20,),
                  Container(
                    height: 250,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      zoomGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      rotateGesturesEnabled: true,
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
                      myLocationEnabled: true, // Enables the "my location" layer which shows the user's location
                      myLocationButtonEnabled: true, // Adds a button to move the camera to the user's location
                    ),
                  )
                ],
              ),
            ),
          )),
          if(selectedPrice!=null)
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
                          "${ApiConstants.currency}${selectedPrice!.price}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5,),
                        Text(
                          " - ${selectedPrice!.hour} Hours",
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
                      "${checkInController.text} - ${checkInTimeController.text}",
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
                    widget.bookingRequest.roomId = widget.roomData.id.toString();
                    widget.bookingRequest.priceId = selectedPrice!.id.toString();
                    widget.bookingRequest.hotelId = widget.hotelData.id.toString();
                    widget.bookingRequest.vendorId = widget.hotelData.vendorId.toString();
                    widget.bookingRequest.gateway = 1;
                    widget.bookingRequest.checkInTime = checkInTimeController.text;
                    widget.bookingRequest.checkInDate = checkInController.text;
                    widget.bookingRequest.price = selectedPrice!.price;
                    widget.bookingRequest.hours = selectedPrice!.hour.toString();
                    PageNavigation.gotoHotelCheckoutPage(context, widget.hotelData, widget.roomData, widget.bookingRequest);
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
}
