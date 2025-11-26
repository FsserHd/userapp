

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/model/common/common_response_model.dart';
import 'package:userapp/model/login/otp_model.dart';
import 'package:userapp/model/payment/payment_gateway_model.dart';
import 'package:userapp/model/profile/profile_model.dart';
import 'package:userapp/model/wallet/wallet_balance_response.dart';
import 'package:userapp/model/wallet/wallet_transcation_model.dart';
import 'package:userapp/page/dashboard/dashboard_page.dart';

import '../constants/lang.dart';
import '../model/login/login_model.dart';
import '../model/profile/update_profile_model.dart';
import '../model/update/app_update_response.dart';
import '../navigation/page_navigation.dart';
import '../network/api_service.dart';
import '../utils/loader.dart';
import '../utils/preference_utils.dart';
import '../utils/validation_utils.dart';

class AuthController extends ControllerMVC{

  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  var loginModel = LoginModel();
  var otpModel = OtpModel();
  var profileModel = ProfileModel();
  var commonResponseModel = CommonResponseModel();
  var walletBalanceResponse = WalletBalanceResponse();
  var paymentGatewayModel = PaymentGatewayModel();
  var walletTranscationResponse = WalletTranscationModel();
  var appUpdateResponse = AppUpdateResponse();
  var mobileController  =TextEditingController();
  var emailController  =TextEditingController();
  var dobController  =TextEditingController();
  var nameController  =TextEditingController();
  var genderType = "Select Gender";
  DashboardPage dashboardPage = DashboardPage();

  //Network Service
  ApiService apiService = ApiService();

  login(BuildContext context, String mobile){
    loginModel.phone = mobile;
    if(ValidationUtils.emptyValidation(loginModel.phone!) && loginModel.phone!.length ==10) {
      Loader.show();
      apiService.signIn(loginModel).then((value) {
        Loader.hide();
        if(value.success!){
          PageNavigation.gotoOtpPage(context,mobile,value.data!.id);
         // PageNavigation.gotoLocationPage(context);
        }else{
          ValidationUtils.showAppToast(S.of(context, "login_wrong_input"));
        }
      }).catchError((e) {
        Loader.hide();
        //ValidationUtils.showAppToast(S.of(context, "something_wrong"));
        print(e);
      });
    }else{
      ValidationUtils.showAppToast("Invalid Mobile Number");
    }
  }

  insideLogin(BuildContext context, String mobile){
    loginModel.phone = mobile;
    if(ValidationUtils.emptyValidation(loginModel.phone!) && loginModel.phone!.length ==10) {
      Loader.show();
      apiService.signIn(loginModel).then((value) {
        Loader.hide();
        if(value.success!){
          PageNavigation.gotoInsideOtpPage(context,mobile,value.data!.id);
          // PageNavigation.gotoLocationPage(context);
        }else{
          ValidationUtils.showAppToast(S.of(context, "login_wrong_input"));
        }
      }).catchError((e) {
        Loader.hide();
        //ValidationUtils.showAppToast(S.of(context, "something_wrong"));
        print(e);
      });
    }else{
      ValidationUtils.showAppToast("Invalid Mobile Number");
    }
  }

  loginOtp(BuildContext context,String mobile){
    Loader.show();
    apiService.loginOtp(mobile).then((value) {
      Loader.hide();
      if(value.success!){
        otpModel = value;
        notifyListeners();
      }else{
       // ValidationUtils.showAppToast(S.of(context, "something_wrong"));
      }
    }).catchError((e) {
      Loader.hide();
     // ValidationUtils.showAppToast(S.of(context, "something_wrong"));
      print(e);
    });
  }

  getWalletBalance(BuildContext context){
    Loader.show();
    apiService.getWalletBalance().then((value) {
      Loader.hide();
      if(value.success!){
        walletBalanceResponse = value;
        notifyListeners();
      }else{
        //ValidationUtils.showAppToast(S.of(context, "something_wrong"));
      }
    }).catchError((e) {
      Loader.hide();
     // ValidationUtils.showAppToast(S.of(context, "something_wrong"));
      print(e);
    });
  }

  getPaymentGateway(BuildContext context){
    Loader.show();
    apiService.getPaymentGateway().then((value) {
      Loader.hide();
      if(value.success!){
        paymentGatewayModel = value;
        notifyListeners();
      }else{
       // ValidationUtils.showAppToast(S.of(context, "something_wrong"));
      }
    }).catchError((e) {
      Loader.hide();
      //ValidationUtils.showAppToast(S.of(context, "something_wrong"));
      print(e);
    });
  }

  getWalletTranscation(BuildContext context){
    Loader.show();
    apiService.getWalletHistory().then((value) {
      Loader.hide();
      if(value.success!){
        walletTranscationResponse = value;
        notifyListeners();
      }else{
       // ValidationUtils.showAppToast(S.of(context, "something_wrong"));
      }
    }).catchError((e) {
      Loader.hide();
      //ValidationUtils.showAppToast(S.of(context, "something_wrong"));
      print(e);
    });
  }



  getProfile(){
    Loader.show();
    apiService.getProfile().then((value){
      Loader.hide();
      if(value.success!){
        setState(() {
          profileModel = value;
        });
        setState(() {
          mobileController.text = profileModel.data!.phone!;
          nameController.text = profileModel.data!.name!;
          emailController.text = profileModel.data!.email!;
          dobController.text = profileModel.data!.dob!;
          if(profileModel.data!.gender!.isNotEmpty) {
            genderType = profileModel.data!.gender!;
          }else{
            genderType = "Select Gender";
          }
        });
        notifyListeners();
      }else{
       // ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }
 var updateProfileRequest = UpdateProfileModel();

  uploadWithImage(File? file, BuildContext context){
    Loader.show();
    apiService.uploadImage(file!,updateProfileRequest).then((value){
      Loader.hide();
      if(value.success!){
        commonResponseModel = value;
        ValidationUtils.showAppToast("Update Successfully");
        Navigator.pop(context);
        notifyListeners();
      }else{
        //ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }

  uploadWithOutImage(BuildContext context){
    Loader.show();
    apiService.uploadWithOutImage(updateProfileRequest).then((value){
      Loader.hide();
      if(value.success!){
        commonResponseModel = value;
        ValidationUtils.showAppToast("Update Successfully");
        Navigator.pop(context);
        notifyListeners();
      }else{
       // ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }

  Future<bool> appUpdate(String keywords) async {
    await apiService.appUpdate(keywords).then((value) async {
      if(value.success!){
        appUpdateResponse = value;
      }
      return true;
    }).catchError((e){
      print(e);
    });
    return true;
  }

  getProfileLogout(BuildContext context){
    Loader.show();
    apiService.getProfileLogout().then((value) async {
      Loader.hide();
      if(value.success!){
        profileModel = value;
        print(profileModel.toJson());
        if(profileModel.data!.isLogout! == "true"){
          PageNavigation.gotoLocationPage(context);
        }else{
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.clear();
          PageNavigation.gotoLoginScreen(context);
        }
        notifyListeners();
      }else{
        ValidationUtils.showAppToast("Something wrong");
      }
    }).catchError((e){
      print(e);
      Loader.hide();
    });
  }

  removeAccount(BuildContext context) async {
    Loader.show();
    await apiService.removeAccount().then((value) async {
      Loader.hide();
      PageNavigation.goLogout(context);
    }).catchError((e){
      Loader.hide();
      print(e);
    });
  }

}