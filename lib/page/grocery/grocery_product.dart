import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/model/product/grocery_product_model.dart';

import '../../constants/api_constants.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/cart_controller.dart';
import '../../controller/home_controller.dart';
import '../../utils/preference_utils.dart';

class GroceryProduct extends StatefulWidget {
  Data category;
  HomeController homeController;
  String vendorId;
  GroceryProduct(this.category, this.homeController, this.vendorId,
      {super.key});

  @override
  _GroceryProductState createState() => _GroceryProductState();
}

class _GroceryProductState extends StateMVC<GroceryProduct> {
  late CartController _con;

  _GroceryProductState() : super(CartController()) {
    _con = controller as CartController;
  }

  int _counter = 1;
  var countTextController = TextEditingController();
  int quantity = 0;

  void _showVariantDialog(
      BuildContext context, GroceryProductdetails productBean) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Choose Variant',
                      style: AppStyle.font14MediumBlack87,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.black,
                        ))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    itemCount: productBean.variant!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var variantBean = productBean.variant![index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            productBean.selectedIndex = index;
                            productBean.variant![index] = variantBean;
                            print(productBean.toJson());
                            Navigator.pop(context);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(
                                2.0), // Padding inside the container
                            decoration: BoxDecoration(
                              color: Colors.white, // Background color
                              borderRadius:
                                  BorderRadius.circular(5.0), // Corner radius
                              border: Border.all(
                                color: Colors.grey, // Border color
                                width: 1.0, // Border width
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            variantBean.quantity! +
                                                " " +
                                                variantBean.unit! +
                                                " / " +
                                                productBean.productName!,
                                            style: AppStyle.font14RegularBlack87
                                                .override(fontSize: 14),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            ApiConstants.currency +
                                                variantBean.salePrice!,
                                            style: AppStyle.font14RegularBlack87
                                                .override(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.arrow_right)
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: widget.category.productdetails!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var productBean = widget.category.productdetails![index];
          // print(productBean.qty);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                borderRadius:
                    BorderRadius.circular(10.0), // Rounded corners
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              productBean.productName!,
                              style: AppStyle.font18BoldWhite
                                  .override(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            Text(
                              ApiConstants.currency +
                                  productBean
                                      .variant![productBean.selectedIndex!]
                                      .salePrice!,
                              style: AppStyle.font14MediumBlack87
                                  .override(fontSize: 14),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              ApiConstants.currency +
                                  productBean
                                      .variant![productBean.selectedIndex!]
                                      .strikePrice!,
                              style: AppStyle.font14MediumBlack87.override(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        InkWell(
                          onTap: () {
                            _showVariantDialog(context, productBean);
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                                2.0), // Padding inside the container
                            decoration: BoxDecoration(
                              color: Colors.white, // Background color
                              borderRadius: BorderRadius.circular(
                                  5.0), // Corner radius
                              border: Border.all(
                                color: Colors.grey, // Border color
                                width: 1.0, // Border width
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  productBean
                                          .variant![
                                              productBean.selectedIndex!]
                                          .quantity! +
                                      " " +
                                      productBean
                                          .variant![
                                              productBean.selectedIndex!]
                                          .unit!,
                                  style: AppStyle.font14RegularBlack87
                                      .override(fontSize: 12),
                                ),
                                SizedBox(
                                  width: 60,
                                ),
                                Icon(Icons.arrow_drop_down)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        ClipRRect(
                          child: Image.network(
                            productBean.variant![productBean.selectedIndex!]
                                .image!,
                            height: 80,
                            width: 80,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        productBean.variant![productBean.selectedIndex!]
                                    .qty !=
                                0
                            ? Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: AppColors.themeColor,
                                      width: 1),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
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
                                        // if (productBean.qty! > 0) {
                                        setState(() {
                                          productBean
                                              .variant![productBean
                                                  .selectedIndex!]
                                              .qty = productBean
                                                  .variant![productBean
                                                      .selectedIndex!]
                                                  .qty! -
                                              1;
                                        });
                                        // }
                                        await _con.updateProduct(
                                            int.parse(productBean
                                                .variant![productBean
                                                    .selectedIndex!]
                                                .variantId!),
                                            productBean
                                                .variant![productBean
                                                    .selectedIndex!]
                                                .qty!);
                                        setState(() {
                                          widget.homeController
                                              .getTotalPrice();
                                          widget.homeController
                                              .getAllCount();
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "${productBean.variant![productBean.selectedIndex!].qty}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.themeColor),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          productBean
                                              .variant![productBean
                                                  .selectedIndex!]
                                              .qty = productBean
                                                  .variant![productBean
                                                      .selectedIndex!]
                                                  .qty! +
                                              1;
                                        });
                                        await _con.updateProduct(
                                            int.parse(productBean
                                                .variant![productBean
                                                    .selectedIndex!]
                                                .variantId!),
                                            productBean
                                                .variant![productBean
                                                    .selectedIndex!]
                                                .qty!);
                                        setState(() {
                                          widget.homeController
                                              .getTotalPrice();
                                          widget.homeController
                                              .getAllCount();
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
                              )
                            : InkWell(
                                onTap: () async {
                                  if (quantity == 0) {
                                    _con.cartProductModel.id = productBean
                                        .variant![
                                            productBean.selectedIndex!]
                                        .variantId;
                                    _con.cartProductModel.productName =
                                        productBean.productName;
                                    _con.cartProductModel.price =
                                        productBean
                                            .variant![
                                                productBean.selectedIndex!]
                                            .salePrice;
                                    _con.cartProductModel.strike =
                                        productBean
                                            .variant![
                                                productBean.selectedIndex!]
                                            .purchasePrice;
                                    _con.cartProductModel.purchasePrice =
                                        productBean
                                            .variant![
                                        productBean.selectedIndex!]
                                            .purchasePrice;
                                    _con.cartProductModel.offer = 0;
                                    _con.cartProductModel.quantity =
                                        productBean
                                            .variant![
                                                productBean.selectedIndex!]
                                            .quantity;
                                    _con.cartProductModel.qty =
                                        productBean.qty! + 1;
                                    _con.cartProductModel.variant =
                                        productBean
                                            .variant![
                                                productBean.selectedIndex!]
                                            .variantId;
                                    _con.cartProductModel.variantValue = "";
                                    String? userId =
                                        await PreferenceUtils.getUserId();
                                    _con.cartProductModel.variantValue = "";
                                    _con.cartProductModel.userId = userId;
                                    _con.cartProductModel.cartId = "0";
                                    _con.cartProductModel.unit = productBean
                                        .variant![
                                            productBean.selectedIndex!]
                                        .unit;
                                    _con.cartProductModel.shopId =
                                        widget.vendorId;
                                    _con.cartProductModel.image =
                                        productBean.variant![0].image;
                                    _con.cartProductModel.tax =
                                        productBean.variant![0].tax;
                                    _con.cartProductModel.discount = "0";
                                    _con.cartProductModel.packingCharge =
                                        productBean
                                            .variant![
                                                productBean.selectedIndex!]
                                            .packingCharge;
                                    await _con
                                        .addProduct(_con.cartProductModel);
                                  }
                                  setState(() {
                                    productBean
                                        .variant![
                                            productBean.selectedIndex!]
                                        .qty = productBean.qty! + 1;
                                    widget.homeController.getTotalPrice();
                                    widget.homeController.getAllCount();
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: AppColors.themeColor,
                                        width: 1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Add",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.themeColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
