


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/page/grocery/grocery_product.dart';

import '../../constants/api_constants.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/home_controller.dart';
import '../../model/home/home_model.dart';
import '../../navigation/page_navigation.dart';
import '../cart/check_out_page.dart';
import '../vendor/product_page.dart';

class GroceryProductPage extends StatefulWidget {
  String vendorId;
  VendorData vendorBean;
  String categoryId;
  GroceryProductPage(this.vendorId, this.vendorBean, this.categoryId,{super.key});

  @override
  _GroceryProductPageState createState() => _GroceryProductPageState();
}

class _GroceryProductPageState extends StateMVC<GroceryProductPage> {

  late HomeController _con;

  _GroceryProductPageState() : super(HomeController()) {
    _con = controller as HomeController;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.listGroceryCategoryProduct(widget.vendorId,widget.categoryId);
    _con.getAllCount();
    _con.getTotalPrice();
    _con.getDistance2(widget.vendorBean.generalDetail!.latitude!, widget.vendorBean.generalDetail!.longitude!);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 80,
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
                                image: NetworkImage(widget.vendorBean.logo!),
                                fit: BoxFit.cover, // Cover the entire container
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
                                          style: AppStyle.font14MediumBlack87.override(fontSize: 12,color: Colors.grey),
                                        ),
                                        Text(
                                          widget.vendorBean.address1!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyle.font14MediumBlack87.override(fontSize: 12,color: Colors.grey),
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
                                            Image.asset("assets/images/bike.png"),
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
                if (_con.groceryProductModel.data != null)
                  Expanded(
                    child: Stack(
                      children: [
                        DefaultTabController(
                          length: _con.groceryProductModel.data!.length,
                          child: Column(
                            children: [
                              TabBar(
                                isScrollable: true, // Make the TabBar scrollable
                                tabs: _con.groceryProductModel.data!.map((category) => Tab(text: category.subcategoryName)).toList(),
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: _con.groceryProductModel.data!.map((category) => GroceryProduct(category,_con,widget.vendorId)).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          //PageNavigation.gotoCheckOutPage(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckOutPage(),
                            ),
                          ).then((value) async {
                            await _con.listGroceryCategoryProduct(widget.vendorId, widget.categoryId);
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
