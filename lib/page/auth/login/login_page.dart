

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/constants/app_colors.dart';
import 'package:userapp/controller/auth_controller.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';

import '../../../constants/app_style.dart';
import '../../../navigation/page_navigation.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends StateMVC<LoginPage> {

  late AuthController _con;

  _LoginPageState() : super(AuthController()) {
    _con = controller as AuthController;
  }

  var mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login_bg.png'),
              fit: BoxFit.cover,
            ),
            color: Colors.white
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo.png",height: 200,),
                Text("Hey there!",style: AppStyle.font22BoldWhite.override(color: Colors.black)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Let’s get login or signup with your Mobile Number",style: AppStyle.font14MediumBlack87.override(color: Colors.blue,fontSize: 18),textAlign: TextAlign.center,),
                ),
                SizedBox(height:20,),
                Padding(
                  padding: const EdgeInsets.only(left: 40,right: 40),
                  child: Container(
                    height: 52,
                    child: TextField(
                      controller: mobileController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.themeLightColor, // Gray fill color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: AppColors.themeColor,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: AppColors.themeColor,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: AppColors.themeColor,
                            width: 1.0,
                          ),
                        ),
                        hintText: 'Enter Mobile Number',
                        hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black)
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    _con.login(context,mobileController.text);
                    //PageNavigation.gotoOtpPage(context,"","");
                  },
                  child: Container(
                    width: 138,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.themeColor, // Gray fill color
                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    ),
                    child: Center(
                      child:   Text("Continue",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                    ),
                  ),
                ),
                // SizedBox(height: 20,),
                // Image.asset("assets/images/or.png"),
                // SizedBox(height: 20,),
                // Image.asset("assets/images/google.png"),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(top: 10,left: 20,right: 20),
                  child: Column(
                    children: [
                      Text("By continuing, you agree to our",
                          style: AppStyle.font14MediumBlack87.override(color: Colors.grey),textAlign: TextAlign.center,),
                      SizedBox(height: 10,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            child: Text("Terms & Conditions",
                              style: AppStyle.font14MediumBlack87.override(color: Colors.grey,),textAlign: TextAlign.center,),
                            onTap: (){
                              PageNavigation.gotoTermsConditions(context);
                            },
                          ),
                          InkWell(
                            onTap: (){
                              PageNavigation.gotoPrivacyPolicy(context);
                            },
                            child: Text("Privacy Policy",
                              style: AppStyle.font14MediumBlack87.override(color: Colors.grey),textAlign: TextAlign.center,),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
