

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/constants/api_constants.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/model/home/home_model.dart';
import 'package:userapp/model/vendor/vendor_model.dart';
import 'package:userapp/navigation/page_navigation.dart';

import 'package:userapp/page/vendor/product_page.dart';
import 'package:userapp/utils/validation_utils.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/home_controller.dart';
import '../cart/check_out_page.dart';

class VendorProductPage extends StatefulWidget {
  static final GlobalKey<_VendorProductPageState> vendorPageKey = GlobalKey<_VendorProductPageState>();
  String vendorId;
  VendorData vendorBean;
  VendorProductPage(this.vendorId, this.vendorBean, {super.key});

  @override
  _VendorProductPageState createState() => _VendorProductPageState();
}

class _VendorProductPageState extends StateMVC<VendorProductPage> {

  late HomeController _con;

  _VendorProductPageState() : super(HomeController()) {
    _con = controller as HomeController;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.listCategoryProduct(widget.vendorId,"");
    _con.getAllCount();
    _con.getTotalPrice();
    _con.getDistance2(widget.vendorBean.generalDetail!.latitude!, widget.vendorBean.generalDetail!.longitude!);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: VendorProductPage.vendorPageKey,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PreferredSize(
                          preferredSize: Size.fromHeight(120), // Set this height
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget.vendorBean.logo!), // Use NetworkImage instead of Image.network
                                fit: BoxFit.cover, // Adjust as needed
                              ),
                              borderRadius: BorderRadius.circular(0.0), // Rounded corners
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 120,
                                      child: Icon(Icons.keyboard_backspace_rounded, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100,left: 30,right: 30,),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight:Radius.circular(10.0),bottomLeft: Radius.circular(0.0),bottomRight: Radius.circular(10.0) ), // Rounded corners
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
                                children: [
                                  ClipRRect(borderRadius:BorderRadius.circular(10.0),child: Image.network(widget.vendorBean.logo!,height: 50,width: 50,fit: BoxFit.fill,)),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // To center the texts vertically
                                      crossAxisAlignment: CrossAxisAlignment.start, // To align the texts to the start
                                      children: [
                                        Text(
                                          widget.vendorBean.generalDetail!.storeName!,
                                          style: AppStyle.font18BoldWhite.override(fontSize: 16),
                                        ),
                                        Text(
                                          widget.vendorBean.generalDetail!.subtitle!,
                                          maxLines: 1,
                                          style: AppStyle.font14MediumBlack87.override(fontSize: 12,color: Colors.grey),
                                        ),
                                        Container(
                                          width: 200,
                                          child: Text(
                                            widget.vendorBean.address1!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: AppStyle.font14MediumBlack87.override(fontSize: 12,color: Colors.grey),
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Image.asset("assets/images/bike.png"),
                                            SizedBox(width: 2,),
                                            Text(
                                              _con.distance+" distance",
                                              style: AppStyle.font14MediumBlack87.override(fontSize: 12,color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                       /* SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Image.asset("assets/images/clock.png"),
                                            SizedBox(width: 2,),
                                            Text(
                                              _con.duration+" delivery time",
                                              style: AppStyle.font14MediumBlack87.override(fontSize: 12,color: Colors.grey),
                                            ),
                                          ],
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _con.productModel.data != null ?
                  Expanded(
                    child: Stack(
                      children: [
                        DefaultTabController(
                          length: _con.productModel.data!.length,
                          child: Column(
                            children: [
                              TabBar(
                                isScrollable: true, // Make the TabBar scrollable
                                tabs: _con.productModel.data!.map((category) => Tab(text: category.categoryName)).toList(),
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: _con.productModel.data!.map((category) => ProductPage(category,_con,widget.vendorId)).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ):Container(
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/empty.png"),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 100,left: 10,right: 10,bottom: 10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.themeColor, // Background color
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight:Radius.circular(10.0),bottomLeft: Radius.circular(10.0),bottomRight: Radius.circular(10.0) ), // Rounded corners
                  border: Border.all(
                    color: AppColors.themeColor, // Light gray border color
                    width: 2.0, // Border width
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${_con.cartCount} Item",
                            style: AppStyle.font14RegularBlack87.override(fontSize: 16,color: Colors.white),
                          ),
                          SizedBox(width: 10,),
                          Text(
                            "|",
                            style: AppStyle.font14RegularBlack87.override(fontSize: 16,color: Colors.white),
                          ),
                          SizedBox(width: 10,),
                          Text(
                            ApiConstants.currency+_con.totalPrice.toString(),
                            style: AppStyle.font14RegularBlack87.override(fontSize: 16,color: Colors.white),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: (){
                          _con.dbHelper.getCartCount().then((value){
                            if(value!>0){
                              //PageNavigation.gotoCheckOutPage(context,onCallBack: _con.listCategoryProduct(widget.vendorId, ""));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckOutPage(),
                                ),
                              ).then((value){
                                _con.listCategoryProduct(widget.vendorId, "");
                                _con.getAllCount();
                                _con.getTotalPrice();
                              });
                            }else{
                              ValidationUtils.showAppToast("Cart is empty");
                            }
                          });

                        },
                        child: Row(
                          children: [
                            Text(
                              "View Cart",
                              style: AppStyle.font14RegularBlack87.override(fontSize: 16,color: Colors.white),
                            ),
                            SizedBox(width: 5,),
                            Icon(Icons.shopping_cart,color: Colors.white,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
