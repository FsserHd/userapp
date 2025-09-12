
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userapp/constants/api_constants.dart';
import 'package:userapp/constants/app_colors.dart';
import 'package:userapp/controller/home_controller.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/navigation/page_navigation.dart';
import 'package:userapp/utils/time_utils.dart';
import 'package:userapp/utils/validation_utils.dart';

import '../../../constants/app_style.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends StateMVC<HomePage> {

  late HomeController _con;

  _HomePageState() : super(HomeController()) {
    _con = controller as HomeController;
  }

  int? selectedIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.homeData(context);
  }

  Future<void> openLink(String url) async {
    final String webUrl = url;
    await launchUrl(Uri.parse(webUrl));
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Always dispose controllers
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return _con.homeModel.data!=null ? SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InkWell(
              onTap: (){
                  PageNavigation.gotoSearchPage(context);
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Gray color fill
                  borderRadius: BorderRadius.circular(10), // Border radius
                  border: Border.all(
                    color: Colors.grey.shade300, // Border color
                    width: 0, // Border width
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Search items or shops..',
                      style: AppStyle.font14MediumBlack87.override(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            CarouselSlider(
              options: CarouselOptions(
                height: 150.0,
                autoPlay: true,
                enlargeCenterPage: false,
                aspectRatio: 32 / 12,
                autoPlayCurve: Curves.easeInOut,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
              items: _con.homeModel.data!.banner!.map((e) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: GestureDetector(
                        onTap: (){
                          if(e.bannertype == "link"){
                            openLink(e.link!);
                          }else {
                            PageNavigation.gotoBannerVendorPage(
                                context, e.vendorid!);
                          }
                        },
                        child: Image.network(
                          e.image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20,),
            GridView.builder(
              shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  crossAxisSpacing: 2, // Spacing between columns
                  mainAxisSpacing: 2, // Spacing between rows
                  childAspectRatio: 0.77
                ),
              itemCount: _con.homeModel.data!.category!.length,

                itemBuilder: (context,index){
                var categoryBean = _con.homeModel.data!.category![index];
              return InkWell(
                onTap: (){
                  if(categoryBean.shopType == "4"){
                    PageNavigation.gotoServiceCategoryPage(context);
                  }else {
                    PageNavigation.gotoVendorPage(context, categoryBean);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.dashboardShopTypeColor, // Gray background color
                          borderRadius: BorderRadius.circular(10.0), // Rounded corners
                        ),
                        padding: EdgeInsets.all(10.0), // Padding for inner content
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.dashboardShopTypeColor, // White background color for inner container
                            borderRadius: BorderRadius.circular(8.0), // Rounded corners for inner container
                          ),
                          padding: EdgeInsets.all(10.0), // Padding for icon
                          child: Image.network(categoryBean.coverImage!,height: 30,width: 30,),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(categoryBean.title!,style: AppStyle.font14MediumBlack87.override(color: Colors.black,fontSize: 10)),
                    ],
                  ),
                ),
              );
            }),
            Image.asset("assets/images/near.png",),
            SizedBox(height: 10,),
            Container(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _con.vendorTypeList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var bean = _con.vendorTypeList[index];
                  bool isSelected = selectedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          _con.filterVendor(bean.id!,"filter");
                          scrollToBottom();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.themeColor : Colors.transparent,
                          border: Border.all(
                            color: AppColors.themeColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text(
                              bean.name!+" ("+bean.count.toString()+")",
                              style: AppStyle.font18BoldWhite.override(
                                fontSize: 14,
                                color: isSelected ? Colors.white : AppColors.themeColor,
                              ),
                            ),
                            if (isSelected)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = null;
                                    _con.filterVendor(bean.id!,"clear");
                                    scrollToBottom();
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(Icons.close, color: Colors.white, size: 16),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10,),
            ListView.builder(
              controller: _scrollController, // Attach controller
              shrinkWrap: true,
              itemCount: _con.vendorList.length,
                itemBuilder: (context,index){
                var vendorBean = _con.vendorList[index];
               // _con.getDistanceAndTime(vendorBean.latitude!, vendorBean.longitude!);
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
                child: vendorBean.livestatus == "true" ?
                Padding(
                  padding: const EdgeInsets.only(top: 8),
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
                                      /*  SizedBox(width: 10,),
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
                  padding: const EdgeInsets.only(top: 8),
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
                                  style: AppStyle.font14MediumBlack87.override(fontSize: 14),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  vendorBean.generalDetail!.subtitle!,
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
            })
          ],
        ),
      ),
    ):Container();
  }

}
