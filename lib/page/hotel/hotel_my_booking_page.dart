

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/controller/hotel_controller.dart';
import 'package:userapp/utils/time_utils.dart';

import '../../constants/api_constants.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../navigation/page_navigation.dart';

class HotelMyBookingPage extends StatefulWidget {
  const HotelMyBookingPage({super.key});

  @override
  _HotelMyBookingPageState createState() => _HotelMyBookingPageState();
}

class _HotelMyBookingPageState extends StateMVC<HotelMyBookingPage> {

  late HotelController _con;

  _HotelMyBookingPageState() : super(HotelController()) {
    _con = controller as HotelController;
  }

  @override
  void initState() {
    super.initState();
    _con.myBooking(context);
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
        title: Text("My Rooms",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
        ListView.builder(
        itemCount: _con.myBookingList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var bookingBean = _con.myBookingList[index];

            return InkWell(
              onTap: () {
                PageNavigation.gotoHotelMyBookingDetails(context, bookingBean);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🖼️ Image with gradient overlay
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(
                            bookingBean.roomInfos?.images?.first ?? "",
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Gradient overlay for better readability
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        // ⭐ Rating badge
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, size: 14, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  bookingBean.roomInfos?.stars?.toString() ?? "0",
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // 📖 Details Section
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hotel name
                          Text(
                            bookingBean.roomInfos?.hotelName ?? "Hotel Name",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bookingBean.roomInfos?.roomTitle ?? "",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // 🛏️ Info Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.king_bed, size: 12, color: Colors.teal),
                                  SizedBox(width: 4),
                                  Text("${bookingBean.rooms!} Room", style: TextStyle(fontSize: 10, color: Colors.black54)),
                                  SizedBox(width: 6),
                                  Icon(Icons.people_alt, size: 12, color: Colors.teal),
                                  SizedBox(width: 4),
                                  Text("${bookingBean.adult!} Adults", style: TextStyle(fontSize: 10, color: Colors.black54)),
                                  SizedBox(width: 6),
                                  Icon(Icons.people_alt, size: 12, color: Colors.teal),
                                  SizedBox(width: 4),
                                  Text("${bookingBean.children!} Child", style: TextStyle(fontSize: 10, color: Colors.black54)),
                                  SizedBox(width: 6),
                                  Icon(Icons.people_alt, size: 12, color: Colors.teal),
                                  SizedBox(width: 4),
                                  Text("${bookingBean.nights!} Night(s)", style: TextStyle(fontSize: 10, color: Colors.black54)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // 💰 Price and date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${ApiConstants.currency}${bookingBean.grandTotal ?? 0}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month, size: 16, color: Colors.teal),
                                  const SizedBox(width: 4),
                                  Text(
                                    TimeUtils.convertUTC(bookingBean.createdAt!),
                                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                                  ),
                                ],
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
          },
        )
        ],
        ),
      ),
    );
  }
}
