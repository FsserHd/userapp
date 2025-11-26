


import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/constants/api_constants.dart';
import 'package:userapp/controller/hotel_controller.dart';
import 'package:userapp/model/hotel/booking_request.dart';
import 'package:userapp/model/hotel/hotel_response.dart';
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip("Price", Icons.currency_rupee, onTap: () {
                        // open price filter modal
                        _showPriceFilterSheet(context);
                      }),
                      const SizedBox(width: 8),
                      _buildFilterChip("Rating", Icons.star, onTap: () {
                        // open rating filter modal
                        _showRatingFilterSheet(context);
                      }),
                      const SizedBox(width: 8),
                      _buildFilterChip("Distance", Icons.place_outlined, onTap: () {
                        showDistanceFilterSheet(context);
                      }),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _con.hotelList.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var hotel = _con.hotelList[index];

                  return InkWell(
                    onTap: () {
                      PageNavigation.gotoHotelVendorDetailsPage(
                        context,
                        hotel,
                        widget.bookingRequest,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Image Section with Gradient & Favorite Icon ---
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: Image.network(
                                  hotel.logo!,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Gradient overlay for text readability
                              Container(
                                height: 180,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.1),
                                      Colors.black.withOpacity(0.4),
                                    ],
                                  ),
                                ),
                              ),
                              // Favorite Button
                         /*     Positioned(
                                top: 12,
                                right: 12,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(40),
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.85),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.favorite_border,
                                      size: 20,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),*/
                            ],
                          ),

                          // --- Info Section ---
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Hotel name + rating
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        hotel.title ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.star_rounded,
                                            color: Colors.amber, size: 18),
                                        const SizedBox(width: 3),
                                        Text(
                                          hotel.stars?.toString() ?? '0',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                // Location
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        hotel.address ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                // Price + Badge
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "${ApiConstants.currency}${hotel.minPrice}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text(
                                          "/ night",
                                          style: TextStyle(
                                              fontSize: 13, color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.teal.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "${hotel.distance ?? 'Nearby'}",
                                        style: const TextStyle(
                                          color: Colors.teal,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
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
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.teal),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPriceFilterSheet(BuildContext context) {
    // Load saved values from controller
    double selectedMin = _con.selectedMin;
    double selectedMax = _con.selectedMax;
    String selectedSort = _con.selectedSort;

    double minPrice = 0;
    double maxPrice = 10000;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  /// Title + Clear button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Filter by Price",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedSort = "Low to High";
                            selectedMin = 0;
                            selectedMax = 5000;
                          });

                          _con.clearPriceFilters(context); // Reset logic in controller
                        },
                        child: const Text(
                          "Clear",
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔽 Sort options
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text("Low to High"),
                        selected: selectedSort == "Low to High",
                        selectedColor: Colors.teal.shade50,
                        onSelected: (_) => setState(() => selectedSort = "Low to High"),
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text("High to Low"),
                        selected: selectedSort == "High to Low",
                        selectedColor: Colors.teal.shade50,
                        onSelected: (_) => setState(() => selectedSort = "High to Low"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text("Price Range (₹)",
                      style: TextStyle(fontWeight: FontWeight.w600)),

                  RangeSlider(
                    values: RangeValues(selectedMin, selectedMax),
                    min: minPrice,
                    max: maxPrice,
                    divisions: 100,
                    activeColor: Colors.teal,
                    labels: RangeLabels(
                      "₹${selectedMin.round()}",
                      "₹${selectedMax.round()}",
                    ),
                    onChanged: (values) {
                      setState(() {
                        selectedMin = values.start;
                        selectedMax = values.end;
                      });
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("₹${selectedMin.round()}"),
                      Text("₹${selectedMax.round()}"),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // APPLY BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        // Save values
                        _con.selectedSort = selectedSort;
                        _con.selectedMin = selectedMin;
                        _con.selectedMax = selectedMax;

                        // Apply filter
                        _con.applyPriceFilter(selectedSort, selectedMin, selectedMax);

                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Apply Filter",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showRatingFilterSheet(BuildContext context) {
    // ⭐ Always use ALL hotel list for rating options
    final ratingCount = <int, int>{};

    for (var h in _con.allHotelList) {
      if (h.stars != null) {
        ratingCount[h.stars!] = (ratingCount[h.stars!] ?? 0) + 1;
      }
    }

    final ratingOptions = ratingCount.entries.map((e) {
      return {
        "label": "${e.key} Star",
        "count": e.value,
        "value": e.key,
      };
    }).toList()
      ..sort((a, b) => ((b["value"] ?? 0) as int).compareTo((a["value"] ?? 0) as int));

    // load saved selected stars
    List<int> selectedRatings = List.from(_con.selectedRatings);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  /// Title + Clear button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Filter by Rating",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedRatings.clear();
                          });
                          _con.clearRatingFilter(context);
                        },
                        child: const Text("Clear",
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ⭐ Rating options
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ratingOptions.length,
                    itemBuilder: (context, index) {
                      final item = ratingOptions[index];
                      final ratingValue = item["value"] as int;
                      final isSelected = selectedRatings.contains(ratingValue);

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.star,
                          color: isSelected ? Colors.amber : Colors.grey,
                        ),
                        title: Text("${item["label"]} (${item["count"]})"),
                        trailing: Checkbox(
                          value: isSelected,
                          activeColor: Colors.teal,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                selectedRatings.add(ratingValue);
                              } else {
                                selectedRatings.remove(ratingValue);
                              }
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedRatings.remove(ratingValue);
                            } else {
                              selectedRatings.add(ratingValue);
                            }
                          });
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Apply button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        _con.selectedRatings = List.from(selectedRatings);
                        _con.applyRatingFilter();
                        Navigator.pop(context);
                      },
                      child: const Text("Apply Filter",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }



  void showDistanceFilterSheet(BuildContext context) {
    // Load saved values
    double minDistance = _con.selectedMinDistance;
    double maxDistance = _con.selectedMaxDistance;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  /// Title + Clear button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Filter by Distance",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),

                      TextButton(
                        onPressed: () {
                          setState(() {
                            minDistance = 0;
                            maxDistance = 100;
                          });
                          _con.clearDistanceFilter(context);
                        },
                        child: const Text(
                          "Clear",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Range Slider
                  RangeSlider(
                    values: RangeValues(minDistance, maxDistance),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    activeColor: Colors.teal,
                    labels: RangeLabels(
                      "${minDistance.round()} km",
                      "${maxDistance.round()} km",
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        minDistance = values.start;
                        maxDistance = values.end;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      "Selected Range: ${minDistance.round()} km - ${maxDistance.round()} km",
                      style:
                      const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// APPLY BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _con.applyDistanceFilter(
                            minDistance, maxDistance);
                      },
                      child: const Text(
                        "Apply Filter",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }






}
