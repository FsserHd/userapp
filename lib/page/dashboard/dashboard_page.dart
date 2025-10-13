

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/constants/app_colors.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/navigation/page_navigation.dart';
import 'package:userapp/page/auth/login/inside_login_page.dart';
import 'package:userapp/page/dashboard/account/my_account_page.dart';
import 'package:userapp/page/dashboard/home/home_page.dart';
import 'package:userapp/page/dashboard/orders/my_orders_page.dart';
import 'package:userapp/page/dashboard/service/my_service_page.dart';
import 'package:userapp/page/dashboard/wallet/wallet_page.dart';
import 'package:userapp/utils/preference_utils.dart';
import 'package:userapp/utils/validation_utils.dart';

import '../../constants/app_style.dart';
import '../../controller/home_controller.dart';
import '../auth/login/login_page.dart';

class DashboardPage extends StatefulWidget {
  static final GlobalKey<_DashboardPageState> homePageKey = GlobalKey<_DashboardPageState>();
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends StateMVC<DashboardPage>  with WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late HomeController _con;

  _DashboardPageState() : super(HomeController()) {
    _con = controller as HomeController;
  }

  int _currentIndex = 0;
  String? location = "";
  final List<Widget> _screens = [
    HomePage(),
    WalletPage(),
    MyOrderPage(),
    MyServicePage(),
    MyAccountPage(),
  ];

  late final FirebaseMessaging _firebaseMessaging;

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.call,color: Colors.green,),
                title: Text('Call Support'),
                onTap: () {
                  FlutterPhoneDirectCaller.callNumber(_con.profileModel.data!.fphone!);
                  //PageNavigation.openWhatsApp(_con.profileModel.data!.fphone!,"");
                  Navigator.pop(context);
                  // Add your action here
                },
              ),
              ListTile(
                leading: Image.asset("assets/images/whatsapp.png",height: 28,width: 28,),
                title: Text('Call Whatsapp'),
                onTap: () {
                  PageNavigation.openWhatsApp(_con.profileModel.data!.fphone!,"");
                  Navigator.pop(context);
                  // Add your action here
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _firebaseMessaging = FirebaseMessaging.instance;
    PreferenceUtils.getLocation().then((value){
      setState(() {
        location = value;
      });
    });
    _con.getAllCount();
    _con.getProfile(context);
    requestNotificationPermissions();
  }

  void requestNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      getFCMToken();
    } else {
      print('User declined or has not accepted permission');
    }
  }

  getAllCount(){
    ValidationUtils.showAppToast('test');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _con.getAllCount();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  void getFCMToken() async {
    String? token = "";
    if(Platform.isAndroid){
      token = await _firebaseMessaging.getToken();
    }else {
      token = await _firebaseMessaging.getAPNSToken();
    }
    print('FCM Token: $token');
    _con.updateFcmToken(context, token!);
  }

  DateTime? lastPressed;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        final maxDuration = Duration(seconds: 2);

        if (lastPressed == null || now.difference(lastPressed!) > maxDuration) {
          lastPressed = now;
          final snackBar = SnackBar(content: Text('Press back again to exit'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60), // Set this height
          child: Container(
            color: AppColors.themeColor,
            child:Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      _scaffoldKey.currentState!.openDrawer();
                    },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset("assets/images/drawer.png"),
                      )),
                  InkWell(
                    onTap: () async {
                      String?  userId = await PreferenceUtils.getUserId();
                      if(userId ==null){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InsideLoginPage(),
                          ),
                        );
                      }else {
                        PageNavigation.gotoAddressPage(context, "home");
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Your Location",style: AppStyle.font14RegularBlack87.override(color: Colors.white,fontSize: 13)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.location_pin,color: Colors.white,size: 14,),
                            SizedBox(width: 2,),
                            Container(width:200,child: Text(location!,overflow: TextOverflow.ellipsis,maxLines: 1,style: AppStyle.font14RegularBlack87.override(color: Colors.white,fontSize: 13))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          //FlutterPhoneDirectCaller.callNumber(_con.profileModel.data!.fphone!);
                          //PageNavigation.openWhatsApp(_con.profileModel.data!.fphone!,"");
                          _showBottomSheet(context);
                        },
                          child: Image.asset("assets/images/call.png",height: 24,width: 24,color: Colors.white,)),
                      SizedBox(width: 5,),
                      Stack(
                        children: [
                          IconButton(
                            icon: Icon(Icons.shopping_cart, color: Colors.white),
                            onPressed: () {
                              _con.dbHelper.getCartCount().then((value){
                                setState(() {
                                  if(value!>0){
                                     PageNavigation.gotoCheckOutPage(context);
                                  }else{
                                    ValidationUtils.showAppToast("Cart is empty");
                                  }
                                });
                              });
                            },
                          ),
                          // Positioned(
                          //   right: 6,
                          //   top: 6,
                          //   child: Container(
                          //     padding: EdgeInsets.all(2),
                          //     decoration: BoxDecoration(
                          //       color: Colors.red,
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     constraints: BoxConstraints(
                          //       minWidth: 16,
                          //       minHeight: 16,
                          //     ),
                          //     child: Text(
                          //       _con.cartCount.toString(),
                          //       style: TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 10,
                          //       ),
                          //       textAlign: TextAlign.center,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(width: 10,),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        drawer:Drawer(
          width: 260,
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 80,),
                          _con.profileModel.data!=null ?_con.profileModel.data!.image!.contains("noimg")  ? Image.asset("assets/images/profile.png"):ClipOval(
                            child: Image.network(
                              _con.profileModel.data!.image!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ):Container(),
                          SizedBox(height: 4,),
                          _con.profileModel.data!= null ? Text(
                            _con.profileModel.data!.phone!,
                            style: AppStyle.font18BoldWhite.override(fontSize: 14,color: Colors.white),
                          ):Container(),
                          SizedBox(height: 40,),
                        ],
                      ),
                      width: double.infinity,
                      color: AppColors.themeColor,
                    ),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        PageNavigation.gotoPrivacyPolicy(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.policy,color: AppColors.themeColor,),
                            SizedBox(width: 8,),
                            Text(
                              "Privacy Policy",
                              style: AppStyle.font14RegularBlack87.override(fontSize: 16,color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      onTap: (){
                        PageNavigation.gotoTermsConditions(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.policy_outlined,color: AppColors.themeColor,),
                            SizedBox(width: 8,),
                            Text(
                              "Terms and Conditions",
                              style: AppStyle.font14RegularBlack87.override(fontSize: 16,color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      onTap: (){
                        PageNavigation.gotoRefundPolicy(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.policy_outlined,color: AppColors.themeColor,),
                            SizedBox(width: 8,),
                            Text(
                              "Refund and Return Policy",
                              style: AppStyle.font14RegularBlack87.override(fontSize: 16,color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     children: [
                    //       Icon(Icons.person,color: AppColors.themeColor,),
                    //       SizedBox(width: 8,),
                    //       Text(
                    //         "Support",
                    //         style: AppStyle.font14MediumBlack87.override(fontSize: 16,color: Colors.black),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 10,),
                    InkWell(
                      onTap: (){
                        PageNavigation.goLogout(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.logout,color: AppColors.themeColor,),
                            SizedBox(width: 8,),
                            Text(
                              "Logout",
                              style: AppStyle.font14RegularBlack87.override(fontSize: 16,color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.themeColor,
          unselectedItemColor: Colors.white, // Unselected icon color
          selectedItemColor: Colors.black45, // Selected icon color
          currentIndex: _currentIndex,
          selectedLabelStyle: AppStyle.font14MediumBlack87,
          unselectedLabelStyle: AppStyle.font14RegularBlack87,
          onTap: (index) async {
            // Navigate to the selected screen
            print(index);
            String?  userId = await PreferenceUtils.getUserId();
            if(userId ==null && index!=0){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InsideLoginPage(),
                ),
              );
            }else {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.propane),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cleaning_services),
              label: 'Service',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz_sharp),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
