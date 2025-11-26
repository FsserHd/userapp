


import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/model/hotel/booking_request.dart';
import 'package:userapp/model/hotel/hotel_response.dart';
import 'package:userapp/navigation/page_navigation.dart';
import 'package:userapp/utils/time_utils.dart';
import 'package:userapp/utils/validation_utils.dart';

import '../../constants/api_constants.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/hotel_controller.dart';
import '../../flutter_flow/flutter_flow_util.dart';

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

  DateTimeRange? selectedRange;
  int? nights;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.getHotelDetails(context, widget.hotelData.id!.toString(),widget.bookingRequest);
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

  String get formattedDateRange {
    if (selectedRange == null) {
      return formatDateRange(widget.bookingRequest.checkInDate!,widget.bookingRequest.checkOutDate!);
    }

    final start = DateFormat("MMM dd").format(selectedRange!.start);
    final end = DateFormat("MMM dd").format(selectedRange!.end);
    widget.bookingRequest.checkInDate = DateFormat("dd-MM-yyyy").format(selectedRange!.start);
    widget.bookingRequest.checkOutDate = DateFormat("dd-MM-yyyy").format(selectedRange!.end);
    return "$start → $end";
  }

  String formatDateRange(String checkIn, String checkOut) {
    try {
      // Parse your date strings (dd-MM-yyyy)
      final checkInDate = DateFormat("dd-MM-yyyy").parse(checkIn);
      final checkOutDate = DateFormat("dd-MM-yyyy").parse(checkOut);

      // Format to "MMM d" (e.g., Nov 10)
      final checkInFormatted = DateFormat("MMM d").format(checkInDate);
      final checkOutFormatted = DateFormat("MMM d").format(checkOutDate);

      // Return combined format
      return "$checkInFormatted - $checkOutFormatted";
    } catch (e) {
      return "";
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
        title: Text(widget.hotelData.title!,style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Date Range Picker
              InkWell(
                onTap: pickDateRange, // Opens date picker
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        // 📅 Icon + Date Info
                        const Icon(Icons.calendar_today_outlined, color: Colors.teal),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Check-in / Check-out",
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                formattedDateRange.isEmpty ? "Select date range" : formattedDateRange,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ✅ Apply Button
                        InkWell(
                          onTap: () {
                            _con.getHotelDetails(context, widget.hotelData.id!.toString(),widget.bookingRequest);
                          },
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
          ListView.builder(
          padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _con.roomList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var roomBean = _con.roomList[index];
              CarouselSliderController _controller = CarouselSliderController();
              int currentIndex = 0;
              final checkInRaw = DateFormat("dd-MM-yyyy").parse(widget.bookingRequest.checkInDate!);
              final checkOutRaw = DateFormat("dd-MM-yyyy").parse(widget.bookingRequest.checkOutDate!);
              final checkIn = DateTime(checkInRaw.year, checkInRaw.month, checkInRaw.day);
              final checkOut = DateTime(checkOutRaw.year, checkOutRaw.month, checkOutRaw.day);
              roomBean.nights = (checkOut.difference(checkIn).inDays)-1;
              return InkWell(
                onTap: () {
                  if(roomBean.hourlyPrices!.isNotEmpty) {
                    widget.bookingRequest.checkInDate = TimeUtils.convertddMMyyyy(roomBean.hourlyPrices![0].date!);
                    widget.bookingRequest.nights = roomBean.hourlyPrices!.length;
                    widget.bookingRequest.price  = ((double.parse(roomBean.minPrice!).round() * (roomBean.hourlyPrices!.length))* widget.bookingRequest.rooms!);
                    PageNavigation.gotoHotelRoomPage(
                        context, widget.hotelData, roomBean,
                        widget.bookingRequest);
                  }else{
                    ValidationUtils.showAppToast("Sold out");
                  }

                },
                borderRadius: BorderRadius.circular(16),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black26,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  clipBehavior: Clip.antiAlias,
                  child: StatefulBuilder(
                    builder: (context, setStateSB) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 Image Carousel
                          Stack(
                            children: [
                              CarouselSlider(
                                items: roomBean.images!.map((e) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: ColorFiltered(
                                          colorFilter:
                                              const ColorFilter.mode(Colors.grey, BlendMode.multiply)
                                              ,
                                          child: Image.network(
                                            e,
                                            width: double.infinity,
                                            height: 180,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, progress) {
                                              if (progress == null) return child;
                                              return Container(
                                                color: Colors.grey.shade200,
                                                child: const Center(
                                                  child: CircularProgressIndicator(color: Colors.teal),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                                carouselController: _controller,
                                options: CarouselOptions(
                                  height: 180.0,
                                  autoPlay: true,
                                  enlargeCenterPage: false,
                                  enableInfiniteScroll: true,
                                  viewportFraction: 1.0,
                                  autoPlayInterval: const Duration(seconds: 4),
                                  autoPlayAnimationDuration:
                                  const Duration(milliseconds: 900),
                                  onPageChanged: (index, reason) {
                                    setStateSB(() {
                                      currentIndex = index;
                                    });
                                  },
                                ),
                              ),

                              // 🔹 Gradient overlay for text visibility
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.4),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // 🔹 Image Dots Indicator
                              Positioned(
                                bottom: 10,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: roomBean.images!.asMap().entries.map((entry) {
                                    return GestureDetector(
                                      onTap: () => _controller.animateToPage(entry.key),
                                      child: Container(
                                        width: currentIndex == entry.key ? 10 : 6,
                                        height: 6,
                                        margin: const EdgeInsets.symmetric(horizontal: 3),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          color: currentIndex == entry.key
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.4),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                            /*  // 🔹 Favorite Icon
                              Positioned(
                                right: 12,
                                top: 12,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.favorite_border,
                                        color: Colors.white),
                                    onPressed: () {},
                                  ),
                                ),
                              ),*/
                            ],
                          ),

                          // 🔹 Room Info Section
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 🌈 Title Row
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [Colors.teal, Colors.greenAccent],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                roomBean.roomTitle ?? "",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, size: 16, color: Colors.amber),
                                              const SizedBox(width: 4),
                                              Text(
                                                roomBean.stars?.toString() ?? "0",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 10),
                                      if(roomBean.hourlyPrices!.isNotEmpty)
                                      // 🕒 Check-in Time Info
                                      Row(
                                        children: [
                                          const Icon(Icons.login, size: 16, color: Colors.teal),
                                          const SizedBox(width: 6),
                                          const Text(
                                            "Check-in:",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${TimeUtils.convertMonthDateYear(roomBean.hourlyPrices![0].date!)} 11:00 AM",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 4),

                                      Row(
                                        children: [
                                          const Icon(Icons.logout, size: 16, color: Colors.orange),
                                          const SizedBox(width: 6),
                                          const Text(
                                            "Check-out:",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${TimeUtils.convertDayMonthYear(widget.bookingRequest.checkOutDate!)} 10:00 AM",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    if(roomBean.hourlyPrices!.isNotEmpty)
                                    Text(
                                      "${ApiConstants.currency}${((double.parse(roomBean.minPrice!).round() * (roomBean.hourlyPrices!.length))* widget.bookingRequest.rooms!) ?? 0}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    if(roomBean.hourlyPrices!.isNotEmpty)
                                    const SizedBox(width: 5),
                                    if(roomBean.hourlyPrices!.isNotEmpty)
                                    Text(
                                      "/ ${roomBean.hourlyPrices!.length} night / ${widget.bookingRequest.rooms} rooms",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const Spacer(),
                                    if(roomBean.hourlyPrices!.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Colors.teal, Colors.green],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        "Book Now",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    if(roomBean.hourlyPrices!.isEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Colors.grey, Colors.grey],
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          "Sold out",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),

                                  ],
                                ),
                                if (roomBean.hourlyPrices!.length!=1 && roomBean.hourlyPrices != null && roomBean.hourlyPrices!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Availability Date",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 6),

                                      // 🔹 Horizontal date list
                                      SizedBox(
                                        height: 36,
                                        child: Builder(builder: (context) {
                                          // Booking range
                                          final checkIn = DateFormat("dd-MM-yyyy").parse(widget.bookingRequest.checkInDate!);
                                          final checkOut = DateFormat("dd-MM-yyyy").parse(widget.bookingRequest.checkOutDate!);


                                          final prices = roomBean.hourlyPrices ?? [];


                                          final priceMap = {
                                            for (var p in prices)
                                              DateFormat("yyyy-MM-dd").format(DateTime.parse(p.date!)): p
                                          };


                                          List<DateTime> allDates = [];
                                          for (var d = checkIn; d.isBefore(checkOut); d = d.add(const Duration(days: 1))) {
                                            allDates.add(d);
                                          }

                                          return ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: allDates.length,
                                            itemBuilder: (context, i) {
                                              final date = allDates[i];
                                              final dateStr = DateFormat("yyyy-MM-dd").format(date);
                                              final item = priceMap[dateStr];

                                              // If item not found, mark unavailable (red)
                                              final isAvailable = item?.availability == true;

                                              return Container(
                                                margin: const EdgeInsets.only(right: 8),
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: isAvailable ? Colors.teal : Colors.red.shade300,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.calendar_today,
                                                      size: 8,
                                                      color: Colors.white.withOpacity(0.9),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      DateFormat("dd").format(date),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                      )
                                    ],
                                  )
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
