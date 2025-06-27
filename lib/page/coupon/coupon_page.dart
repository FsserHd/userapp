

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/constants/api_constants.dart';
import 'package:userapp/constants/app_colors.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/utils/validation_utils.dart';

import '../../constants/app_style.dart';
import '../../controller/cart_controller.dart';
import '../widget/customer_dot_container.dart';

class CouponPage extends StatefulWidget {
  double totalPrice;
  CouponPage(this.totalPrice, {super.key});

  @override
  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends StateMVC<CouponPage> {

  late CartController _con;

  _CouponPageState() : super(CartController()) {
    _con = controller as CartController;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.getCoupon(context);
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
        title: Text("Apply Coupon",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           _con.couponModel.data!=null ? ListView.builder(
                physics: NeverScrollableScrollPhysics(),shrinkWrap: true,itemCount:_con.couponModel.data!.length,itemBuilder: (context,index){
                  var couponBean = _con.couponModel.data![index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Flat",
                                  style: AppStyle.font18BoldWhite.override(fontSize: 14,color: Colors.grey),
                                ),
                                SizedBox(height: 2,),
                                couponBean.discountType=="1" ? Text(
                                  "${couponBean.discount}%",
                                  style: AppStyle.font18BoldWhite.override(fontSize: 14),
                                ):Text(
                                  ApiConstants.currency+"${couponBean.discount}",
                                  style: AppStyle.font18BoldWhite.override(fontSize: 14),
                                ),
                                SizedBox(height: 2,),
                                Text(
                                  "Offer",
                                  style: AppStyle.font18BoldWhite.override(fontSize: 14,color: AppColors.themeColor),
                                ),
                              ],
                            ),
                            SizedBox(width: 20,),
                            Image.asset("assets/images/line.png"),
                            SizedBox(width: 20,),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Coupon Code",
                                      style: AppStyle.font18BoldWhite.override(fontSize: 16,color: Colors.grey),
                                    ),
                                    SizedBox(width: 5,),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                        border: Border.all(
                                          color: Colors.grey, // Border color
                                          width: 2.0, // Border width
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Center(
                                          child: Text(
                                            '${couponBean.code}',
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                SizedBox(height: 5,),
                                Text(
                                  "${couponBean.title}",
                                  style: AppStyle.font18BoldWhite.override(fontSize: 14,color: Colors.black),
                                ),
                                SizedBox(height: 5,),
                                InkWell(
                                  onTap: (){
                                    print(widget.totalPrice);
                                    if(couponBean.discountType == "1")// Percentage
                                    {
                                      var discount = (widget.totalPrice * double.parse(couponBean.discount!))/100;
                                      if(discount<=widget.totalPrice){
                                        Navigator.pop(context,couponBean);
                                      }else{
                                        ValidationUtils.showAppToast("Coupon not valid");
                                      }
                                    }else{
                                      if(double.parse(couponBean.discount!) <= widget.totalPrice){
                                        Navigator.pop(context,couponBean);
                                      }else{
                                        ValidationUtils.showAppToast("Coupon not valid");
                                      }
                                    }

                                  },
                                  child: Container(
                                    width: 138,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: AppColors.themeColor, // Gray fill color
                                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                                    ),
                                    child: Center(
                                      child:   Text("Apply",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }):Container(),
          ],
        ),
      ),
    );
  }
}
