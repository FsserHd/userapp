

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/model/home/home_model.dart';
import 'package:userapp/navigation/page_navigation.dart';
import 'package:userapp/utils/validation_utils.dart';

import '../../../constants/api_constants.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_style.dart';
import '../../../controller/home_controller.dart';
import '../../../utils/time_utils.dart';

class VendorPage extends StatefulWidget {

  Category categoryBean;
  
  VendorPage(this.categoryBean, {super.key});

  @override
  _VendorPageState createState() => _VendorPageState();
}

class _VendorPageState extends StateMVC<VendorPage> {

  late HomeController _con;

  _VendorPageState() : super(HomeController()) {
    _con = controller as HomeController;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.listVendorById(widget.categoryBean.shopFocusId!);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dashboardBgColor,
      appBar:  AppBar(
        backgroundColor: AppColors.themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.categoryBean.title!,style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.categoryBean.title!,
                    style: AppStyle.font18BoldWhite.override(fontSize: 16),
                  ),
                  SizedBox(height: 2,),
                  // Text(
                  //   "Fast on authentic ${widget.categoryBean.title}",
                  //   style: AppStyle.font18BoldWhite.override(fontSize: 12,color: Colors.grey),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Divider(color: Colors.grey,),
            SizedBox(height: 2,),
            _con.vendorModel.data!=null ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${_con.vendorModel.data!.length} Stores near by",
                style: AppStyle.font18BoldWhite.override(fontSize: 12,color: Colors.blue),
              ),
            ):Container(),
            SizedBox(height: 2,),
            Divider(color: Colors.grey,),
            SizedBox(height: 10,),
           _con.vendorModel.data!=null ?  ListView.builder(
              itemCount: _con.vendorList!.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context,index){
              var vendorBean = _con.vendorList[index];
              //_con.getDistanceAndTime(vendorBean.latitude!, vendorBean.longitude!);
              return InkWell(
                onTap: (){
                  if(vendorBean.livestatus == "true") {
                    if(vendorBean.type == "2") {
                      PageNavigation.gotoVendorProductPage(
                          context, vendorBean.vendorId, vendorBean);
                    }else{
                      PageNavigation.gotoGroceryCategoryPage(
                          context, vendorBean.vendorId, vendorBean);
                    }
                  }else{
                    ValidationUtils.showAppToast("The shop is currently not accepting online orders. ");
                  }
                },
                child: vendorBean.livestatus == "true" ? Padding(
                  padding: const EdgeInsets.only(top: 8,left: 8,right: 8,),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                      border: Border.all(
                        color: Colors.grey.shade300, // Light gray border color
                        width: 2.0, // Border width
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(vendorBean.logo!,height: 90,width: 90,fit: BoxFit.fill,)),
                                  vendorBean.closeTime!="0" ? Text("Closing time: "+TimeUtils.formatedTime(vendorBean.closeTime!),style: AppStyle.font14MediumBlack87.override(fontSize: 9,color: Colors.green),):Container(),
                                ],
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // To center the texts vertically
                                  crossAxisAlignment: CrossAxisAlignment.start, // To align the texts to the start
                                  children: [
                                    Text(
                                      vendorBean.generalDetail!.storeName!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: AppStyle.font14MediumBlack87.override(fontSize: 14),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      vendorBean.generalDetail!.subtitle!,
                                      style: AppStyle.font14MediumBlack87.override(fontSize: 12,color: Colors.black54),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      vendorBean.generalDetail!.landmark!=null ? vendorBean.generalDetail!.landmark! : "",
                                      style: AppStyle.font14MediumBlack87.override(fontSize: 12,color: Colors.black54),
                                    ),
                                    SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.star,size: 13,),
                                            Text(vendorBean.ratingTotal!,style  : AppStyle.font14MediumBlack87.override(fontSize: 12),),
                                          ],
                                        ),
                                        SizedBox(width: 10,),
                                        Text(vendorBean.distance!.toString(),style  : AppStyle.font14MediumBlack87.override(fontSize: 12),),
                                       /* SizedBox(width: 10,),
                                        Text(vendorBean.duration!,style  : AppStyle.font14MediumBlack87.override(fontSize: 12),),*/
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          vendorBean.discountType !=null ? Divider(color: Colors.grey[300],):Container(),
                          vendorBean.discountType !=null ? Row(
                            children: [
                              Image.asset("assets/images/percentage.png",height: 15,width:15,),
                              SizedBox(width: 10,),
                              vendorBean.discountType == "1" ?
                              Text("Flat ${ApiConstants.currency+vendorBean.discount.toString()} above ${ApiConstants.currency+vendorBean.upTo.toString()}",style: AppStyle.font18BoldWhite.override(fontSize: 12,color: Color(0xffF57C4A)),):
                              Text("${vendorBean.discount.toString()}% OFF above ${ApiConstants.currency+vendorBean.upTo.toString()}",style: AppStyle.font18BoldWhite.override(fontSize: 12,color: Color(0xffF57C4A)),),

                            ],
                          ):Container(),
                        ],
                      ),
                    ),
                  ),
                ):
                Padding(
                  padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300, // Background color
                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                      border: Border.all(
                        color: Colors.grey.shade300, // Light gray border color
                        width: 2.0, // Border width
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.grey.shade300,
                              BlendMode.saturation,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                vendorBean.logo!,
                                height: 90,
                                width: 90,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // To center the texts vertically
                              crossAxisAlignment: CrossAxisAlignment.start, // To align the texts to the start
                              children: [
                                Text(
                                  vendorBean.generalDetail!.storeName!,
                                  style: AppStyle.font18BoldWhite.override(fontSize: 16),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  vendorBean.generalDetail!.subtitle!,
                                  style: AppStyle.font14MediumBlack87.override(fontSize: 12),
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.star,size: 13,),
                                        Text(vendorBean.ratingTotal!,style  : AppStyle.font14MediumBlack87.override(fontSize: 12),),
                                      ],
                                    ),
                                    SizedBox(width: 10,),
                                    Text(vendorBean.distance!.toString(),style  : AppStyle.font14MediumBlack87.override(fontSize: 12),),
                                    // SizedBox(width: 10,),
                                    // Text(_con.duration,style  : AppStyle.font14MediumBlack87.override(fontSize: 12),),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  "Not delivering currently",
                                  style: AppStyle.font14RegularBlack87.override(fontSize: 14,color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              );
            }):ValidationUtils.showEmptyPage("No Shops Found", "assets/images/empty.png")
          ],
        ),
      ),
    );
  }
}
