

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/constants/app_colors.dart';
import 'package:userapp/constants/app_style.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/navigation/page_navigation.dart';
import 'package:userapp/utils/validation_utils.dart';

import '../../../controller/auth_controller.dart';
import '../../../utils/preference_utils.dart';

class OtpPage extends StatefulWidget {
  String mobile;
  String? id;
  OtpPage(this.mobile,this.id, {super.key});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends StateMVC<OtpPage> {
  late AuthController _con;

  _OtpPageState() : super(AuthController()) {
    _con = controller as AuthController;
  }

  int _remainingTime = 60;
  Timer? _timer;
  final _otpControllers = List<TextEditingController>.generate(5, (index) => TextEditingController());
  final _otpFocusNodes = List<FocusNode>.generate(5, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    _con.loginOtp(context, widget.mobile);
    _startTimer();
    for (int i = 0; i < 5; i++) {
      _otpControllers[i].addListener(() {
        if (_otpControllers[i].text.length == 1 && i < 4) {
          _otpFocusNodes[i + 1].requestFocus();
        }
      });
    }
  }


  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white, // Light gray fill color
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.themeColor, width: 3),
              ),
              child: Center(
                child: Text(
                  '$_remainingTime s',
                  style: AppStyle.font14MediumBlack87.override(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text("OTP Verification",style: AppStyle.font22BoldWhite.override(color: Colors.black)),
            Text("The otp send via call to ${widget.mobile}",style: AppStyle.font14MediumBlack87.override(color: Colors.blue)),
            SizedBox(height: 20,),

            OtpTextField(
              numberOfFields: 5,
              fieldWidth: 50,
              fieldHeight: 50,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.themeLightColor,
                counterText: '', // Hide the counter text
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: AppColors.themeColor, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: AppColors.themeColor, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: AppColors.themeColor, width: 2.0),
                ),
              ),
              hasCustomInputDecoration: true,
              fillColor: AppColors.themeLightColor,
              borderColor: AppColors.themeColor,
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode){
                if(verificationCode.length==5){
                  if(_con.otpModel.otp.toString() == verificationCode){
                    PreferenceUtils.saveUserId(widget.id!);
                    PageNavigation.gotoLocationPage(context);
                  }else{
                    ValidationUtils.showAppToast("Invalid Otp");
                  }
                }else{
                  ValidationUtils.showAppToast("Otp Required");
                }
                // showDialog(
                //     context: context,
                //     builder: (context){
                //       return AlertDialog(
                //         title: Text("Verification Code"),
                //         content: Text('Code entered is $verificationCode'),
                //       );
                //     }
                // );
              }, // end onSubmit
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: List.generate(5, (index) {
            //       return SizedBox(
            //         width: 50,
            //         height: 50,
            //         child: TextFormField(
            //           controller: _otpControllers[index],
            //           focusNode: _otpFocusNodes[index],
            //           keyboardType: TextInputType.number,
            //           textAlign: TextAlign.center,
            //           maxLength: 1,
            //           style: TextStyle(fontSize: 16),
            //           decoration: InputDecoration(
            //             filled: true,
            //             fillColor: AppColors.themeLightColor,
            //             counterText: '', // Hide the counter text
            //             border: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(10.0),
            //               borderSide: BorderSide(color: AppColors.themeColor, width: 2.0),
            //             ),
            //             enabledBorder: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(10.0),
            //               borderSide: BorderSide(color: AppColors.themeColor, width: 2.0),
            //             ),
            //             focusedBorder: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(10.0),
            //               borderSide: BorderSide(color: AppColors.themeColor, width: 2.0),
            //             ),
            //           ),
            //           onChanged: (value) {
            //             if (value.isNotEmpty && index < 4) {
            //               FocusScope.of(context).nextFocus();
            //             }
            //           },
            //         ),
            //       );
            //     }),
            //   ),
            // ),
            SizedBox(height: 40,),
            InkWell(
              onTap: (){
                String otp = "";
                _otpControllers.forEach((element) {
                  otp += element.text;
                });
                if(otp.length==5){
                  if(_con.otpModel.otp.toString() == otp){
                    PreferenceUtils.saveUserId(widget.id!);
                    PageNavigation.gotoLocationPage(context);
                  }else{
                    ValidationUtils.showAppToast("Invalid Otp");
                  }
                }else{
                  ValidationUtils.showAppToast("Otp Required");
                }
              },
              child: Container(
                width: 138,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.themeColor, // Gray fill color
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                ),
                child: Center(
                  child:   Text("Verify",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                ),
              ),
            ),
            SizedBox(height: 40,),
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Is there any changes",style: AppStyle.font14MediumBlack87.override(color: Colors.black)),
                  Text(" Go back",style: AppStyle.font18BoldWhite.override(color: Colors.black,decoration: TextDecoration.underline)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
