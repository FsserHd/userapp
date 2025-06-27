
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/model/service/service_response_model.dart';

import '../../../constants/api_constants.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_style.dart';
import '../../../controller/service_controller.dart';
import '../../../navigation/page_navigation.dart';



class ServiceDetailsPage extends StatefulWidget {
  Service serviceBean;

  ServiceDetailsPage(this.serviceBean, {super.key});

  @override
  _ServiceDetailsPageState createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends StateMVC<ServiceDetailsPage> {

  late ServiceController _con;

  _ServiceDetailsPageState() : super(ServiceController()) {
    _con = controller as ServiceController;
  }


  late GoogleMapController mapController;
  late LatLng _initialPosition = LatLng(double.parse(widget.serviceBean.fromLatitude!), double.parse(widget.serviceBean.fromLongitude!));
  late LatLng _desitinationPostion = LatLng(double.parse(widget.serviceBean.toLatitude!), double.parse(widget.serviceBean.toLongitude!));
  final _placesApiKey = 'AIzaSyAllf0gGdRTTog1ChI62srhdNZ-hVsEYe0'; // Replace with your API key
  final _geocoding = GoogleMapsGeocoding(apiKey: 'AIzaSyAllf0gGdRTTog1ChI62srhdNZ-hVsEYe0'); // Replace with your API key
  BitmapDescriptor? _customCustomerMarkerIcon;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _loadCustomerMarkerIcon() async {
    final customMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(100, 100)), // Adjust size as needed
      'assets/images/home.png',
    );
    setState(() {
      _customCustomerMarkerIcon = customMarker;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCustomerMarkerIcon();
    _con.getZoneInformation(context);
    if(widget.serviceBean.driverId!=null){
      _con.getDriverDetails(context, widget.serviceBean.driverId!);
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
        title: Text("Details",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              String orderId = "Service ID:"+widget.serviceBean.serviceCode!! +"\n\n"+"Hello 4square";
              PageNavigation.openWhatsApp(_con.zoneInformationModel.data![0].phone!,orderId);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/images/whatsapp.png",height: 35,width: 35,),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Service Details",style: AppStyle.font18BoldWhite.override(fontSize: 16,color: AppColors.themeColor),),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  border: Border.all(
                    color: Colors.grey.shade300, // Light gray border color
                    width: 2.0, // Border width
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.themeColor, // Background color
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0)), // Rounded corners
                        border: Border.all(
                          color: AppColors.themeColor, // Light gray border color
                          width: 2.0, // Border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center, // To align the texts to the start
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Order is ${widget.serviceBean.deliveryStatus!}",
                              maxLines: 1,overflow: TextOverflow.ellipsis,
                              style: AppStyle.font18BoldWhite.override(fontSize: 16,color: Colors.white),
                            ),
                            SizedBox(height: 2),
                          ],
                        ),
                      ),
                      width: double.infinity,
                    ),
                    Container(
                      height: 300,
                      child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          zoomGesturesEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target: _initialPosition,
                            zoom: 14.0,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId(""),
                              position: _initialPosition,
                              icon: _customCustomerMarkerIcon!,
                            ),
                            Marker(
                              markerId: MarkerId(""),
                              position: _desitinationPostion,
                              icon: _customCustomerMarkerIcon!,
                            ),
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Given Service Input:',
                    style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.black87),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.white, // Gray color fill
                      borderRadius: BorderRadius.circular(20), // Border radius
                      border: Border.all(
                        color: Colors.black87, // Border color
                        width: 1, // Border width
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.serviceBean.types!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyle.font14RegularBlack87.override(fontSize: 14),
                              ),
                            ),
                            SizedBox(width: 20,),
                            Image.asset("assets/images/p_location.png"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Gray color fill
                      borderRadius: BorderRadius.circular(10), // Border radius
                      border: Border.all(
                        color: AppColors.lightGray, // Border color
                        width: 1, // Border width
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded,color: AppColors.themeColor,),
                              SizedBox(width: 10,),
                              Text("From",style: AppStyle.font18BoldWhite.override(color: AppColors.themeColor),),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Text(widget.serviceBean.fromlocation!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Name",style: AppStyle.font18BoldWhite.override(color: Colors.grey,fontSize: 12),),
                                  Text(widget.serviceBean.fromname!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Mobile",style: AppStyle.font18BoldWhite.override(color: Colors.grey,fontSize: 12),),
                                  Text(widget.serviceBean.fphoneno!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Text("Date & Time: ${widget.serviceBean.fromtime}",style: AppStyle.font18BoldWhite.override(color: Colors.grey,fontSize: 12),),
                        ],),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Gray color fill
                      borderRadius: BorderRadius.circular(10), // Border radius
                      border: Border.all(
                        color: AppColors.lightGray, // Border color
                        width: 1, // Border width
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded,color: AppColors.themeColor,),
                              SizedBox(width: 10,),
                              Text("Shipping to",style: AppStyle.font18BoldWhite.override(color: AppColors.themeColor),),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Text(widget.serviceBean.tolocation!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Name",style: AppStyle.font18BoldWhite.override(color: Colors.grey,fontSize: 12),),
                                  Text(widget.serviceBean.toname!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Mobile",style: AppStyle.font18BoldWhite.override(color: Colors.grey,fontSize: 12),),
                                  Text(widget.serviceBean.tophoneno!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Text("Details:",style: AppStyle.font18BoldWhite.override(color: Colors.grey,fontSize: 12),),
                          Text(widget.serviceBean.description!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  SizedBox(height: 20,),
                  // Row(
                  //   children: [
                  //     Icon(Icons.location_on_rounded,color: Colors.grey,),
                  //     SizedBox(width: 10,),
                  //     Text("Types",style: AppStyle.font14MediumBlack87.override(color: Colors.grey),),
                  //   ],
                  // ),
                  // SizedBox(height: 5,),
                  // GridView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: widget.serviceBean.types!.length,
                  //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 3, // Number of columns
                  //     crossAxisSpacing: 4.0, // Horizontal spacing between items
                  //     mainAxisSpacing: 4.0, // Vertical spacing between items
                  //     childAspectRatio: 0.7, // Aspect ratio of each item
                  //   ),
                  //   itemBuilder: (context, index) {
                  //     var categoryBean = widget.serviceBean.types![index];
                  //
                  //     return Stack(
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Column(
                  //             children: [
                  //               Container(
                  //                 width: 100,
                  //                 height: 100,
                  //                 decoration: BoxDecoration(
                  //                   color: AppColors.dashboardShopTypeColor, // Gray background color
                  //                   borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  //                 ),
                  //                 padding: EdgeInsets.all(10.0), // Padding for inner content
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: AppColors.dashboardShopTypeColor, // White background color for inner container
                  //                     borderRadius: BorderRadius.circular(8.0), // Rounded corners for inner container
                  //                   ),
                  //                   padding: EdgeInsets.all(10.0), // Padding for icon
                  //                   child: Image.network(categoryBean.image!, height: 30, width: 30,),
                  //                 ),
                  //               ),
                  //               SizedBox(height: 10,),
                  //               Text(categoryBean.name!, style: AppStyle.font14MediumBlack87.override(color: Colors.black)),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // ),
                  Row(
                    children: [
                      Icon(Icons.description,color: AppColors.themeColor,),
                      SizedBox(width: 10,),
                      Text("Delivery Instruction",style: AppStyle.font18BoldWhite.override(color: AppColors.themeColor),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Text(widget.serviceBean.description!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 16),),
                  SizedBox(height: 10,),
                  _con.driverModel.data!=null ? Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person,color: Colors.grey,),
                          SizedBox(width: 10,),
                          Text("Driver Details",style: AppStyle.font14MediumBlack87.override(color: Colors.grey),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // Image.network(_con.driverModel.data!.image!,height: 100,width: 100,),
                              // SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_con.driverModel.data!.name!,style: AppStyle.font14MediumBlack87,),
                                  Text(_con.driverModel.data!.phone!,style: AppStyle.font14MediumBlack87,),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  FlutterPhoneDirectCaller.callNumber(_con.driverModel.data!.phone!);
                                },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.call),
                                  )),
                            ],
                          )
                        ],
                      )
                    ],
                  ):Container(),


                  SizedBox(height: 20,),
                  Text("Payment Details",style: TextStyle(color: AppColors.themeColor,fontFamily: AppStyle.robotoBold,fontSize: 16),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Distance",style: AppStyle.font14MediumBlack87.override(color: Colors.black),),
                      Text(widget.serviceBean.distance1!+" Km",style: AppStyle.font14MediumBlack87.override(color: Colors.black),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Service Charge",style: AppStyle.font14MediumBlack87.override(color: Colors.black),),
                      Text(ApiConstants.currency+widget.serviceBean.deliveryfees!,style: AppStyle.font14MediumBlack87.override(color: Colors.black),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Payment Mode",style: AppStyle.font14MediumBlack87.override(color: Colors.black),),
                      Text(widget.serviceBean.paymentMode!,style: AppStyle.font14MediumBlack87.override(color: Colors.black),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Divider(color: AppColors.lightGray,),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Grand Total",style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 16),),
                      Text(ApiConstants.currency+widget.serviceBean.deliveryfees!,style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 16),),
                    ],
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
