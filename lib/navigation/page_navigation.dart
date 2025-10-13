

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userapp/controller/cart_controller.dart';
import 'package:userapp/controller/home_controller.dart';
import 'package:userapp/model/hotel/booking_request.dart';
import 'package:userapp/model/hotel/hotel_booking_response.dart';
import 'package:userapp/model/hotel/hotel_details_response.dart';
import 'package:userapp/model/hotel/hotel_response.dart';
import 'package:userapp/model/order/order_model.dart';
import 'package:userapp/model/service/add_service_request.dart';
import 'package:userapp/model/service/service_category_model.dart';
import 'package:userapp/model/service/service_response_model.dart';
import 'package:userapp/page/address/address_page.dart';
import 'package:userapp/page/auth/login/inside_login_page.dart';

import 'package:userapp/page/auth/login/login_page.dart';
import 'package:userapp/page/auth/otp/inside_otp_page.dart';
import 'package:userapp/page/auth/otp/otp_page.dart';
import 'package:userapp/page/cart/check_out_page.dart';
import 'package:userapp/page/chat/order_chat_page.dart';
import 'package:userapp/page/coupon/coupon_page.dart';
import 'package:userapp/page/dashboard/dashboard_page.dart';
import 'package:userapp/page/dashboard/orders/order_details_page.dart';
import 'package:userapp/page/dashboard/service/service_details_page.dart';
import 'package:userapp/page/grocery/grocery_category_page.dart';
import 'package:userapp/page/grocery/grocery_product_page.dart';
import 'package:userapp/page/hotel/hotel_booking_screen.dart';
import 'package:userapp/page/hotel/hotel_checkout_page.dart';
import 'package:userapp/page/hotel/hotel_my_booking_details_page.dart';
import 'package:userapp/page/hotel/hotel_room_page.dart';
import 'package:userapp/page/hotel/hotel_success_page.dart';
import 'package:userapp/page/hotel/hotel_vendor_details_page.dart';
import 'package:userapp/page/hotel/hotel_vendors_page.dart';
import 'package:userapp/page/location/location_page.dart';
import 'package:userapp/page/location/select_location_page.dart';
import 'package:userapp/page/payment/payment_page.dart';
import 'package:userapp/page/policy/policy_page.dart';
import 'package:userapp/page/policy/privacy_policy_page.dart';
import 'package:userapp/page/policy/refund_policy.dart';
import 'package:userapp/page/policy/terms_and_conditions.dart';
import 'package:userapp/page/search/search_page.dart';
import 'package:userapp/page/service/add_service_page.dart';
import 'package:userapp/page/service/service_checkout_page.dart';
import 'package:userapp/page/service/service_location_page.dart';
import 'package:userapp/page/splash/splash_page.dart';
import 'package:userapp/page/sucess/order_sucess_page.dart';
import 'package:userapp/page/vendor/banner_vendor_page.dart';
import 'package:userapp/page/vendor/vendor_product_page.dart';
import 'package:userapp/utils/validation_utils.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../page/address/map_page.dart';
import '../page/dashboard/home/vendor_page.dart';
import '../page/hotel/hotel_my_booking_page.dart';
import '../page/service/service_category_page.dart';

class PageNavigation{


  static gotoLoginScreen(BuildContext context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  static gotoOtpPage(BuildContext context, String mobile, String? id){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpPage(mobile,id),
      ),
    );
  }

  static gotoInsideOtpPage(BuildContext context, String mobile, String? id){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsideOtpPage(mobile,id),
      ),
    );
  }


  static gotoSearchPage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(),
      ),
    );
  }


  static gotoDashboard(BuildContext context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardPage(),
      ),
    );
  }

  static gotoLocationPage(BuildContext context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPage(),
      ),
    );
  }

  static gotoSelectedLocationPage(BuildContext context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SelectLocationPage(),
      ),
    );
  }

  static gotoOrderDetailsPage(BuildContext context, String salecode){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(salecode),
      ),
    );
  }

  static gotoVendorPage(BuildContext context, categoryBean){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VendorPage(categoryBean),
      ),
    );
  }

  static gotoVendorProductPage(BuildContext context, String? vendorId, vendorBean){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VendorProductPage(vendorId!,vendorBean),
      ),
    );
  }

  static gotoBannerVendorPage(BuildContext context, String s){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BannerVendorPage(s),
      ),
    );
  }

  static gotoGroceryCategoryPage(BuildContext context, String? vendorId, vendorBean){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroceryCategoryPage(vendorId!,vendorBean),
      ),
    );
  }
  static gotoGroceryProductPage(BuildContext context, String? vendorId, vendorBean, String categoryId){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroceryProductPage(vendorId!,vendorBean,categoryId),
      ),
    );
  }

  static gotoCheckOutPage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckOutPage(),
      ),
    );
  }




  static gotoMapPage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(""),
      ),
    );
  }

  // static gotoAddServicePage(BuildContext context, List<ServiceCategory> selectedCategoryIndices){
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => AddServicePage(selectedCategoryIndices),
  //     ),
  //   );
  // }

  static gotoAddServicePage(BuildContext context, List<String> selectCategoryList, List<ServiceCategory> selectedCategoryIndices, TextEditingController noteController, ServiceCategory? selectedCategory){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddServicePage(selectCategoryList,selectedCategoryIndices,noteController,selectedCategory),
      ),
    );
  }

  static gotoServiceCategoryPage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceCategoryPage(),
      ),
    );
  }

  static gotoServiceCheckoutPage(BuildContext context, AddServiceRequest addServiceRequest, List<String> selectCategoryList, List<ServiceCategory> selectedCategoryIndices, String serviceInput, ServiceCategory? selectedCategory){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceCheckOutPage(addServiceRequest,selectCategoryList,selectedCategoryIndices,serviceInput,selectedCategory),
      ),
    );
  }

  static gotoSuccessPage(BuildContext context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSuccessPage(),
      ),
    );
  }

  static gotoSplashScreen(BuildContext context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SplashPage(),
      ),
    );
  }

  static Future<dynamic> gotoMapServiceLocation(BuildContext context, String type, String serviceType) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceLocationPage(type,serviceType),
      ),
    );
  }

  static Future<dynamic> gotoServiceDetailsPage(BuildContext context, Service serviceBean) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailsPage(serviceBean),
      ),
    );
  }

  static Future<dynamic> gotoPaymentPage(BuildContext context, CartController con) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(con),
      ),
    );
  }
  static Future<dynamic> gotoAddressPage(BuildContext context,String type){
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressPage(type),
      ),
    );
  }

  static Future<dynamic> gotoCouponPage(BuildContext context, double totalPrice) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CouponPage(totalPrice),
      ),
    );
  }


  static gotoPolicyPage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PolicyPage(),
      ),
    );
  }

  static gotoPrivacyPolicy(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivacyPolicyPage(),
      ),
    );
  }

  static gotoTermsConditions(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermsConditions(),
      ),
    );
  }

  static gotoRefundPolicy(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RefundPolicy(),
      ),
    );
  }

  static gotoChatPage(BuildContext context,String orderId,String type, String sender){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderChatPage(orderId,type,sender),
      ),
    );
  }

  static gotoHotelBookingPage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelBookingScreen(),
      ),
    );
  }

  static gotoHotelVendorPage(BuildContext context, BookingRequest bookingRequest){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelVendorsPage(bookingRequest),
      ),
    );
  }

  static gotoHotelVendorDetailsPage(BuildContext context, hotelBean, BookingRequest bookingRequest){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelVendorDetailsPage(hotelBean,bookingRequest),
      ),
    );
  }

  static gotoHotelRoomPage(BuildContext context,hotelData,roomBean, BookingRequest bookingRequest){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelRoomPage(hotelData,roomBean,bookingRequest),
      ),
    );
  }

  static gotoHotelCheckoutPage(BuildContext context,hotelData,roomBean, BookingRequest bookingRequest){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelCheckoutPage(hotelData,roomBean,bookingRequest),
      ),
    );
  }

  static gotoHotelSuccessPage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelSuccessPage(),
      ),
    );
  }

  static gotoHotelMyBookings(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelMyBookingPage(),
      ),
    );
  }

  static gotoHotelMyBookingDetails(BuildContext context, bookingBean){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelMyBookingDetailsPage(bookingBean),
      ),
    );
  }


  static gotoDialPage(BuildContext context,String mobile) async {
    await FlutterPhoneDirectCaller.callNumber(mobile);
  }

  static openWhatsApp(String phoneNumber, String text) async {
    final Uri whatsappUrl = Uri(
      scheme: 'https',
      host: 'api.whatsapp.com',
      path: 'send',
      queryParameters: {
        'phone': "+91"+phoneNumber,
        'text': text,
      },
    );
    print(whatsappUrl.toString());
    await launch(whatsappUrl.toString());
  }

  static goLogout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    gotoLoginScreen(context);
  }

}