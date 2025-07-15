

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:userapp/constants/api_constants.dart';
import 'package:userapp/controller/home_controller.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/model/coupon/coupon_model.dart';
import 'package:userapp/navigation/page_navigation.dart';
import 'package:userapp/page/vendor/vendor_product_page.dart';
import 'package:userapp/utils/preference_utils.dart';
import 'package:userapp/utils/validation_utils.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/cart_controller.dart';
import '../auth/login/inside_login_page.dart';
import '../widget/customer_dot_container.dart';

class CheckOutPage extends StatefulWidget {



  CheckOutPage({super.key});

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends StateMVC<CheckOutPage> with SingleTickerProviderStateMixin {

  late CartController _con;
  String paymentMode = "Select";

  _CheckOutPageState() : super(CartController()) {
    _con = controller as CartController;
  }

  String? location = "";

  int selectedValue = 0;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.getAllCartProducts();
    _con.getProfile(context);
    _con.getDeliveryTips(context);
    //_con.getTotalPrice();
    PreferenceUtils.getLocation().then((value){
      setState(() {
        location = value;
      });
    });


  }



  void _showInvalidZoneBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 240,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Address',
                style: AppStyle.font14MediumBlack87..override(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                location!,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Current not delivery this location',
                  style: AppStyle.font14MediumBlack87..override(fontSize: 14,color: Colors.red),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: (){
                 // _con.createOrder(context);
                  Navigator.pop(context);
                  PageNavigation.gotoAddressPage(context,"cart").then((value){
                    print(_con.vendorDetailsModel.data!.toJson());
                    PreferenceUtils.getZoneId().then((zoneId) {
                      if(zoneId == _con.vendorDetailsModel.data!.zoneId){
                        PreferenceUtils.getLocation().then((value){
                          setState(() {
                            location = value;
                            _con.getAllCartProducts();
                          });
                        });
                      }else{
                        _showInvalidZoneBottomSheet(context);
                      }
                    });
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.themeColor, // Gray fill color
                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  ),
                  child: Center(
                    child:   Text("Change Location",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
        title: Text("Check Out",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            _con.vendorDetailsModel.data!=null ? Row(
                              children: [
                                ClipRRect(
                                    child: Image.network(_con.vendorDetailsModel.data!.logo!, height: 50, width: 50),borderRadius: BorderRadius.circular(10.0),),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _con.vendorDetailsModel.data!.company!,
                                        style: AppStyle.font14MediumBlack87.override(fontSize: 14),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        _con.vendorDetailsModel.data!.displayName!,
                                        style: AppStyle.font14MediumBlack87.override(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ):Container(),
                            SizedBox(height: 20),
                            ListView.builder(
                              itemCount: _con.cartList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, pIndex) {
                                var cartBean = _con.cartList[pIndex];
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CustomPaint(
                                    painter: DottedBorderPainter(
                                      color: Colors.grey,
                                      strokeWidth: 2,
                                      dashWidth: 5,
                                      dashSpace: 3,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(width: 5),
                                                Container(
                                                  width: 100,
                                                  child: Text(cartBean.productName!,maxLines: 1,overflow: TextOverflow.ellipsis,
                                                      style: AppStyle.font14MediumBlack87.override(fontSize: 10)),
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(color: Colors.white, width: 1),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(4.0),
                                                          child: Icon(
                                                            Icons.remove,
                                                            size: 10,
                                                            color: AppColors.themeColor,
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          if (cartBean.qty! > 0) {
                                                            setState(() {
                                                              cartBean.qty = cartBean.qty! - 1;
                                                              _con.isCouponApplied = false;
                                                              _con.discount = 0.0;
                                                            });
                                                          }
                                                          //_con.updateProduct(int.parse(cartBean.id!), cartBean.qty!);
                                                          _con.updateProduct(int.parse(cartBean.id!), cartBean.qty!,"cart");

                                                        },
                                                      ),
                                                      SizedBox(width: 20),
                                                      Text(
                                                        "${cartBean.qty}",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: AppColors.themeColor),
                                                      ),
                                                      SizedBox(width: 20),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            cartBean.qty = cartBean.qty! + 1;
                                                            _con.isCouponApplied = false;
                                                            _con.discount = 0.0;
                                                          });
                                                          _con.updateProduct(int.parse(cartBean.id!), cartBean.qty!,"cart");
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(4.0),
                                                          child: Icon(
                                                            Icons.add,
                                                            size: 10,
                                                            color: AppColors.themeColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(ApiConstants.currency + cartBean.price!,
                                                    style: AppStyle.font14MediumBlack87.override(fontSize: 10)),
                                                SizedBox(width: 5),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 10),

                            Container(
                              height: 42,
                              child: TextField(
                                controller: _con.instructionController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  hintText: 'Write instruction',
                                  hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 12),
                                  prefixIcon: Icon(Icons.message,color: Colors.red,size: 16,), // Add the icon inside the TextField
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _con.addOnList.isNotEmpty ?  SizedBox(height: 20,):Container(),
                    _con.addOnList.isNotEmpty ?  Text("Add On",style: AppStyle.font18BoldWhite.override(fontSize: 16),):Container(),
                    _con.addOnList.isNotEmpty ?  SizedBox(height: 10,):Container(),
                    _con.addOnList.isNotEmpty ?  Container(
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
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _con.addOnList.length,
                            itemBuilder: (context,index){
                              var addOn  = _con.addOnList[index];
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CustomPaint(
                                  painter: DottedBorderPainter(
                                    color: Colors.grey,
                                    strokeWidth: 2,
                                    dashWidth: 5,
                                    dashSpace: 3,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: 5),
                                              Container(
                                                width: 100,
                                                child: Text(addOn.name!,maxLines: 1,overflow: TextOverflow.ellipsis,
                                                    style: AppStyle.font14MediumBlack87.override(fontSize: 10)),
                                              ),
                                              addOn.qty!=0 ? Container(
                                                height: 30,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: Colors.white, width: 1),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    InkWell(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: 10,
                                                          color: AppColors.themeColor,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        if (addOn.qty! > 0) {
                                                          setState(() {
                                                            addOn.qty = addOn.qty! - 1;
                                                          });
                                                        }
                                                        _con.updateAddOnProduct(addOn.addonId!, addOn.qty!,addOn);
                                                        //_con.updateProduct(int.parse(cartBean.id!), cartBean.qty!);
                                                       // _con.updateProduct(int.parse(cartBean.id!), cartBean.qty!,"cart");

                                                      },
                                                    ),
                                                    SizedBox(width: 20),
                                                    Text(
                                                      "${addOn.qty}",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: AppColors.themeColor),
                                                    ),
                                                    SizedBox(width: 20),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          addOn.qty = addOn.qty! + 1;
                                                        });
                                                        _con.updateAddOnProduct(addOn.addonId!, addOn.qty!,addOn);

                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 10,
                                                          color: AppColors.themeColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ):InkWell(
                                                onTap: (){
                                                    setState(() {
                                                      addOn.qty = addOn.qty! + 1;
                                                    });
                                                    _con.updateAddOnProduct(addOn.addonId!, addOn.qty!,addOn);
                                                 },
                                                child: Container(
                                                  height: 30,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(color: AppColors.themeColor, width: 1),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text(
                                                        "Add",
                                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.themeColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Text(ApiConstants.currency + addOn.price!,
                                                  style: AppStyle.font14MediumBlack87.override(fontSize: 10)),
                                              SizedBox(width: 5),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ):Container(),
                    SizedBox(height: 20),
                    Text(
                      "Offers & Benefits",
                      style: AppStyle.font18BoldWhite.override(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Container(
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
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                !_con.isCouponApplied ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Coupon Code",
                                            style: AppStyle.font18BoldWhite.override(fontSize: 16),
                                          ),
                                          SizedBox(width: 10,),
                                          Image.asset("assets/images/coupon.png"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ):Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _con.coupon.discountType ==  "1" ? "Flat %${_con.coupon.discount} Offer": "Flat ${ApiConstants.currency+_con.coupon.discount!} Offer",
                                                style: AppStyle.font18BoldWhite.override(fontSize: 14,color: Colors.green),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 10,),
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                _con.isCouponApplied = false;
                                                _con.discount = 0.0;
                                                _con.getTotalPrice();
                                              });
                                            },
                                              child: Icon(Icons.close,color: Colors.red,)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: (){
                                    PageNavigation.gotoCouponPage(context,_con.allTotalPrice).then((value) async{
                                       if(value!=null) {
                                         _con.coupon = value;
                                         if(double.parse(_con.coupon.minimumPurchasedAmount!)<=_con.allTotalPrice){
                                           setState(() {
                                             _con.isCouponApplied = true;
                                           });
                                           _con.getCouponPrice();
                                         }else{
                                           ValidationUtils.showAppToast("Minimum purchase amount ${ApiConstants.currency+_con.coupon.minimumPurchasedAmount!}");
                                         }
                                       }
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "View Coupon",
                                          style: AppStyle.font18BoldWhite.override(fontSize: 16, color: AppColors.themeColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tip Your Delivery Partner",
                              style: AppStyle.font18BoldWhite.override(fontSize: 16),
                            ),
                            Text(
                              "Thank you for paying delivery partner....",
                              style: AppStyle.font18BoldWhite.override(fontSize: 14),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              height: 45, // Adjust the height as needed
                              padding: EdgeInsets.all(4.0),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _con.tipsValues.length,
                                itemBuilder: (context, index) {
                                  int value = _con.tipsValues[index];
                                  bool isSelected = value == selectedValue;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedValue = value;
                                        _con.tips = value;
                                        _con.getTotalPrice();
                                      });
                                    },
                                    child: Container(
                                      width: 45,
                                      height: 45,
                                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: isSelected ? Colors.lightBlue : Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          value.toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Image.asset("assets/images/address_home.png"),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Delivery Location",
                                          style: AppStyle.font18BoldWhite.override(fontSize: 14),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          width: 200,
                                          child: Text(
                                            "$location",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppStyle.font18BoldWhite.override(fontSize: 14, color: Colors.grey[500]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  PageNavigation.gotoAddressPage(context,"cart").then((value){
                                    PreferenceUtils.getZoneId().then((zoneId) {
                                      if(zoneId == _con.vendorDetailsModel.data!.zoneId){
                                        PreferenceUtils.getLocation().then((value){
                                          setState(() {
                                            location = value;
                                            _con.getAllCartProducts();
                                          });
                                        });
                                      }else{
                                        _showInvalidZoneBottomSheet(context);
                                      }
                                    });
                                  });
                                },
                                child: Icon(Icons.edit, color: AppColors.themeColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Bill Details",
                                    style: AppStyle.font18BoldWhite.override(fontSize: 16),
                                  ),
                                ),
                                SizedBox(height: 0),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Item Total",
                                        style: AppStyle.font14MediumBlack87.override(fontSize: 14),
                                      ),
                                      Text(
                                          ApiConstants.currency +
                                              (_con.totalPrice.round() + _con.addOnPrice.round())
                                                  .toString(),
                                        style: AppStyle.font14MediumBlack87.override(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Delivery Fees | ${_con.distance}",
                                        style: AppStyle.font14MediumBlack87.override(fontSize: 14),
                                      ),
                                      Text(
                                        ApiConstants.currency + _con.deliveryFees.round().toString(),
                                        style: AppStyle.font14MediumBlack87.override(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Tax",
                                        style: AppStyle.font14MediumBlack87.override(fontSize: 14),
                                      ),
                                      Text(
                                        ApiConstants.currency + _con.tax.round().toString(),
                                        style: AppStyle.font14MediumBlack87.override(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Packing Charge",
                                        style: AppStyle.font14MediumBlack87.override(fontSize: 14),
                                      ),
                                      Text(
                                        ApiConstants.currency + _con.packingCharges.round().toString(),
                                        style: AppStyle.font14MediumBlack87.override(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                _con.isCouponApplied ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Discount",
                                        style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.green),
                                      ),
                                      Text(
                                        "-"+ApiConstants.currency + _con.discount.round().toString(),
                                        style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ):Container(),
                                _con.isVendorDiscount ? _con.vendorDiscount.round()!=0 ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Shop Discount",
                                        style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.green),
                                      ),
                                      Text(
                                        "-"+ApiConstants.currency + _con.vendorDiscount.round().toString(),
                                        style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ):Container():Container(),
                                _con.tips!=0 ?Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Tips",
                                            style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.orange),
                                          ),

                                          SizedBox(width: 5,),
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                _con.tips = 0;
                                                _con.getTotalPrice();
                                                selectedValue = 0;
                                              });
                                            },
                                            child: Text(
                                              "(Remove)",
                                              style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.red,decoration: TextDecoration.underline),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        ApiConstants.currency + _con.tips.toString(),
                                        style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.orange),
                                      ),
                                    ],
                                  ),
                                ):Container(),
                                SizedBox(height: 10),
                                Divider(
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "To pay:",
                                        style: AppStyle.font14MediumBlack87.override(fontSize: 14),
                                      ),
                                      Text(
                                        ApiConstants.currency + _con.allTotalPrice.round().toString(),
                                        style: AppStyle.font14MediumBlack87.override(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        PageNavigation.gotoTermsConditions(context);
                      },
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
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Row(
                                      children: [
                                        SizedBox(height: 10,),
                                        Icon(Icons.policy,color: Colors.red,size: 14,),
                                        SizedBox(width: 5,),
                                        Text(
                                          "Terms And Conditions",
                                          style: AppStyle.font18BoldWhite.override(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.arrow_right,color: Colors.red,size: 14,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.themeColor,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/images/cod.png",height: 40,width: 30,),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: (){
                            PageNavigation.gotoPaymentPage(context,_con).then((value){
                              if(value == "cod"){
                                setState(() { paymentMode = "COD";});
                              }else if(value == "wallet"){
                                setState(() { paymentMode = "Wallet";});
                              }else if(value == "online"){
                                setState(() { paymentMode = "Online";});
                              }
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pay Using",
                                        style: AppStyle.font18BoldWhite.override(fontSize: 12,color: Colors.white),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        "$paymentMode",
                                        style: AppStyle.font18BoldWhite.override(fontSize: 14, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.arrow_drop_down),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        String?  userId = await PreferenceUtils.getUserId();
                        if(userId ==null){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InsideLoginPage(),
                            ),
                          );
                        }else {
                          if (paymentMode == "Select") {
                            PageNavigation.gotoPaymentPage(context, _con).then((
                                value) {
                              if (value == "cod") {
                                setState(() {
                                  paymentMode = "COD";
                                });
                              } else if (value == "wallet") {
                                setState(() {
                                  paymentMode = "Wallet";
                                });
                              } else if (value == "online") {
                                setState(() {
                                  paymentMode = "Online";
                                });
                              }
                            });
                          } else {
                            _con.createOrderId(
                                context, _con.allTotalPrice.toString(),
                                location, _con);
                          }
                        }
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color
                          borderRadius: BorderRadius.circular(15.0), // Rounded corners
                          border: Border.all(
                            color: Colors.grey.shade300, // Light gray border color
                            width: 2.0, // Border width
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Pay now",
                            style: AppStyle.font14MediumBlack87.override(color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class ProgressBarBottomSheet extends StatefulWidget {
  String location;
  CartController con;
  String? id;
  ProgressBarBottomSheet(this.location,this.con,this.id);

  @override
  _ProgressBarBottomSheetState createState() => _ProgressBarBottomSheetState();
}

class _ProgressBarBottomSheetState extends State<ProgressBarBottomSheet> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;
  var razorpay = Razorpay();


  void handlePaymentErrorResponse(PaymentFailureResponse response){
    Navigator.pop(context);
    ValidationUtils.showAppToast("Payment Cancelled");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){
   // showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
    widget.con.createOrder(context);
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    Navigator.pop(context);
    ValidationUtils.showAppToast("External Wallet Selected, ${response.walletName}");
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
        if(widget.con.checkOut.payment.paymentType == "online"){
          String? phone =await PreferenceUtils.getUserPhone();
          var options = {
            'key': 'rzp_live_Qdir89rIuPxK1S',
            'amount': widget.con.allTotalPrice * 100,
            'name': '',
            'order_id':widget.id,
            'description': 'Online Payment',
            'retry': {'enabled': true, 'max_count': 1},
            'send_sms_hash': true,
            'prefill': {'contact': '${phone}'},
            'external': {
              'wallets': ['paytm']
            }
          };
          razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
          razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
          razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
          razorpay.open(options);
        }else {
          widget.con.createOrder(context);
        }
        }
      });

    _animationController?.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Address',
            style: AppStyle.font14MediumBlack87..override(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            widget.location!,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10,),
          Text(
            'Grand Total',
            style: AppStyle.font14MediumBlack87..override(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            ApiConstants.currency+widget.con.allTotalPrice.round().toString(),
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            'Payment Mode',
            style: AppStyle.font14MediumBlack87..override(fontSize: 18),
          ),
          SizedBox(height: 10),
          widget.con.checkOut.payment.paymentType == "online" ? Text(
            "Online",
            style: TextStyle(fontSize: 16),
          ):widget.con.checkOut.payment.paymentType == "cod" ? Text(
            "Cash on Delivery",
            style: TextStyle(fontSize: 16),
          ): Text(
            "Wallet",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.themeColor, // Gray fill color
                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: LinearProgressIndicator(
                      value: _animation!.value,
                      minHeight: 10,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5,),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.red, // Gray fill color
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  ),
                  child: Center(
                    child:   Text("Cancel",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(width: 5,),
            ],
          ),
          SizedBox(height: 20),

        ],
      ),
    );
  }
}
