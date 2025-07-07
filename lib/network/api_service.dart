

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:userapp/model/address/adders_response_model.dart';
import 'package:userapp/model/address/address_model.dart';
import 'package:userapp/model/category/category_model.dart';
import 'package:userapp/model/category/grocery_category_model.dart';
import 'package:userapp/model/chat/chat_request.dart';
import 'package:userapp/model/chat/chat_response.dart';
import 'package:userapp/model/coupon/coupon_model.dart';
import 'package:userapp/model/driver/driver_model.dart';
import 'package:userapp/model/home/home_model.dart';
import 'package:userapp/model/login/otp_model.dart';
import 'package:userapp/model/order/checkout.dart';
import 'package:userapp/model/order/delivery_fees_response.dart';
import 'package:userapp/model/order/order_model.dart';
import 'package:userapp/model/payment/payment_gateway_model.dart';
import 'package:userapp/model/product/grocery_product_model.dart';
import 'package:userapp/model/product/product_model.dart';
import 'package:userapp/model/profile/profile_model.dart';
import 'package:userapp/model/profile/update_profile_model.dart';
import 'package:userapp/model/search/search_model.dart';
import 'package:userapp/model/service/add_service_request.dart';
import 'package:userapp/model/service/service_banner_model.dart';
import 'package:userapp/model/service/service_response_model.dart';
import 'package:userapp/model/tips/tips_model.dart';
import 'package:userapp/model/vendor/vendor_details_model.dart';
import 'package:userapp/model/vendor/vendor_model.dart';
import 'package:userapp/model/vendor/vendor_type_response.dart';
import 'package:userapp/model/wallet/wallet_balance_response.dart';
import 'package:userapp/model/wallet/wallet_transcation_model.dart';
import 'package:userapp/model/zone/zone_information_model.dart';
import 'package:userapp/model/zone/zone_response_model.dart';
import 'package:userapp/utils/preference_utils.dart';
import '../constants/api_constants.dart';
import '../model/common/common_response_model.dart';
import '../model/login/login_model.dart';
import '../model/order/order_details_model.dart';
import '../model/order/razorpay_order_model.dart';
import '../model/service/service_category_model.dart';
import '../model/update/app_update_response.dart';
import '../utils/validation_utils.dart';
import 'dio_client.dart';

class ApiService {

  final dioClient = DioClient();

  Future<ProfileModel> signIn(LoginModel signInModel) async {
    try {
      final response = await dioClient.post(
          ApiConstants.login, signInModel.toJson());
      if (response.statusCode == 200) {
        return ProfileModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ValidationUtils.showAppToast('Error during sign in: $e');
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<OtpModel> loginOtp(String mobile) async {
    try {
      final response = await dioClient.get(
          ApiConstants.validation+mobile);
      if (response.statusCode == 200) {
        return OtpModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<HomeModel> homeData(String zoneId) async {
    try {
      final response = await dioClient.get(
          ApiConstants.homeData+zoneId);
      if (response.statusCode == 200) {
        return HomeModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<OrderModel> getMyOrder() async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.myOrder+userId!);
      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<OrderDetailsModel> getOrderDetails(String saleCode) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.orderDetails+saleCode);
      if (response.statusCode == 200) {
        return OrderDetailsModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<VendorModel> listVendorById(String id,String zoneId) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.listVendor+'${id}/$zoneId');
      if (response.statusCode == 200) {
        return VendorModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<CategoryModel> listVendorCategories(String id) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.categories+id);
      if (response.statusCode == 200) {
        return CategoryModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<ProductModel> listCategoryProduct(String vendorId,String categoryId) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.category_wise_restaurantproduct+vendorId+"/"+categoryId);
      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<GroceryProductModel> listGroceryCategoryProduct(String vendorId,String categoryId) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.category_wise_product+categoryId);
      if (response.statusCode == 200) {
        return GroceryProductModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<CommonResponseModel> createOrder(Checkout checkout) async {
    try {
      final response = await dioClient.post(
          ApiConstants.createOrder, checkout.toJson());
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<CommonResponseModel> addAddress(AddressModel addressModel) async {
    try {
      final response = await dioClient.post(
          ApiConstants.addAddress, addressModel.toJson());
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<CommonResponseModel> editAddress(AddressModel addressModel,String addressId) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.post(
          ApiConstants.updateAddress+addressId!, addressModel.toJson());
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<AddressResponseModel> listAddress() async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.listAddress+userId!);
      if (response.statusCode == 200) {
        return AddressResponseModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<CommonResponseModel> deleteAddress(String id) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.deleteAddress+id!);
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }


  Future<ZoneResponseModel> getZone(String latitude,String longitude) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.getZone+"?myLat=${latitude}&myLon=${longitude}&user_id=${userId}");
      if (response.statusCode == 200) {
        return ZoneResponseModel.fromJson(response.data);
      } else {

        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<GroceryCategoryModel> listGroceryCategory(String vendorId) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.GetGroceryCategory+vendorId);
      if (response.statusCode == 200) {
        return GroceryCategoryModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<ServiceCategoryModel> getServiceCategory() async {
    try {
      String? zoneId = await PreferenceUtils.getZoneId();
      final response = await dioClient.get(
          ApiConstants.listServicecategory+'$zoneId');
      if (response.statusCode == 200) {
        return ServiceCategoryModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<ServiceBannerModel> getServiceBanner() async {
    try {
      String? zoneId = await PreferenceUtils.getZoneId();
      final response = await dioClient.get(
          ApiConstants.servicebanner+'$zoneId');
      if (response.statusCode == 200) {
        return ServiceBannerModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<CommonResponseModel> checkOutService(AddServiceRequest addServiceRequest) async {
    try {
      addServiceRequest.userid = await PreferenceUtils.getUserId();
      print(addServiceRequest.toJson());
      final response = await dioClient.post(
          ApiConstants.addService, addServiceRequest.toJson());
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<ServiceResponseModel> listService() async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.listOtherService+'$userId');
      if (response.statusCode == 200) {
        return ServiceResponseModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<DeliveryFeesResponse> getServiceCharge(String km, String? maincategory) async {
    try {
      String? zoneId = await PreferenceUtils.getZoneId();
      final response = await dioClient.get(
          ApiConstants.getServiceDeliveryFees+'$km/$zoneId/$maincategory');
      if (response.statusCode == 200) {
        return DeliveryFeesResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<ServiceResponseModel> listServiceById(String id) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.listOtherServiceById+'$id');
      if (response.statusCode == 200) {
        return ServiceResponseModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }


  Future<WalletBalanceResponse> getWalletBalance() async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.balance+userId!);
      if (response.statusCode == 200) {
        return WalletBalanceResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<PaymentGatewayModel> getPaymentGateway() async {
    try {
      String? zoneId = await PreferenceUtils.getZoneId();
      final response = await dioClient.get(
          ApiConstants.getPaymentGateway+zoneId!);
      if (response.statusCode == 200) {
        return PaymentGatewayModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<WalletTranscationModel> getWalletHistory() async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.balanceList+userId!);
      if (response.statusCode == 200) {
        return WalletTranscationModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }


  Future<ProfileModel> getProfile() async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      String? zoneId = await PreferenceUtils.getZoneId();
      final response = await dioClient.get(
          ApiConstants.getProfile+userId!+"/"+zoneId!);
      if (response.statusCode == 200) {
        return ProfileModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<ProfileModel> getProfileLogout() async {
    try {
      String? userId = await PreferenceUtils.getUserId();

      final response = await dioClient.get(
          ApiConstants.getProfileLogout+userId!);
      if (response.statusCode == 200) {
        return ProfileModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<CommonResponseModel> uploadImage(File image,UpdateProfileModel request) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final dio = Dio();

      print(request.toJson());
      FormData formData;

        String fileName = image.path.split('/').last;
        print(fileName);
        formData = FormData.fromMap({
          "image": await MultipartFile.fromFile(image.path, filename: fileName),
          "user_id": "$userId",
          "name": request.name,
          "mobile": request.mobile,
          "email": request.email,
          "dob": request.dob,
          "gender": request.gender
        });

      try {
        Response response = await dio.post(ApiConstants.profileimage, data: formData);
        if (response.statusCode == 200) {
          return CommonResponseModel.fromJson(response.data);
        } else {
          throw Exception(
              'Failed to sign in. Status code: ${response.statusCode}');
        }
      } catch (e) {
        throw e;
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<CommonResponseModel> uploadWithOutImage(UpdateProfileModel request) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final dio = Dio();
      print(request.toJson());
      FormData formData = FormData.fromMap({
          "user_id": "$userId",
          "name": request.name,
          "mobile": request.mobile,
          "email": request.email,
          "dob": request.dob,
          "gender": request.gender
        });

      try {
        Response response = await dio.post(ApiConstants.profileimage, data: formData);
        if (response.statusCode == 200) {
          return CommonResponseModel.fromJson(response.data);
        } else {
          throw Exception(
              'Failed to sign in. Status code: ${response.statusCode}');
        }
      } catch (e) {
        throw e;
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<DeliveryFeesResponse> getDeliveryFees(String km, String focusID) async {
    try {
      String? zoneId = await PreferenceUtils.getZoneId();
      final response = await dioClient.get(
          ApiConstants.getDeliveryFees+km+"/${zoneId}/$focusID");
      if (response.statusCode == 200) {
        return DeliveryFeesResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }


  Future<VendorDetailsModel> getVendorDetails(String vendor) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.getVendorDetails+vendor);
      if (response.statusCode == 200) {
        return VendorDetailsModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<CouponModel> getCouponModel() async {
    try {
      String? zoneId = await PreferenceUtils.getZoneId();
      final response = await dioClient.get(
          ApiConstants.listCoupons+zoneId!);
      if (response.statusCode == 200) {
        return CouponModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<TipsModel> getDeliveryTips() async {
    try {
      String? zoneId = await PreferenceUtils.getZoneId();
      final response = await dioClient.get(
          ApiConstants.getDeliveryTips+"/$zoneId");
      if (response.statusCode == 200) {
        return TipsModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<CommonResponseModel> updateFcmToken(String token) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      var data = {
        "fcmtoken":token,
        "user_id":userId
      };
      final response = await dioClient.post(ApiConstants.updateFcmtoken,json.encode(data));
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<DriverModel> getDriverDetails(String id) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.getDriverDetails+'$id');
      if (response.statusCode == 200) {
        return DriverModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<ZoneInformationModel> getZoneInformation() async {
    try {
      String? zoneId = await PreferenceUtils.getZoneId();
      final response = await dioClient.get(
          ApiConstants.getZoneInformation+'$zoneId');
      if (response.statusCode == 200) {
        return ZoneInformationModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<CommonResponseModel> addOrderChat(ChatRequest request) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.post(
          ApiConstants.addChat, request.toJson());
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<ChatResponse> listOrderChat(String orderId, String type, String sender) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.listChat+'$orderId/$type/$sender');
      if (response.statusCode == 200) {
        return ChatResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<SearchModel> search(String keyword) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      String? zoneId = await PreferenceUtils.getZoneId();
      String? latitude = await PreferenceUtils.getLatitude();
      String? longitude = await PreferenceUtils.getLongitude();
      final response = await dioClient.get(
          ApiConstants.search+'$zoneId/$keyword/$latitude/$longitude');
      if (response.statusCode == 200) {
        return SearchModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<CommonResponseModel> updateVendorRating(String vendorId,String rating) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.shopRating+'$rating/$userId/$vendorId');
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<VendorModel> listBannerVendor(String ids,String zoneId) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      var data = {
        "ids":ids,
      };
      final response = await dioClient.post(
          ApiConstants.listBannerVendor+'$zoneId',json.encode(data));
      if (response.statusCode == 200) {
        return VendorModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }


  Future<RazorpayOrder> createOrderId(String amount) async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.createrazorpayorderid+amount);
      if (response.statusCode == 200) {
        return RazorpayOrder.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<AppUpdateResponse> appUpdate(String version) async {
    try {
      final response = await dioClient.get(
          ApiConstants.appupdate+'$version');
      if (response.statusCode == 200) {
        return AppUpdateResponse.fromJson(response.data);
      } else {
        ValidationUtils.showAppToast(
            'Failed to sign in. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ValidationUtils.showAppToast('Error during sign in: $e');
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<CommonResponseModel> removeAccount() async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.removeAccount+'$userId');
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        ValidationUtils.showAppToast(
            'Failed to sign in. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ValidationUtils.showAppToast('Error during sign in: $e');
      print('Error during sign in: $e');
      throw e;
    }
  }

  Future<VendorTypeResponse> listVendorTypes() async {
    try {
      String? userId = await PreferenceUtils.getUserId();
      final response = await dioClient.get(
          ApiConstants.listvendortype);
      if (response.statusCode == 200) {
        return VendorTypeResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to sign in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw e;
    }
  }


  final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

}