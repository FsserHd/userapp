


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/constants/api_constants.dart';
import 'package:userapp/controller/cart_controller.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/utils/validation_utils.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/auth_controller.dart';
import '../../controller/home_controller.dart';

class PaymentPage extends StatefulWidget {
  CartController con;
  PaymentPage(this.con, {super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends StateMVC<PaymentPage> {

  late AuthController _con;

  _PaymentPageState() : super(AuthController()) {
    _con = controller as AuthController;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.getWalletBalance(context);
    _con.getPaymentGateway(context);
    widget.con.getTotalPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dashboardBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Payment",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              children: [
                                SizedBox(height: 10,),
                                Text(
                                  "Amount Payable: ${ApiConstants.currency}${widget.con.allTotalPrice.round()}",
                                  style: AppStyle.font14MediumBlack87.override(fontSize: 16,color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
           SizedBox(height: 10,),
           Card(
             child: Container(
               width: double.infinity,
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(15.0),
                 border: Border.all(
                   color: Colors.white,
                   width: 2.0,
                 ),
               ),
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text("Select payment options",style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 15),),
                     ),
                     SizedBox(height: 10,),
                     _con.paymentGatewayModel.cod!=null && _con.paymentGatewayModel.cod == "1" ?  InkWell(
                       onTap: (){
                         widget.con.checkOut.payment.paymentType = "cod";
                         widget.con.checkOut.payment.method = "cod";
                         Navigator.pop(context,"cod");
                       },
                       child: Row(
                         mainAxisSize: MainAxisSize.max,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Row(
                             children: [
                               Image.asset("assets/images/cod.png",height: 30,width: 30,),
                               SizedBox(width: 10,),
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text("Cash on Delivery",style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 15),),
                                 ],
                               ),
                             ],
                           ),
                           Icon(Icons.arrow_right),
                         ],
                       ),
                     ):Container(),
                     Divider(color: Colors.grey,height: 30,),
                     _con.paymentGatewayModel.data!=null ?  ListView.builder(
                       padding: EdgeInsets.zero,
                         shrinkWrap: true,
                         itemCount: _con.paymentGatewayModel.data!.length,
                         itemBuilder: (context,index){
                           var paymentGateway =  _con.paymentGatewayModel.data![index];
                           return InkWell(
                             onTap: (){
                                if(paymentGateway.status  == "1"){
                                  widget.con.checkOut.payment.paymentType = "online";
                                  widget.con.checkOut.payment.method = "online";
                                  Navigator.pop(context,"online");
                                }else{
                                  ValidationUtils.showAppToast("Not installed");
                                }
                             },
                             child: Column(
                               children: [
                                 Row(
                                   mainAxisSize: MainAxisSize.max,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Row(
                                       children: [
                                         Image.network(paymentGateway.image!,height: 30,width: 30,),
                                         SizedBox(width: 10,),
                                         Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Text(paymentGateway.name!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 15),),
                                           ],
                                         ),
                                       ],
                                     ),
                                     Icon(Icons.arrow_right),
                                   ],
                                 ),
                                 Divider(color: Colors.grey,height: 30,),
                               ],
                             ),
                           );
                         }):Container(),
                     InkWell(
                       onTap: (){
                         double walletAmount = double.parse(_con.walletBalanceResponse.data![0].balance!);
                         double totalAmount  = widget.con.allTotalPrice;
                         if(totalAmount <= walletAmount) {
                           widget.con.checkOut.payment.paymentType = "wallet";
                           widget.con.checkOut.payment.method = "wallet";
                           Navigator.pop(context, "wallet");
                         }else{
                           ValidationUtils.showAppToast("Wallet balance is low");
                         }
                       },
                       child: Row(
                         mainAxisSize: MainAxisSize.max,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Row(
                             children: [
                               Image.asset("assets/images/online.png",height: 30,width: 30),
                               SizedBox(width: 10,),
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text("Wallet",style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 15),),
                                   _con.walletBalanceResponse.data!=null ? Text("Balance:${ApiConstants.currency}${_con.walletBalanceResponse.data![0].balance}",style: AppStyle.font14RegularBlack87.override(color: Colors.green,fontSize: 12),):Container(),
                                 ],
                               ),
                             ],
                           ),
                           Icon(Icons.arrow_right),
                         ],
                       ),
                     ),
                     SizedBox(height: 10,),
                   ],
                 ),
               ),
             ),
           )
          ],
        ),
      ),
    );
  }
}
