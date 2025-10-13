
import 'package:flutter/material.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../navigation/page_navigation.dart';

class HotelSuccessPage extends StatefulWidget {

  const HotelSuccessPage({super.key});

  @override
  State<HotelSuccessPage> createState() => _HotelSuccessPageState();
}

class _HotelSuccessPageState extends State<HotelSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/success.png"),
            SizedBox(height: 10,),
            Text(
              "Success",
              style: AppStyle.font18BoldWhite.override(fontSize: 24,color: AppColors.themeColor),
            ),  SizedBox(height: 10,),
            Text(
              "Your booking is successfully placed",
              style: AppStyle.font18BoldWhite.override(fontSize: 18,color: AppColors.themeColor),
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                PageNavigation.gotoDashboard(context);
              },
              child: Container(
                width: 120,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.themeColor, // Gray fill color
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                ),
                child: Center(
                  child:   Text("Go Home",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
