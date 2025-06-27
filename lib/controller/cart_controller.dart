

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/database/database_helper.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/model/coupon/coupon_model.dart';
import 'package:userapp/model/database/cart_product_model.dart';
import 'package:userapp/model/order/checkout.dart';
import 'package:userapp/model/order/delivery_fees_response.dart';
import 'package:userapp/model/product/product_model.dart';
import 'package:userapp/model/tips/tips_model.dart';
import 'package:userapp/model/vendor/vendor_details_model.dart';
import 'package:userapp/navigation/page_navigation.dart';
import 'package:userapp/utils/preference_utils.dart';

import 'package:userapp/utils/validation_utils.dart';

import '../constants/app_colors.dart';
import '../constants/app_style.dart';
import '../model/order/razorpay_order_model.dart';
import '../model/profile/profile_model.dart';
import '../navigation/navigation_service.dart';
import '../network/api_service.dart';
import '../network/dio_client.dart';
import '../page/cart/check_out_page.dart';
import '../utils/loader.dart';
import 'dart:math' as math;

class CartController extends ControllerMVC{

  //Network Service
  ApiService apiService = ApiService();

  var dbHelper = DatabaseHelper();
  var cartProductModel = CartProductModel();
  var deliverFeesModel = DeliveryFeesResponse();
  var vendorDetailsModel = VendorDetailsModel();
  var couponModel = CouponModel();
  var tipsModel = TipsModel();
  List<int> tipsValues = [];
  var checkOut = Checkout();
  List<CartProductModel> cartList = [];
  List<Addon> addOnList = [];
 var totalPrice = 0.0;
 var allTotalPrice = 0.0;
 var addOnPrice = 0.0;
 double deliveryFees = 0.0;
 var packingCharges = 0.0;
 var discount = 0.0;
 var vendorDiscount = 0.0;
 var discountType = "";
 var tips = 0;
 var isCouponApplied = false;
  var coupon = Coupon();
var isVendorDiscount = false;
 var tax = 0.0;
  var instructionController =  TextEditingController();

  String distance = "";
  var focusID = "";

   addProduct(CartProductModel model) async {
    final db = await dbHelper.database;
    if(await dbHelper.isInsertCheck(model.shopId!)) {
      db.insert("product", {
        'id': model.id,
        'product_name': model.productName,
        'price': model.price,
        'strike': model.strike,
        'offer': model.offer,
        'quantity': model.quantity,
        'qty': model.qty,
        'variant': model.variant,
        'variantValue': model.variantValue,
        'userId': model.userId,
        'cartId': model.cartId,
        'unit': model.unit,
        'shopId': model.shopId,
        'image': model.image,
        'tax': model.tax.toString(),
        'discount': model.discount,
        'packingCharge': model.packingCharge,
        'addon': model.addon
      });
    }else{

      await dbHelper.deleteTableCartValues();
      db.insert("product", {
        'id': model.id,
        'product_name': model.productName,
        'price': model.price,
        'strike': model.strike,
        'offer': model.offer,
        'quantity': model.quantity,
        'qty': model.qty,
        'variant': model.variant,
        'variantValue': model.variantValue,
        'userId': model.userId,
        'cartId': model.cartId,
        'unit': model.unit,
        'shopId': model.shopId,
        'image': model.image,
        'tax': model.tax.toString(),
        'discount': model.discount,
        'packingCharge': model.packingCharge,
        'addon': model.addon
      });
    }
    dbHelper.getCartCount().then((value){
     // ValidationUtils.showAppToast(value.toString());
    });

    notifyListeners();
  }

  Future<bool?> showConfirmationBottomSheet(BuildContext context, CartProductModel model) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Confirm Action',
                style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure you want to remove the items from your cart before checking out?',
                style: AppStyle.font14RegularBlack87.override(color: Colors.black,fontSize: 13),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop(false);
                    },
                    child: Container(
                      width: 138,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.progressColor, // Gray fill color
                        borderRadius: BorderRadius.circular(15.0), // Rounded corners
                      ),
                      child: Center(
                        child:   Text("Cancel",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop(true);
                    },
                    child: Container(
                      width: 138,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.themeColor, // Gray fill color
                        borderRadius: BorderRadius.circular(15.0), // Rounded corners
                      ),
                      child: Center(
                        child:   Text("Confirm",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    ).then((value) async {
      if (value == true) {
        return  true;
      } else {
        return  false;
      }
    });
  }

  updateProduct(int id,int qty, [String? type]){
     if(qty==0){
       dbHelper.deleteTableCartValuesById(id);
       dbHelper.getCartCount().then((value){
         if(type=="cart") {
           if (value == 0) {
             Navigator.pop(NavigationService.navigatorKey.currentContext!);
           }
         }
       });
     }else{
       dbHelper.updateTableCartValuesById(id, qty);
     }
     setState(() {
       getAllCartProducts();
     });
  }

  updateAddOnProduct(String id,int qty, Addon addOn) async {
      setState(() {
        addOnList.forEach((element) {
            if(element.addonId == id){
              element.qty = qty;
            }
        });
        getTotalPrice();
        //getVendorCoupon();
      });

   }

   Future<Productdetails?> getProductQty(Productdetails productBean) async {
    final db = await dbHelper.database;
    List<Map<String, dynamic>> singleDigitRows = await db.query('product');
    CartProductModel value = CartProductModel();
    singleDigitRows.forEach((row) {
      if(productBean.id == row['id']) {
        value.qty = row['qty'];
        productBean.qty = row['qty'];
      }
    });
    return productBean;
  }

  getAllCartProducts() async {
     cartList.clear();
     addOnList.clear();
    final db = await dbHelper.database;
    List<Map<String, dynamic>> singleDigitRows = await db.query('product');
    singleDigitRows.forEach((row) {
      CartProductModel value = CartProductModel();
      value.id = row['id'].toString();
      value.productName = row['product_name'];
      value.price = row['price'];
      value.strike = row['strike'];
      value.offer = row['offer'];
      value.quantity = row['quantity'];
      value.qty = row['qty'];
      value.variant = row['variant'];
      value.variantValue = row['variantValue'];
      value.userId = row['userId'];
      value.cartId = row['cartId'];
      value.unit = row['unit'];
      value.shopId = row['shopId'];
      value.image = row['image'];
      value.tax = double.parse(row['tax']);
      value.discount = row['discount'];
      value.packingCharge = row['packingCharge'];
      value.addon = row['addon'];
      print(value.toJson());
      setState(() {
        cartList.add(value);
      });
    });
    cartList.forEach((element) {
      if(element.addon!=null){
        List<dynamic> addonsJson = json.decode(element.addon!);
        List<Addon> addOnList1 = addonsJson.map((json) => Addon.fromJson(json)).toList();
        // Print the list to verify
        for (var addon in addOnList1) {
          setState(() {
            addon.qty = 0;
            addOnList.add(addon);
          });
        }
      }
    });
    await getVendorDetails(NavigationService.navigatorKey.currentContext!, cartList[0].shopId!);
    print("????"+cartList.length.toString());
    notifyListeners();
  }

  getPackingCharge() async {
    var total = 0.0;
    final db = await dbHelper.database;
    List<Map<String, dynamic>> singleDigitRows = await db.query('product');
    singleDigitRows.forEach((row) {
      CartProductModel value = CartProductModel();
      value.packingCharge = row['packingCharge'];
      value.qty = row['qty'];
      setState(() {
        total  = total + (value.packingCharge!*value.qty!);
        packingCharges = total;
      });
    });
    notifyListeners();
  }

  getSubTotalPrice() async {
    var total = 0.0;
    final db = await dbHelper.database;
    List<Map<String, dynamic>> singleDigitRows = await db.query('product');
    singleDigitRows.forEach((row) {
      CartProductModel value = CartProductModel();
      value.price = row['price'];
      value.qty = row['qty'];
      setState(() {
        total  = total + (double.parse(value.price!)*value.qty!);
        totalPrice = total;
      });
    });
    notifyListeners();
  }

  getTax() async {
    var total = 0.0;
    final db = await dbHelper.database;
    List<Map<String, dynamic>> singleDigitRows = await db.query('product');
    singleDigitRows.forEach((row) {
      CartProductModel value = CartProductModel();
      value.tax = double.parse(row['tax']);
      value.qty = row['qty'];
      setState(() {
        total  = total + (value.tax!*value.qty!);
        tax = total;
      });
    });
    notifyListeners();
  }

  getCouponPrice() async {
     discount = 0.0;
     if(coupon.discountType == "1"){
        discount = ((totalPrice+tax) * int.parse(coupon.discount!))/100;
        //allTotalPrice = allTotalPrice - discount;
     }else{
         discount = double.parse(coupon.discount!);
         //allTotalPrice = allTotalPrice - int.parse(coupon.discount!);
     }
     isCouponApplied = true;
     getTotalPrice();
     notifyListeners();
  }

  getVendorCoupon(){
    if(vendorDetailsModel.data!.discountType!=null) {
      isVendorDiscount = true;
      if(vendorDetailsModel.data!.discountType == '1'){
        if(totalPrice>double.parse(vendorDetailsModel.data!.upTo!)) {
          setState(() {
            vendorDiscount =
                double.parse(vendorDetailsModel.data!.discount!);
            allTotalPrice = (totalPrice+tax+deliveryFees+packingCharges+tips+addOnPrice)-discount-vendorDiscount;
          });
        }else{
          isVendorDiscount = false;
          allTotalPrice = allTotalPrice + vendorDiscount;
          vendorDiscount = 0;
        }
      }else{
        if(totalPrice>double.parse(vendorDetailsModel.data!.upTo!)) {
          setState(() {
            vendorDiscount =
                ((totalPrice+tax) * double.parse(vendorDetailsModel.data!
                    .discount!)) / 100;
            allTotalPrice = (totalPrice+tax+deliveryFees+packingCharges+tips+addOnPrice)-discount-vendorDiscount;
          });
        }else{
          isVendorDiscount = false;
          allTotalPrice = allTotalPrice + vendorDiscount;
          vendorDiscount = 0;
        }
      }
    }
    notifyListeners();
  }

  getTotalPrice() async {
    totalPrice = 0.0;
    tax = 0.0;
    packingCharges = 0.0;
    addOnPrice = 0.0;
     await getSubTotalPrice();
     await getTax();
     await getPackingCharge();
     await getVendorCoupon();
     addOnList.forEach((element) {
       if(element.qty!>0) {
         addOnPrice = addOnPrice + (double.parse(element.price!)*element.qty!);
         print(addOnPrice);
       }
     });
    setState(() {
      allTotalPrice = (totalPrice+tax+deliveryFees+packingCharges+tips+addOnPrice)-discount-vendorDiscount;
      print(allTotalPrice);
    });
    await getVendorCoupon();
    notifyListeners();
  }

  createOrder(BuildContext context) async {
     await getTotalPrice();
     await getSubTotalPrice();
     await getTax();
     await getPackingCharge();

     var userId =await PreferenceUtils.getUserId();
     var focusId =await PreferenceUtils.getFocusId();
     checkOut.saleCode =  await generateOrderId();
     checkOut.description =  instructionController.text;
     checkOut.deliveryTimeSlot =  "";
     checkOut.shopId =  cartList[0].shopId;
     checkOut.deliverType =  1;
     checkOut.focusId =  int.parse(focusId!);
     String? zoneId = await PreferenceUtils.getZoneId();
     checkOut.zoneId =  zoneId;
     checkOut.userId =  await PreferenceUtils.getUserId();
     checkOut.cart = cartList;
     checkOut.addOn = addOnList;
     String? location = await PreferenceUtils.getLocation();
     String? latitude = await PreferenceUtils.getLatitude();
     String? longitude = await PreferenceUtils.getLongitude();
     String? phone = await PreferenceUtils.getUserPhone();
     checkOut.address.addressSelect = location;
     checkOut.address.latitude = double.parse(latitude!);
     checkOut.address.longitude = double.parse(longitude!);
     checkOut.address.phone = phone;
     checkOut.address.userId = await PreferenceUtils.getUserId();
     // checkOut.payment.paymentType = "cash on delivery";
     // checkOut.payment.method = "cash on delivery";
     checkOut.payment.grandTotal = allTotalPrice.round();
     checkOut.payment.subTotal = totalPrice.round();
     checkOut.payment.discount = discount;
     checkOut.payment.vendorDiscount = vendorDiscount;
     checkOut.payment.km = distance;
     checkOut.payment.deliveryFees = deliveryFees.round();
     checkOut.payment.tax = tax;
     checkOut.payment.deliveryTips = tips;
     checkOut.payment.packingCharge = packingCharges;
     print(checkOut.toJson());
     Loader.show();
     apiService.createOrder(checkOut).then((value){
       Loader.hide();
       dbHelper.deleteTableCartValues();
       Navigator.pop(context);
       Navigator.pop(context);
       Navigator.pop(context);
       PageNavigation.gotoOrderDetailsPage(context,value.data!);
       // if(value.success!){
       //   notifyListeners();
       // }else{
       //   ValidationUtils.showAppToast("Something wrong");
       // }
     }).catchError((e){
       print(e);
       Loader.hide();
     });
  }

  Future<String?> generateOrderId() async{
    String? orderId = "FS";
    String? fCode = await PreferenceUtils.getFCode();
    String? zoneId = await PreferenceUtils.getZoneId();
    orderId = "$orderId$fCode$zoneId";
    return orderId;
  }

  getDeliveryFees(BuildContext context,String km){
    Loader.show();
    apiService.getDeliveryFees(km,focusID).then((value) async {
      Loader.hide();
      if(value.success!){
        if(value.data!=null) {
          setState(() {
            deliverFeesModel = value;
            double tax = (int.parse(deliverFeesModel.data!.amount!) *
                int.parse(deliverFeesModel.data!.tax!)) / 100;
            deliveryFees =
                double.parse(deliverFeesModel.data!.amount!) + tax.round();
            getTotalPrice();
          });
        }else{
          String? location = await PreferenceUtils.getLocation();
          _showInvalidZoneBottomSheet(context, location!);
        }
      }
      notifyListeners();
    }).catchError((e){
      Loader.hide();
     // ValidationUtils.showAppToast("Something went wrong.");
      print(e);
    });
  }

  Future<String?> getDistanceAndTime(String vendorLat,String vendorLong) async {
    String? distance = "";
    try {
      String? lat = await PreferenceUtils.getLatitude();
      String? longi = await PreferenceUtils.getLongitude();
      String orgin = "${lat},${longi}";
      String destination = "${vendorLat},${vendorLong}";
      final url =
          'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$orgin&destinations=$destination&key=AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY';
      final dioClient = DioClient();
      final response = await dioClient.get(url);
      if (response.statusCode == 200) {
        print(json.decode(response.toString()));
        final data = json.decode(response.toString());
        final dis = data['rows'][0]['elements'][0]['distance']['text'];
        final dur = data['rows'][0]['elements'][0]['duration']['text'];
        distance = dis;
        notifyListeners();
      } else {
        print('Error: ${response.statusCode}');
      }
      return distance;
    } catch (e) {
      print('Error: $e');
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Radius of the Earth in km
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);
    double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
            math.cos(_degToRad(lat1)) * math.cos(_degToRad(lat2)) *
                math.sin(dLon / 2) * math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) {
    return deg * (math.pi / 180);
  }

  getVendorDetails(BuildContext context,String vendorId){
    Loader.show();
    apiService.getVendorDetails(vendorId).then((value) async {
      Loader.hide();
      if(value.success!){
        setState(() {
          vendorDetailsModel = value;
          PreferenceUtils.saveFocusId(vendorDetailsModel.data!.focusId!);
          focusID = vendorDetailsModel.data!.focusId!;
        });
        await getDistanceAndTime(vendorDetailsModel.data!.latitude!, vendorDetailsModel.data!.longitude!).then((value){
          distance = value!;
          getDeliveryFees(context, distance);
        });
      }
      notifyListeners();
    }).catchError((e){
      Loader.hide();
      //ValidationUtils.showAppToast("Something went wrong.");
      print(e);
    });
  }


  getCoupon(BuildContext context){
    Loader.show();
    apiService.getCouponModel().then((value) async {
      Loader.hide();
      if(value.success!){
        setState(() {
          couponModel = value;
        });
      }
      notifyListeners();
    }).catchError((e){
      Loader.hide();
      //ValidationUtils.showAppToast("Something went wrong.");
      print(e);
    });
  }

  getDeliveryTips(BuildContext context){
    Loader.show();
    apiService.getDeliveryTips().then((value) async {
      Loader.hide();
      if(value.success!){
        setState(() {
          tipsModel = value;
          tipsModel.data!.forEach((element) {
            tipsValues.add(int.parse(element.amount!));
          });
        });
      }
      notifyListeners();
    }).catchError((e){
      Loader.hide();
      //ValidationUtils.showAppToast("Something went wrong.");
      print(e);
    });
  }


  var profileModel = ProfileModel();

  getProfile(BuildContext context){
    Loader.show();
    apiService.getProfile().then((value){
      Loader.hide();
      if(value.success!){
        profileModel = value;
        if(profileModel.data!.status == "failed"){
          _showModalBottomSheet(context);
        }
       // PreferenceUtils.saveUserPhone(profileModel.data!.phone!);
        notifyListeners();
      }else{
        //ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return Container(
          height: 160,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  leading: Image.asset("assets/images/blockuser.png"),
                  title: Text('Sorry! you are not allowed place the orders',style: AppStyle.font14MediumBlack87.override(fontSize: 14),),
                ),
                SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    PageNavigation.openWhatsApp(profileModel.data!.fphone!, "");
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.themeColor, // Gray fill color
                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    ),
                    child: Center(
                      child:   Text("Support",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showInvalidZoneBottomSheet(BuildContext context, String currentLocation) {
    showModalBottomSheet(
      isDismissible: false,
      enableDrag: false, // Prevents dragging to dismiss
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            Navigator.pop(context);
            return false;
          }, // Disable back button dismissal
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: 240,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Address',
                  style: AppStyle.font14MediumBlack87.override(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  currentLocation,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Currently, delivery is not available in this location',
                    style: AppStyle.font14MediumBlack87.override(fontSize: 14, color: Colors.red),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    PageNavigation.gotoAddressPage(context, "home").then((value) {
                      PreferenceUtils.getZoneId().then((zoneId) {
                        print(zoneId);
                        if (zoneId != "0") {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          PageNavigation.gotoDashboard(context);
                        }
                      });
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.themeColor,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                      child: Text(
                        "Change Location",
                        style: AppStyle.font14MediumBlack87.override(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  var razorPayModel =  RazorpayOrder();

  createOrderId(BuildContext context,String amount, String? location, CartController con){
    Loader.show();
    apiService.createOrderId(amount).then((value){
      Loader.hide();
        notifyListeners();
        showModalBottomSheet(
          context: context,
          builder: (context) =>
              ProgressBarBottomSheet(location!, con,value.id),
        );
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }

}