


import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/model/hotel/booking_request.dart';
import 'package:userapp/model/hotel/hotel_response.dart';
import 'package:userapp/navigation/page_navigation.dart';

import '../../constants/api_constants.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/hotel_controller.dart';

class HotelVendorDetailsPage extends StatefulWidget {

  Hotels hotelData;
  BookingRequest bookingRequest;
  HotelVendorDetailsPage(this.hotelData, this.bookingRequest, {super.key});

  @override
  _HotelVendorDetailsPageState createState() => _HotelVendorDetailsPageState();
}

class _HotelVendorDetailsPageState extends StateMVC<HotelVendorDetailsPage> {

  late HotelController _con;
  CarouselController? _controller = CarouselController();

  _HotelVendorDetailsPageState() : super(HotelController()) {
    _con = controller as HotelController;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.getHotelDetails(context, widget.hotelData.id!.toString());
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
        title: Text(widget.hotelData.title!,style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _con.roomList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var roomBean = _con.roomList[index];
                  CarouselSliderController _controller = CarouselSliderController();
                  int currentIndex = 0;

                  return InkWell(
                    onTap: (){
                      PageNavigation.gotoHotelRoomPage(context,widget.hotelData, roomBean,widget.bookingRequest);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      margin: const EdgeInsets.all(8),
                      child: StatefulBuilder(
                        builder: (context, setStateSB) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Hotel Image with Favorite Icon
                              SizedBox(height: 5,),
                              Stack(
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      CarouselSlider(
                                        items: roomBean.images!.map((e) {
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

                                      // Dots Indicator
                                      Positioned(
                                        bottom: 10,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: roomBean.images!.asMap().entries.map((entry) {
                                            return GestureDetector(
                                              onTap: () => _controller.animateToPage(entry.key),
                                              child: Container(
                                                width: 8.0,
                                                height: 8.0,
                                                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  color: currentIndex == entry.key
                                                      ? Colors.white
                                                      : Colors.white.withOpacity(0.4),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                /*  Positioned(
                                    right: 12,
                                    top: 12,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.favorite_border, color: Colors.black54),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),*/
                                ],
                              ),

                              // Details Section
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Hotel Name
                                    Text(
                                      roomBean.roomTitle ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
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
                                                roomBean.stars?.toString() ?? "0",
                                                style: const TextStyle(color: Colors.white, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    // Price Section
                                    Row(
                                      children: [
                                        Text(
                                          ApiConstants.currency + (roomBean.minPrice?.toString() ?? "0"),
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
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

}
