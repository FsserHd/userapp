


import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constants/api_constants.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/hotel_controller.dart';
import '../../model/hotel/hotel_booking_response.dart';

class HotelMyBookingDetailsPage extends StatefulWidget {
  HotelBookingData bookingBean;

  HotelMyBookingDetailsPage(this.bookingBean, {super.key});

  @override
  _HotelMyBookingDetailsPageState createState() => _HotelMyBookingDetailsPageState();
}

class _HotelMyBookingDetailsPageState extends StateMVC<HotelMyBookingDetailsPage> {

  late HotelController _con;

  _HotelMyBookingDetailsPageState() : super(HotelController()) {
    _con = controller as HotelController;
  }

  @override
  void initState() {
    super.initState();
    _con.myBookingDetails(context,widget.bookingBean.id!.toString());
    vendorAddress = LatLng(double.parse(widget.bookingBean.roomInfos!.latitude!), double.parse(widget.bookingBean.roomInfos!.longitude!));
  }

  CarouselSliderController _controller = CarouselSliderController();
  int currentIndex = 0;
  late GoogleMapController mapController;
  final _placesApiKey = 'AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY'; // Replace with your API key
  LatLng? vendorAddress;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
        title: Text(widget.bookingBean.roomInfos!.hotelName!,style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _con.bookingDetailsData.hotelContentInfo != null ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatefulBuilder(
                builder: (context, setStateSB) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hotel Image with Favorite Icon
                      CarouselSlider(
                        items: widget.bookingBean.roomInfos!.images!.map((e) {
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
                        children: widget.bookingBean.roomInfos!.images!.asMap().entries.map((entry) {
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
                    widget.bookingBean.roomInfos!.roomTitle ?? "",
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
                              widget.bookingBean.roomInfos!.stars?.toString() ?? "0",
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Text(
                    "${_con.bookingDetailsData.hotelContentInfo!.address!}",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),

                  // Price Section
                  Row(
                    children: [
                      Text(
                        ApiConstants.currency + (widget.bookingBean.grandTotal ?? "0"),
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
                      markerId: MarkerId(widget.bookingBean.roomInfos!.hotelName!),
                      position: vendorAddress!,
                    ),
                  },
                  myLocationEnabled: true, // Enables the "my location" layer which shows the user's location
                  myLocationButtonEnabled: true, // Adds a button to move the camera to the user's location
                ),
              )
            ],
          ):Container()
        ),
      ),
    );
  }
}
