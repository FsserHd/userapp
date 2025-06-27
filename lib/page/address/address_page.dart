import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/navigation/page_navigation.dart';
import 'package:userapp/page/address/edit_address_page.dart';
import 'package:userapp/utils/preference_utils.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/address_controller.dart';
import 'map_page.dart';

class AddressPage extends StatefulWidget {
  String type;
  AddressPage(this.type, {super.key});

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends StateMVC<AddressPage> {

  late AddressController _con;

  _AddressPageState() : super(AddressController()) {
    _con = controller as AddressController;
  }

  String? location = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PreferenceUtils.getLocation().then((value){
      setState(() {
        location = value;
      });
    });
    _con.listAddress(context);
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
        title: Text("Select Location",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '+ Add Address',
                            style: AppStyle.font14RegularBlack87.override(fontSize: 14),
                          ),
                          SizedBox(width: 10,),
                          Icon(Icons.arrow_right,color: Colors.deepOrange,),
                        ],
                      ),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapPage(),
                          ),
                        ).then((value){
                          _con.listAddress(context);
                        });
                      },
                    ),
                    if(location!=null)
                    SizedBox(height: 5,),
                    if(location!=null)
                    Divider(
                      color: Colors.grey,
                    ),
                    if(location!=null)
                    SizedBox(height: 5,),
                     if(location!=null)
                     Row(
                      children: [
                        Icon(Icons.gps_fixed,color: Colors.deepOrange,),
                        SizedBox(width: 10,),
                        Text(
                          'Current Location',
                          style: AppStyle.font14RegularBlack87.override(fontSize: 14),
                        ),
                      ],
                    ),
                    if(location!=null)
                    SizedBox(height: 5,),
                    if(location!=null)
                    Text(
                      location!=null ? location! : "",
                      style: AppStyle.font14RegularBlack87.override(fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Text(
                'Saved Address'.toUpperCase(),
                style: AppStyle.font14RegularBlack87.override(fontSize: 14,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20,),
             _con.addressResponseModel.data!=null ?  ListView.builder(
               physics: NeverScrollableScrollPhysics(),
                 shrinkWrap: true,itemCount: _con.addressResponseModel.data!.length,itemBuilder: (context,index){
                var addressBean = _con.addressResponseModel.data![index];
                _con.getDistanceAndTime(addressBean.latitude!, addressBean.longitude!,addressBean);
                return  InkWell(
                  onTap: (){
                    _con.checkZone(context,addressBean.latitude!, addressBean.longitude!,addressBean,widget.type);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8,bottom: 8),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Icon(Icons.shopping_bag_outlined,color: Colors.black,),
                              SizedBox(height: 2,),
                              Text(
                                addressBean.distance!,
                                style: AppStyle.font18BoldWhite.override(fontSize: 12,color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      addressBean.addresstype!,
                                      style: AppStyle.font18BoldWhite.override(fontSize: 14,color: Colors.black),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                            child: Icon(Icons.edit,size: 18,color: Colors.green,),onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditAddressPage(addressBean),
                                            ),
                                          ).then((value){
                                            _con.listAddress(context);
                                          });
                                        },),
                                        SizedBox(width: 10,),
                                        InkWell(
                                          onTap: (){
                                            _con.deleteAddress(context,addressBean.addressId!);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.delete,size: 18,color: Colors.red,),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  width: 250,
                                  child: Text(
                                    addressBean.address!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyle.font14RegularBlack87.override(fontSize: 14,),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  addressBean.mobile!,
                                  style: AppStyle.font14RegularBlack87.override(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }):Container(),
            ],
          ),
        ),
      ),
    );
  }

}
