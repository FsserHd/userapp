

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/constants/api_constants.dart';
import 'package:userapp/constants/app_style.dart';
import 'package:userapp/controller/auth_controller.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/utils/time_utils.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends StateMVC<WalletPage> {

  late AuthController _con;

  _WalletPageState() : super(AuthController()) {
    _con = controller as AuthController;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.getWalletBalance(context);
    _con.getWalletTranscation(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/wallet_bg.png"),
                  fit: BoxFit.fill,
                ),
                border: Border.all(
                  color: Colors.black,
                  width: 0,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Available Balance',
                      style: AppStyle.font14MediumBlack87.override(color: Colors.grey[200],fontSize: 18),
                    ),
                    SizedBox(height: 5,),
                    _con.walletBalanceResponse.data!=null ? Text(
                      ApiConstants.currency+_con.walletBalanceResponse.data![0].balance.toString(),
                      style: AppStyle.font14MediumBlack87.override(color: Colors.grey[200],fontSize: 18),
                    ):Container(),
                    SizedBox(height: 5,),
                    Text(
                      '4 Square Money can be used for your food orders',
                      style: AppStyle.font14RegularBlack87.override(color: Colors.grey[200],fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text(
              'Transaction History',
              style: AppStyle.font14MediumBlack87.override(color: Colors.grey[500],fontSize: 18),
            ),
            _con.walletTranscationResponse.data!=null ? ListView.builder(
              shrinkWrap: true,
              itemCount: _con.walletTranscationResponse.data!.length,
                itemBuilder: (context,index){
                var walletBean =_con.walletTranscationResponse.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                      border: Border.all(
                        color: Colors.grey.shade300, // Light gray border color
                        width: 2.0, // Border width
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              walletBean.type == "debit" ? Text(ApiConstants.currency+walletBean.amount.toString(),style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.red),):
                              Text(ApiConstants.currency+walletBean.amount.toString(),style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.green),),
                              Text(TimeUtils.getTimeStampToDate(int.parse(walletBean.date!)),style: AppStyle.font14RegularBlack87.override(fontSize: 14,color: Colors.grey),),
                              Text("last balance: ${ApiConstants.currency}${walletBean.balance}",style: AppStyle.font14RegularBlack87.override(fontSize: 10,color: Colors.grey),)
                            ],
                          ),
                          walletBean.type == "debit" ?Text(walletBean.type.toString(),style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.red),):
                          Text(walletBean.type.toString(),style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.green),),
                        ],
                      ),
                    ),
                  ),
                );
            }):Center(child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text("No Transaction History",style:AppStyle.font18BoldWhite.override(fontSize: 16)),
            )),
          ],
        ),
      ),
    );
  }
}
