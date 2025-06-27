

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/constants/api_constants.dart';
import 'package:userapp/constants/app_colors.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/navigation/page_navigation.dart';
import 'package:userapp/utils/time_utils.dart';
import 'package:userapp/utils/validation_utils.dart';

import '../../../constants/app_style.dart';
import '../../../controller/service_controller.dart';

class MyServicePage extends StatefulWidget {
  const MyServicePage({super.key});

  @override
  _MyServicePageState createState() => _MyServicePageState();
}

class _MyServicePageState extends StateMVC<MyServicePage> {

  late ServiceController _con;

  _MyServicePageState() : super(ServiceController()) {
    _con = controller as ServiceController;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.listService(context);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _con.listService(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _con.serviceResponseModel.data!=null ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
          itemCount: _con.serviceResponseModel.data!.length,
          itemBuilder: (context,index){
          var serviceBean = _con.serviceResponseModel.data![index];
        return InkWell(
          onTap: (){
            PageNavigation.gotoServiceDetailsPage(context,serviceBean);
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  serviceBean.serviceCode!,
                                  style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.black87),
                                ),
                                Text(
                                  serviceBean.createdAt!,
                                  style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                            Text(
                              ApiConstants.currency+serviceBean.deliveryfees!,
                              style: AppStyle.font18BoldWhite.override(fontSize: 14),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey.shade500,
                        ),
                        Text(
                          "From",
                          style: AppStyle.font14MediumBlack87.override(fontSize: 10,color: Colors.grey.shade500),
                        ),
                        SizedBox(height: 2,),
                        Text(
                          serviceBean.fromlocation!,maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyle.font18BoldWhite.override(fontSize: 12),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "To",
                          style: AppStyle.font14MediumBlack87.override(fontSize: 10,color: Colors.grey.shade500),
                        ),
                        SizedBox(height: 2,),
                        Text(
                          serviceBean.tolocation!,maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyle.font18BoldWhite.override(fontSize: 12),
                        ),

                        Divider(
                          color: Colors.grey.shade500,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "OTP:"+serviceBean.otp!,
                              style: AppStyle.font18BoldWhite.override(fontSize: 14,color: Colors.green),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: serviceBean.deliveryStatus! =="Placed" ? Colors.blueAccent
                                    :serviceBean.deliveryStatus! =="Picked" ? Colors.orange :
                                serviceBean.deliveryStatus! =="InTransit" ? Colors.deepPurple:
                                serviceBean.deliveryStatus! =="Delivered"? Colors.green:
                                serviceBean.deliveryStatus! =="Cancelled"? Colors.red:
                                Colors.blueAccent , // Background color
                                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                              ),
                              child: Text(
                                serviceBean.deliveryStatus=="Rejected" ? "Placed" :serviceBean.deliveryStatus!,
                                style: AppStyle.font14MediumBlack87.override(fontSize: 12,color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    ):ValidationUtils.showEmptyPage("No Service found", "assets/images/empty.png");
  }
}
