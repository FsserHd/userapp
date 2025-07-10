

import 'dart:async';

import 'package:basic_utils/basic_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/constants/api_constants.dart';
import 'package:userapp/constants/app_colors.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/model/order/order_model.dart';
import 'package:userapp/navigation/page_navigation.dart';
import 'package:userapp/utils/time_utils.dart';
import 'package:userapp/utils/validation_utils.dart';

import '../../../constants/app_style.dart';
import '../../../controller/home_controller.dart';
import '../../widget/customer_dot_container.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends StateMVC<MyOrderPage> {

  late HomeController _con;

  _MyOrderPageState() : super(HomeController()) {
    _con = controller as HomeController;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.getMyOrders(context);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _con.getMyOrders(context);
    });
  }

  DateTime? cookingEndTime;
  late Timer _timer;

  void _startTimer(DateTime cookingEndTime, Data orderBean) {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        orderBean.remainingTime = cookingEndTime.difference(DateTime.now());
        orderBean.isCooking = true;
        if (orderBean.remainingTime.isNegative) {
          timer.cancel();
          orderBean.isCooking = false;
        }
      });

    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: _con.orderModel.data != null ?ListView.builder(
          itemCount: _con.orderModel.data!.length,
            shrinkWrap: true,
            itemBuilder: (context,index){
            var orderBean = _con.orderModel.data![index];
            if(orderBean.cookingtime!="" && orderBean.cookingtime!.isNotEmpty) {
              cookingEndTime = DateTime.parse(orderBean.cookingtime!);
              _startTimer(cookingEndTime!,orderBean);
            }
          return  InkWell(
            onTap: (){
              PageNavigation.gotoOrderDetailsPage(context,orderBean.saleCode!);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  border: Border.all(
                    color: Colors.grey.shade300, // Light gray border color
                    width: 2.0, // Border width
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                    child: Image.network(orderBean.logo!,height: 40,width: 40,fit: BoxFit.fill,)),
                                SizedBox(width: 4,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 200,
                                      child: Text(
                                        orderBean.vendor!.storeName!,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyle.font18BoldWhite.override(fontSize: 14),
                                      ),
                                    ),
                                    orderBean.vendor!.address!=null ? Container(
                                      width: 200,
                                      child: Text(
                                        orderBean.vendor!.address!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyle.font18BoldWhite.override(fontSize: 10),
                                      ),
                                    ):Container(),
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10,right: 5),
                              child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: orderBean.deliveryState == null ? Color(0XFF1C539A):
                                    orderBean.deliveryState== "on_track" || orderBean.deliveryState== "on_ready" ? Color(0XFFEDDF3F):
                                    orderBean.deliveryState== "on_picked" ? Color(0XFFF56C18):
                                    orderBean.deliveryState== "on_reached" ? Color(0XFF574fa0): // Background color
                                    orderBean.deliveryState== "on_finish" ? Color(0XFF184B20):
                                    orderBean.deliveryState== "on_cancel" && orderBean.status == "Cancelled" ?Color(0XFF7E1C29):Color(0XFFEDDF3F),// Background color
                                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                  ),
                                  child: orderBean.deliveryState== null ? Text(
                                    "PLACED",
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 10.0, // Text size
                                      fontWeight: FontWeight.bold, // Text style
                                    ),
                                  ):orderBean.deliveryState== "on_track" || orderBean.deliveryState== "on_ready" ? Text(
                                    "PREPARING",
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 10.0, // Text size
                                      fontWeight: FontWeight.bold, // Text style
                                    ),
                                  ):orderBean.deliveryState== "on_picked" ? Text(
                                    "SHIPPED",
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 10.0, // Text size
                                      fontWeight: FontWeight.bold, // Text style
                                    ),
                                  ):orderBean.deliveryState== "on_reached" ? Text(
                                    "REACHED",
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 10.0, // Text size
                                      fontWeight: FontWeight.bold, // Text style
                                    ),
                                  ):orderBean.deliveryState== "on_finish" ? Text(
                                    "COMPLETED",
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 10.0, // Text size
                                      fontWeight: FontWeight.bold, // Text style
                                    ),
                                  ):orderBean.deliveryState== "on_cancel" && orderBean.status == "Cancelled" ? Text(
                                    "CANCELED",
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 10.0, // Text size
                                      fontWeight: FontWeight.bold, // Text style
                                    ),
                                  ):orderBean.status == "Cancelled" ? Text(
                                    "CANCELED",
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 10.0, // Text size
                                      fontWeight: FontWeight.bold, // Text style
                                    ),
                                  ):Text(
                                    "PREPARING",
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 10.0, // Text size
                                      fontWeight: FontWeight.bold, // Text style
                                    ),
                                  )
                              ),
                            )
                          ],
                        ),
                        Text("..........     Order Details    ..........",style: AppStyle.font14RegularBlack87.override(fontSize: 12,color: AppColors.themeColor),),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: orderBean.productDetails!.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context,pIndex){
                                  var productBean = orderBean.productDetails![pIndex];
                                  return Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Row(
                                      children: [
                                        Image.asset("assets/images/non_veg.png",height: 12,width: 12,),
                                        SizedBox(width: 5,),
                                        Row(
                                          children: [
                                            Text(productBean.qty.toString()+"x",style  : AppStyle.font14MediumBlack87.override(fontSize: 10,color: Colors.grey),),
                                            SizedBox(width: 5,),
                                            Text(productBean.productName!,maxLines: 1,overflow: TextOverflow.ellipsis,style  : AppStyle.font14MediumBlack87.override(fontSize: 10),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                          Text(ApiConstants.currency+orderBean.grandTotal.toString(),style  : AppStyle.font18BoldWhite.override(fontSize: 16),),
                        ],
                      ),
                      Divider(color: Colors.grey[250],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order Id: #${orderBean.saleCode}",
                            style: AppStyle.font18BoldWhite.override(fontSize: 12),
                          ),
                          Text(
                            TimeUtils.getTimeStampToDate(int.parse(orderBean.paymentTimestamp!)),
                            style: AppStyle.font14RegularBlack87.override(fontSize: 10,color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Payment mode: ${orderBean.paymentType!.toUpperCase()}",
                            style: AppStyle.font18BoldWhite.override(fontSize: 12,color: Colors.orange),
                          ),

                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "OTP: ${orderBean.otp}",
                            style: AppStyle.font18BoldWhite.override(fontSize: 14,color: AppColors.themeColor),
                          ),
                          orderBean.deliveryState== "on_track" && orderBean.isCooking == true ? Text(
                            'Prepare Time: ${formatDuration(orderBean.remainingTime)}',
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ):Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          );
        }):ValidationUtils.showEmptyPage("No Orders found", "assets/images/empty.png"),
      ),
    );
  }
}
