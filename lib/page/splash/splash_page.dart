

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/auth_controller.dart';
import '../../navigation/page_navigation.dart';
import '../../utils/preference_utils.dart';

class SplashPage extends StatefulWidget {

  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends StateMVC<SplashPage> {

  late AuthController _con;
  String version = '';
  String buildNumber = '';
  String packageName = 'com.fsserhd.user';

  _SplashPageState() : super(AuthController()) {
    _con = controller as AuthController;
  }

  late StreamSubscription<ConnectivityResult> _subscription;
  bool _isDialogOpen = false;


  @override
  void initState() {
    super.initState();
    // Timer(const Duration(seconds: 3), () async {
    //   String? userId = await PreferenceUtils.getUserId();
    //   if(userId!=null){
    //     PageNavigation.gotoLocationPage(context);
    //   }else{
    //     PageNavigation.gotoLoginScreen(context);
    //   }
    // });
    _getVersionInfo(context);
  }


  Future<void> _getVersionInfo(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // Update state synchronously
    setState(() {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });

    // Call app update API
    await _con.appUpdate(version);

    print(_con.appUpdateResponse.toJson());

    if (_con.appUpdateResponse.isMaintenance == true) {
      _showMaintenanceDialog(context);
    } else if (_con.appUpdateResponse.isAllow == true) {
      _showAlertDialog(context);
    } else {
      String? userId = await PreferenceUtils.getUserId();
      if (userId != null) {
        _con.getProfileLogout(context);
      } else {
        print("goto location");
        if(Platform.isAndroid){
          PageNavigation.gotoLoginScreen(context);
        }else{
          PageNavigation.gotoLocationPage(context);
        }
      }
    }
  }



  void _showMaintenanceDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/under.png"),
                SizedBox(height: 16),
                Text(
                  'Sorry under maintenance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: (){
                        openSupport();
                      },
                      child: Container(
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.themeColor,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                          child:   Text("Support",style: AppStyle.font14MediumBlack87.override(color: Colors.white,fontSize: 14)),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/updated.png"),
                SizedBox(height: 16),
                Text(
                  'Time to fuel up app for more features',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _con.appUpdateResponse.isForceUpdate == false ? InkWell(
                      onTap: () async {
                        String? userId = await PreferenceUtils.getUserId();
                        if(userId!=null){
                          PageNavigation.gotoLocationPage(context);
                        }else{
                          PageNavigation.gotoLoginScreen(context);
                        }
                      },
                      child: Container(
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.themeColor,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                          child:   Text("Skip",style: AppStyle.font14MediumBlack87.override(color: Colors.white,fontSize: 14)),
                        ),
                      ),
                    ):Container(),
                    SizedBox(width: 20,),
                    InkWell(
                      onTap: (){
                        _openPlayStore();
                      },
                      child: Container(
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.themeColor,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                          child:   Text("Update",style: AppStyle.font14MediumBlack87.override(color: Colors.white,fontSize: 14)),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openPlayStore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    final String appUrl = 'market://details?id=$packageName';
    final String webUrl = 'https://play.google.com/store/apps/details?id=$packageName';

    if (await canLaunchUrl(Uri.parse(appUrl))) {
      // Open Play Store app if available
      await launchUrl(Uri.parse(appUrl));
    } else {
      // Fallback to web URL
      if (await canLaunchUrl(Uri.parse(webUrl))) {
        await launchUrl(Uri.parse(webUrl));
      } else {
        throw 'Could not launch $webUrl';
      }
    }
  }

  Future<void> openSupport() async {
    final String webUrl = 'https://thee4square.com/';
    await launchUrl(Uri.parse(webUrl));
  }



  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Icon(Icons.location_off_outlined,color: Colors.red,size: 40,),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Device location not enabled",style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 12),),
                      Text("Ensure your device location for a better delivery",style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 8),),
                      SizedBox(height: 10,),
                      InkWell(
                        onTap: () async {

                        },
                        child: Container(
                          width: 120,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.themeColor, // Gray fill color
                            borderRadius: BorderRadius.circular(15.0), // Rounded corners
                          ),
                          child: Center(
                            child:   Text("Enable",style: AppStyle.font14MediumBlack87.override(color: Colors.white,fontSize: 12)),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),

            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset("assets/images/splash.png",height: 350,width: 350,),
          ],
        ),
      ),
    );
  }
}
