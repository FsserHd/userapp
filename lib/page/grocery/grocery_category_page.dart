
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/navigation/page_navigation.dart';

import '../../constants/app_style.dart';
import '../../controller/home_controller.dart';
import '../../model/home/home_model.dart';
import 'grocery_product_page.dart';

class GroceryCategoryPage extends StatefulWidget {

  String vendorId;
  VendorData vendorBean;
  GroceryCategoryPage(this.vendorId, this.vendorBean,{super.key});

  @override
  _GroceryCategoryPageState createState() => _GroceryCategoryPageState();
}

class _GroceryCategoryPageState extends StateMVC<GroceryCategoryPage> {

  late HomeController _con;

  _GroceryCategoryPageState() : super(HomeController()) {
    _con = controller as HomeController;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.getDistance2(widget.vendorBean.generalDetail!.latitude!, widget.vendorBean.generalDetail!.longitude!);
    _con.listGroceryCategory(widget.vendorId);
    //_con.dbHelper.deleteTableCartValues();
  }

  final List<String> imageUrls = [
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
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
                                      SizedBox(height: 2),
                                      Text(
                                        widget.vendorBean.generalDetail!.subtitle!,
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
                                      SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Image.asset("assets/images/bike.png"),
                                          SizedBox(width: 2,),
                                          Text(
                                            _con.duration+" delivery time",
                                            style: AppStyle.font14MediumBlack87.override(fontSize: 12,color: Colors.grey),
                                          ),
                                        ],
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
                  ),
                ],
              ),
              SizedBox(height: 10,),
              _con.groceryCategoryModel.data!=null ? GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns in the grid
                  mainAxisSpacing: 10.0, // Spacing between rows
                  crossAxisSpacing: 10.0, // Spacing between columns
                ),
                itemCount: _con.groceryCategoryModel.data!.length,
                itemBuilder: (context, index) {
                  var categoryBean = _con.groceryCategoryModel.data![index];
                  return InkWell(
                    onTap: (){
                      PageNavigation.gotoGroceryProductPage(context, widget.vendorId, widget.vendorBean,categoryBean.categoryId!);

                    },
                    child: Column(
                      children: [
                        ClipOval(
                          child: Image.network(
                            categoryBean.banner!,
                            height: 60.0, // Height of the image
                            width: 60.0, // Width of the image
                            fit: BoxFit.cover, // How the image should be inscribed into the box
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          categoryBean.categoryName!,
                          style: AppStyle.font18BoldWhite.override(fontSize: 10,),
                        ),
                      ],
                    ),
                  );
                },
                padding: EdgeInsets.all(10.0), // Padding around the grid
              ):Container(),
            ],
          ),
        ],
      ),
    );
  }
}
