


import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/constants/api_constants.dart';
import 'package:userapp/controller/hotel_controller.dart';
import 'package:userapp/model/hotel/booking_request.dart';
import 'package:userapp/navigation/page_navigation.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';

class HotelVendorsPage extends StatefulWidget {

  BookingRequest bookingRequest;
  HotelVendorsPage(this.bookingRequest, {super.key});

  @override
  _HotelVendorsPageState createState() => _HotelVendorsPageState();
}

class _HotelVendorsPageState extends StateMVC<HotelVendorsPage> {

  late HotelController _con;

  _HotelVendorsPageState() : super(HotelController()) {
    _con = controller as HotelController;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.getHotels(context);
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
        title: Text("Nearby Hotels",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListView.builder(
                  padding: EdgeInsets.zero,
                itemCount: _con.hotelList.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap:true,
                  itemBuilder: (context,index){
                  var hotelBean = _con.hotelList[index];
                return InkWell(
                  onTap: (){
                    PageNavigation.gotoHotelVendorDetailsPage(context,hotelBean,widget.bookingRequest);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hotel Image with Favorite Icon
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  hotelBean.logo!, // sample image
                                  height: 140,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
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
                            ),
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
                                hotelBean.title!,
                                style: TextStyle(
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
                                        Icon(Icons.star,color: Colors.white,size: 12,),
                                        SizedBox(width: 2,),
                                        Text(
                                          hotelBean.stars!.toString(),
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),

                              const SizedBox(height: 6),

                              // Location
                              Text(
                                "${hotelBean.distance} - ${hotelBean.address!}",
                                style: TextStyle(fontSize: 12, color: Colors.black54),
                              ),

                              const SizedBox(height: 8),

                              // Price Section
                              Row(
                                children: [
                                  Text(
                                    ApiConstants.currency+ hotelBean.minPrice!.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "/ Min Price",
                                    style: TextStyle(fontSize: 12, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
