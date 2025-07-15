
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:userapp/constants/api_constants.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/model/service/add_service_request.dart';
import 'package:userapp/model/service/service_category_model.dart';
import 'package:userapp/page/payment/service_payment_page.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/service_controller.dart';
import '../../utils/preference_utils.dart';

class ServiceCheckOutPage extends StatefulWidget {
  AddServiceRequest addServiceRequest;
  //List<ServiceCategory> selectedCategoryIndices;
  List<String> selectCategoryList;
  List<ServiceCategory> selectedCategoryIndices;
  String serviceInput;
  ServiceCategory? selectedCategory;
  ServiceCheckOutPage(this.addServiceRequest, this.selectCategoryList,this.selectedCategoryIndices, this.serviceInput, this.selectedCategory, {super.key});

  @override
  _ServiceCheckOutPageState createState() => _ServiceCheckOutPageState();
}

class _ServiceCheckOutPageState extends StateMVC<ServiceCheckOutPage> {

  late ServiceController _con;

  _ServiceCheckOutPageState() : super(ServiceController()) {
    _con = controller as ServiceController;
  }
  String? distance = "";
  String category = "";
  String paymentMode = "Cash on delivery";
  var razorpay = Razorpay();


  void handlePaymentErrorResponse(PaymentFailureResponse response){
    // showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");

  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){
    // showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
    _con.checkOutService(context, widget.addServiceRequest);

  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    //showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.addServiceRequest.toJson());
    // widget.selectedCategoryIndices.forEach((element) {
    //   setState(() {
    //     serviceCharge = serviceCharge + double.parse(element.maxPrice!);
    //   });
    // });
    widget.selectedCategoryIndices.forEach((element) {
      if(element.paymenttype == "1"){
        setState(() {
          paymentMode = "Online";
        });
      }
    });
    category = widget.selectCategoryList.join(",");
    _con.getDistance2(widget.addServiceRequest.fLatitude!, widget.addServiceRequest.fLongitude!, widget.addServiceRequest.tLatitude!, widget.addServiceRequest.tLongitude!).then((value){
      setState(() {
        distance = value;
        if(widget.selectedCategory == null){
          _con.getServiceDeliveryFees(context, distance!,"1");
        }else{
          _con.getServiceDeliveryFees(context, distance!,widget.selectedCategory!.maincategory);
        }
      });
    });
  }

  goOnlinePayment() async {
    String? phone =await PreferenceUtils.getUserPhone();
    var options = {
      'key': 'rzp_live_Qdir89rIuPxK1S',
      'amount': _con.serviceCharge * 100,
      'name': '',
      'order_id':_con.orderId,
      'description': 'Online Payment',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '${phone}'},
      'external': {
        'wallets': ['paytm']
      }
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:  AppBar(
        backgroundColor: AppColors.themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Checkout",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Service Details:",style: TextStyle(color: AppColors.themeColor,fontFamily: AppStyle.robotoBold,fontSize: 16),),
            ),
            SizedBox(height: 10,),
            Divider(color: Colors.grey,),
            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Given Service Input:',
                    style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.black87),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.white, // Gray color fill
                      borderRadius: BorderRadius.circular(20), // Border radius
                      border: Border.all(
                        color: Colors.black87, // Border color
                        width: 1, // Border width
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.serviceInput,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyle.font14RegularBlack87.override(fontSize: 14),
                              ),
                            ),
                            SizedBox(width: 20,),
                            Image.asset("assets/images/p_location.png"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Gray color fill
                      borderRadius: BorderRadius.circular(10), // Border radius
                      border: Border.all(
                        color: AppColors.lightGray, // Border color
                        width: 1, // Border width
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded,color: AppColors.themeColor,),
                            SizedBox(width: 10,),
                            Text("From",style: AppStyle.font18BoldWhite.override(color: AppColors.themeColor),),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Text(widget.addServiceRequest.fromlocation!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name",style: AppStyle.font18BoldWhite.override(color: Colors.grey,fontSize: 12),),
                                Text(widget.addServiceRequest.fromname!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Mobile",style: AppStyle.font18BoldWhite.override(color: Colors.grey,fontSize: 12),),
                                Text(widget.addServiceRequest.fphoneno!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),),
                              ],
                            ),
                          ],
                        ),
                          SizedBox(height: 5,),
                          Text("Date & Time: ${widget.addServiceRequest.fromtime}",style: AppStyle.font18BoldWhite.override(color: Colors.grey,fontSize: 12),),
                      ],),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Gray color fill
                      borderRadius: BorderRadius.circular(10), // Border radius
                      border: Border.all(
                        color: AppColors.lightGray, // Border color
                        width: 1, // Border width
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded,color: AppColors.themeColor,),
                              SizedBox(width: 10,),
                              Text("Shipping to",style: AppStyle.font18BoldWhite.override(color:AppColors.themeColor),),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Text(widget.addServiceRequest.tolocation!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Name",style: AppStyle.font18BoldWhite.override(color: Colors.grey,fontSize: 12),),
                                  Text(widget.addServiceRequest.toname!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Mobile",style: AppStyle.font18BoldWhite.override(color: Colors.grey,fontSize: 12),),
                                  Text(widget.addServiceRequest.tophoneno!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Text("Details:",style: AppStyle.font18BoldWhite.override(color: Colors.grey,fontSize: 12),),
                          Text(widget.addServiceRequest.description!,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  // Row(
                  //   children: [
                  //     Icon(Icons.type_specimen,color: Colors.grey,),
                  //     SizedBox(width: 10,),
                  //     Text("Service Category",style: AppStyle.font14MediumBlack87.override(color: Colors.grey),),
                  //   ],
                  // ),
                  // SizedBox(height: 5,),
                  // Text(category,style: AppStyle.font18BoldWhite.override(color: Colors.black,fontSize: 12)),
                  // SizedBox(height: 20,),
                  // GridView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: widget.selectedCategoryIndices.length,
                  //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 3, // Number of columns
                  //     crossAxisSpacing: 4.0, // Horizontal spacing between items
                  //     mainAxisSpacing: 4.0, // Vertical spacing between items
                  //     childAspectRatio: 0.7, // Aspect ratio of each item
                  //   ),
                  //   itemBuilder: (context, index) {
                  //     var categoryBean = widget.selectedCategoryIndices[index];
                  //
                  //     return Stack(
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Column(
                  //             children: [
                  //               Container(
                  //                 width: 100,
                  //                 height: 100,
                  //                 decoration: BoxDecoration(
                  //                   color: AppColors.dashboardShopTypeColor, // Gray background color
                  //                   borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  //                 ),
                  //                 padding: EdgeInsets.all(10.0), // Padding for inner content
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: AppColors.dashboardShopTypeColor, // White background color for inner container
                  //                     borderRadius: BorderRadius.circular(8.0), // Rounded corners for inner container
                  //                   ),
                  //                   padding: EdgeInsets.all(10.0), // Padding for icon
                  //                   child: Image.network(categoryBean.image!, height: 30, width: 30,),
                  //                 ),
                  //               ),
                  //               SizedBox(height: 10,),
                  //               Text(categoryBean.name!, style: AppStyle.font14MediumBlack87.override(color: Colors.black)),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // ),
                  Text("Payment Details",style: TextStyle(color: AppColors.themeColor,fontFamily: AppStyle.robotoBold,fontSize: 16,),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Distance",style: AppStyle.font14MediumBlack87.override(color: Colors.black),),
                      Text(distance!,style: AppStyle.font14MediumBlack87.override(color: Colors.black),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  _con.deliverFeesModel.data!=null ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Service Charge",style: AppStyle.font14MediumBlack87.override(color: Colors.black),),
                      Text(ApiConstants.currency+_con.serviceCharge.toStringAsFixed(0)!,style: AppStyle.font14MediumBlack87.override(color: Colors.black),),
                    ],
                  ):Container(),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Payment Mode",style: AppStyle.font14MediumBlack87.override(color: Colors.black),),
                      Text(paymentMode,style: AppStyle.font14MediumBlack87.override(color: Colors.black),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Divider(color: AppColors.lightGray,),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Grand Total",style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 16),),
                      Text(ApiConstants.currency+_con.serviceCharge.toString(),style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 16),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  InkWell(
                    onTap: (){
                      widget.addServiceRequest.distance1 = distance;
                      widget.addServiceRequest.deliveryfees = _con.serviceCharge.toString();
                      //widget.addServiceRequest.types = widget.selectCategoryList.join(",");
                      widget.addServiceRequest.types = widget.serviceInput;
                      widget.addServiceRequest.paymentMode = paymentMode;
                      if(widget.selectedCategory == null){
                        widget.addServiceRequest.maincategory = "1";
                      }else{
                        widget.addServiceRequest.maincategory = widget.selectedCategory!.maincategory;
                      }

                      //     .map((category) => category.id)
                      //     .where((id) => id != null)
                      //     .join(',');
                     // widget.addServiceRequest.types = "";
                      print(widget.addServiceRequest.toJson());
                      if(paymentMode == "Online"){
                          _con.createOrderId(context, _con.serviceCharge.toString()).then((value){
                             goOnlinePayment();
                            //_con.checkOutService(context, widget.addServiceRequest);
                          });
                      }else{
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServicePaymentPage(_con),
                          ),
                        ).then((value){
                          setState(() {
                            if(value == "online"){
                              paymentMode = "Online";
                              widget.addServiceRequest.paymentMode = paymentMode;
                              _con.createOrderId(context, _con.serviceCharge.toString()).then((value){
                                goOnlinePayment();
                              });
                            }else if(value == "cod"){
                              widget.addServiceRequest.paymentMode = paymentMode;
                              _con.checkOutService(context, widget.addServiceRequest);
                              paymentMode = "Cash on delivery";
                            }
                          });
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.themeColor, // Gray fill color
                        borderRadius: BorderRadius.circular(15.0), // Rounded corners
                      ),
                      child: Center(
                        child:   Text("Checkout",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
