

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:share_plus/share_plus.dart';
import 'package:userapp/constants/app_colors.dart';
import 'package:userapp/constants/app_style.dart';
import 'package:userapp/controller/auth_controller.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/navigation/page_navigation.dart';
import 'package:userapp/page/dashboard/account/edit_profile_page.dart';
import 'package:userapp/page/dashboard/dashboard_page.dart';

import '../../../utils/validation_utils.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends StateMVC<MyAccountPage> {


  late AuthController _con;

  _MyAccountPageState() : super(AuthController()) {
    _con = controller as AuthController;
  }
  File? _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.getProfile();
  }



  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        //_con.uploadImage(_image!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 120,),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                      width: 0,
                    ),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0.0),bottomRight: Radius.circular(0.0),topLeft:Radius.circular(20.0),topRight: Radius.circular(20.0) ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 100,),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Container(
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //       color: Color(0XFFF7F7F7),
                      //       border: Border.all(
                      //         color:Color(0XFFF7F7F7),
                      //         width: 0,
                      //       ),
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(12.0),
                      //       child: Row(
                      //         children: [
                      //           Icon(Icons.settings,color: AppColors.themeColor,),
                      //           SizedBox(width: 5,),
                      //           Text(
                      //             'Settings',
                      //             style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 14),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      InkWell(
                        onTap: (){
                          PageNavigation.gotoAddressPage(context,"profile");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0XFFF7F7F7),
                              border: Border.all(
                                color:Color(0XFFF7F7F7),
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(Icons.map,color: AppColors.themeColor,),
                                  SizedBox(width: 5,),
                                  Text(
                                    'Delivery Address',
                                    style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          PageNavigation.gotoHotelMyBookings(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0XFFF7F7F7),
                              border: Border.all(
                                color:Color(0XFFF7F7F7),
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(Icons.meeting_room_sharp,color: AppColors.themeColor,),
                                  SizedBox(width: 5,),
                                  Text(
                                    'My Rooms',
                                    style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: (){
                      //     PageNavigation.gotoPolicyPage(context);
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Container(
                      //       width: double.infinity,
                      //       decoration: BoxDecoration(
                      //         color: Color(0XFFF7F7F7),
                      //         border: Border.all(
                      //           color:Color(0XFFF7F7F7),
                      //           width: 0,
                      //         ),
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(12.0),
                      //         child: Row(
                      //           children: [
                      //             Icon(Icons.policy,color: AppColors.themeColor,),
                      //             SizedBox(width: 5,),
                      //             Text(
                      //               'Policy',
                      //               style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 14),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Container(
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //       color: Color(0XFFF7F7F7),
                      //       border: Border.all(
                      //         color:Color(0XFFF7F7F7),
                      //         width: 0,
                      //       ),
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(12.0),
                      //       child: Row(
                      //         children: [
                      //           Icon(Icons.help,color: AppColors.themeColor,),
                      //           SizedBox(width: 5,),
                      //           Text(
                      //             'Help',
                      //             style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 14),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            Share.share('App Link: https://thee4square.com/');
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0XFFF7F7F7),
                              border: Border.all(
                                color:Color(0XFFF7F7F7),
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(Icons.share_sharp,color: AppColors.themeColor,),
                                  SizedBox(width: 5,),
                                  Text(
                                    'Refer App',
                                    style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            _showAccountRemove(context);
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0XFFF7F7F7),
                              border: Border.all(
                                color:Color(0XFFF7F7F7),
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(Icons.remove_circle,color: AppColors.themeColor,),
                                  SizedBox(width: 5,),
                                  Text(
                                    'Remove Account',
                                    style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          _showLogoutDialog(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0XFFF7F7F7),
                              border: Border.all(
                                color:Color(0XFFF7F7F7),
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(Icons.logout,color: AppColors.themeColor,),
                                  SizedBox(width: 5,),
                                  Text(
                                    'Logout',
                                    style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _con.profileModel.data!=null ? Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    InkWell(
                      onTap: (){
                        //_pickImage(ImageSource.gallery);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(),
                          ),
                        ).then((value){
                          _con.getProfile();
                        });
                      },
                      child: Stack(
                        children: [
                          _con.profileModel.data!.image!.toLowerCase().contains("noimg") ?Image.asset("assets/images/account.png", width: 120,
                            height: 120,): ClipOval(
                            child: Image.network(
                              _con.profileModel.data!.image!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Icon(Icons.edit_calendar_outlined,color: AppColors.themeColor,),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    _con.profileModel.data!=null && _con.profileModel.data!.name!.isNotEmpty ? Text(_con.profileModel.data!.name!,style: AppStyle.font14MediumBlack87.override(color: CupertinoColors.inactiveGray,fontSize: 16),):Container(),
                    _con.profileModel.data!=null ? Text(_con.profileModel.data!.phone!,style: AppStyle.font14MediumBlack87.override(color: CupertinoColors.inactiveGray,fontSize: 16),):Container(),

                  ],
                )),
          ):Container(),
        ],
      ),
    );
  }

  void _showAccountRemove(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Text(
                'Remove Account',
                style: AppStyle.font18BoldWhite.override(
                  fontSize: 16,
                  color: AppColors.themeColor,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Are you sure you want to remove account',
                style: AppStyle.font14MediumBlack87.override(
                  fontSize: 16,
                  color: AppColors.themeColor,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Note:',
                style: AppStyle.font14MediumBlack87.override(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Once you remove your account, all associated data, including orders, services, and address details, will be permanently erased and cannot be recovered.',
                style: AppStyle.font14MediumBlack87.override(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: (){
                    _con.removeAccount(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFFC91919).withOpacity(0.8)
                  ),
                  child: Text(
                    'Remove',style: AppStyle.font14MediumBlack87.override(fontSize: 16,color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1,color: Color(0XFFC5C2C8)),
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0XFFFAF5FF),
                  ),
                  child: Text(
                    'Cancel',style: AppStyle.font14MediumBlack87.override(fontSize: 16,color: Color(0XFF403C43)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Text(
                'Logout',
                style: AppStyle.font18BoldWhite.override(
                  fontSize: 16,
                  color: AppColors.themeColor,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Are you sure you want to Log out?',
                style: AppStyle.font14MediumBlack87.override(
                  fontSize: 16,
                  color: AppColors.themeColor,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: (){
                  PageNavigation.goLogout(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFFC91919).withOpacity(0.8)
                  ),
                  child: Text(
                    'Log Out',style: AppStyle.font14MediumBlack87.override(fontSize: 16,color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1,color: Color(0XFFC5C2C8)),
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0XFFFAF5FF),
                  ),
                  child: Text(
                    'Cancel',style: AppStyle.font14MediumBlack87.override(fontSize: 16,color: Color(0XFF403C43)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
