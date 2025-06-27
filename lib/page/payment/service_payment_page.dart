


import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/controller/service_controller.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';

import '../../constants/api_constants.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/auth_controller.dart';
import '../../utils/validation_utils.dart';

class ServicePaymentPage extends StatefulWidget {

  ServiceController con;
  ServicePaymentPage(this.con, {super.key});

  @override
  _ServicePaymentPageState createState() => _ServicePaymentPageState();
}

class _ServicePaymentPageState extends StateMVC<ServicePaymentPage> {

  late AuthController _con;

  _ServicePaymentPageState() : super(AuthController()) {
    _con = controller as AuthController;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.getWalletBalance(context);
    _con.getPaymentGateway(context);

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
                                  "Amount Payable: ${ApiConstants.currency}${widget.con.serviceCharge.round()}",
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
                      InkWell(
                        onTap: (){
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
                      ),
                      Divider(color: Colors.grey,height: 30,),
                      _con.paymentGatewayModel.data!=null ?  ListView.builder(
                          shrinkWrap: true,
                          itemCount: _con.paymentGatewayModel.data!.length,
                          itemBuilder: (context,index){
                            var paymentGateway =  _con.paymentGatewayModel.data![index];
                            return InkWell(
                              onTap: (){
                                if(paymentGateway.status  == "1"){
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
                                ],
                              ),
                            );
                          }):Container(),
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
