import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/constants/api_constants.dart';
import 'package:userapp/constants/app_colors.dart';
import 'package:userapp/controller/cart_controller.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';

import 'package:userapp/model/product/product_model.dart';
import 'package:userapp/utils/preference_utils.dart';

import '../../constants/app_style.dart';
import '../../controller/home_controller.dart';
import '../dashboard/dashboard_page.dart';
import '../widget/description_preview.dart';

class ProductPage extends StatefulWidget {
  Data category;
  HomeController homeController;
  String vendorId;
  ProductPage(this.category, this.homeController,this.vendorId , {super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends StateMVC<ProductPage> {

  late CartController _con;

  _ProductPageState() : super(CartController()) {
    _con = controller as CartController;
  }

  int _counter = 1;
  var countTextController = TextEditingController();
  int quantity =0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_con.listCategoryProduct(widget.vendorId,widget.category.id!);
  //  _con.dbHelper.deleteTableCartValues();
  }


  @override
  Widget build(BuildContext context) {
    return widget.category.productdetails!.isNotEmpty ?   ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: widget.category.productdetails!.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
         var productBean = widget.category.productdetails![index];
        // print(productBean.qty);

      return  Padding(
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
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          productBean.variant![0].foodType == "1" ?
                          Image.asset("assets/images/veg.png",height: 15,width: 15,):
                          Image.asset("assets/images/non_veg.png",height: 15,width: 15,),
                          SizedBox(width: 4,),
                          Expanded(
                            child: Text(
                              productBean.productName!,
                              maxLines: 2,
                              style: AppStyle.font18BoldWhite.override(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2,),
                      Text(
                        ApiConstants.currency+productBean.variant![0].salePrice!,
                        style: AppStyle.font14MediumBlack87.override(fontSize: 14),
                      ),
                      SizedBox(height: 2,),
                      DescriptionPreview(description: productBean.description ?? ''),
                      SizedBox(height: 2,),
                      productBean.qty!=0 ? Container(
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.themeColor, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.remove,
                                  size: 10,
                                  color: AppColors.themeColor,
                                ),
                              ),
                              onTap: () async {
                                if (productBean.qty! > 0) {
                                  setState(() {
                                    productBean.qty = productBean.qty!-1;

                                  });
                                }
                                await _con.updateProduct(int.parse(productBean.id!), productBean.qty!);
                                setState(() {
                                  widget.homeController.getTotalPrice();
                                  widget.homeController.getAllCount();
                                });
                              },
                            ),
                            SizedBox(width: 20,),
                            Text(
                              "${productBean.qty}",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.themeColor),
                            ),
                            SizedBox(width: 20,),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  productBean.qty = productBean.qty!+1;

                                });
                                await _con.updateProduct(int.parse(productBean.id!), productBean.qty!);
                                setState(() {
                                  widget.homeController.getTotalPrice();
                                  widget.homeController.getAllCount();
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.add,
                                  size: 10,
                                  color: AppColors.themeColor,
                                ),
                              ),
                            )

                          ],
                        ),
                      ):
                      InkWell(
                        onTap: () async {

                            if (quantity == 0) {
                              _con.cartProductModel.id = productBean.id;
                              _con.cartProductModel.productName =
                                  productBean.productName;
                              _con.cartProductModel.price =
                                  productBean.variant![0].salePrice;
                              _con.cartProductModel.strike =
                                  productBean.variant![0].strikePrice;
                              _con.cartProductModel.offer = 0;
                              _con.cartProductModel.quantity = "0";
                              _con.cartProductModel.qty = productBean.qty! + 1;
                              _con.cartProductModel.variant =
                                  productBean.variant![0].variantId;
                              _con.cartProductModel.variantValue = "";
                              String? userId = await PreferenceUtils.getUserId();
                              _con.cartProductModel.variantValue = "";
                              _con.cartProductModel.userId = userId;
                              _con.cartProductModel.cartId = "0";
                              _con.cartProductModel.unit = "0";
                              _con.cartProductModel.shopId = widget.vendorId;
                              _con.cartProductModel.image =
                                  productBean.variant![0].image;
                              _con.cartProductModel.tax =
                                  productBean.variant![0].tax;
                              _con.cartProductModel.discount = "0";
                              _con.cartProductModel.packingCharge =
                                  productBean.variant![0].packingCharge;
                              _con.cartProductModel.addon = jsonEncode(
                                  productBean.addon!.map((addon) =>
                                      addon.toJson()).toList());
                              if(await _con.dbHelper.isInsertCheck(widget.vendorId)) {
                                await _con.addProduct(_con.cartProductModel);
                                setState(() {
                                  productBean.qty = productBean.qty! + 1;
                                  widget.homeController.getTotalPrice();
                                  widget.homeController.getAllCount();
                                });
                              }else{
                                _con.showConfirmationBottomSheet(context,_con.cartProductModel).then((value) async {
                                  if(value!){
                                    await _con.addProduct(_con.cartProductModel);
                                    setState(() {
                                      productBean.qty = productBean.qty! + 1;
                                      widget.homeController.getTotalPrice();
                                      widget.homeController.getAllCount();
                                    });
                                  }
                                });
                              }
                            }


                        },
                        child: Container(
                          height: 40,
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
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.themeColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ClipRRect(

                        child: Image.network(productBean.variant![0].image!,height: 100,width: 100,fit: BoxFit.fill,),borderRadius: BorderRadius.circular(10.0),),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }):Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Expanded(child: Image.asset("assets/images/empty.png")),
        ],
      ),
    );
  }

}
