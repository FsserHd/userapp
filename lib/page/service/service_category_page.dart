

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/model/service/service_category_model.dart';
import 'package:userapp/navigation/page_navigation.dart';
import 'package:userapp/utils/validation_utils.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/service_controller.dart';
import '../widget/description_preview.dart';

class ServiceCategoryPage extends StatefulWidget {

  const ServiceCategoryPage({super.key});

  @override
  _ServiceCategoryPageState createState() => _ServiceCategoryPageState();
}

class _ServiceCategoryPageState extends StateMVC<ServiceCategoryPage> {


  late ServiceController _con;

  _ServiceCategoryPageState() : super(ServiceController()) {
    _con = controller as ServiceController;
  }

  Set<int> _selectedIndices = Set();
  List<ServiceCategory> _selectedCategoryIndices = [];
  List<TextEditingController> _controllers = [];
  List<Widget> _textFields = [];
  List<String> selectCategoryList = [];
  var noteController = TextEditingController();
  var selectCategory = "Select Category";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.getServiceCategory(context);
    _con.getServiceBanner(context);
   // addTextField(""); // Initialize with one text field
  }

  void addTextField(String value) {
    TextEditingController controller = TextEditingController(text: value);
    _controllers.add(controller);

    setState(() {
      _textFields.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 250,
                height: 40,
                child: TextField(
                  controller:  controller,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white, // Gray fill color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      hintText: 'Enter category of service',
                      hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.grey,fontSize: 14)
                  ),
                ),
              ),
            ),
            SizedBox(width: 5,),
            InkWell(
              onTap: (){
                  setState(() {
                    _textFields.removeLast();
                  });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/minus.png",height: 30,width: 30,),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
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
        title: Text("Service Category",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: _con.serviceCategoryModel.data!=null && _con.serviceBannerModel.data!=null ?Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 60,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CarouselSlider(
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
                      items: _con.serviceBannerModel.data!.banner!.map((e) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                              ),
                              child: Image.network(
                                e.image!,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Enter your service inputs are as comma separated",style: AppStyle.font14MediumBlack87.override(
                                fontSize: 14
                            ),),
                            SizedBox(height: 10,),
                            TextField(
                              controller: noteController,
                              style: AppStyle.font14RegularBlack87.override(fontSize: 12),
                              decoration: InputDecoration(
                                hintText: 'Ex: Need Medicine, Parcel',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    color:AppColors.lightGray,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Center(
                        child: Text("( or )",style: AppStyle.font14MediumBlack87.override(
                            fontSize: 14
                        ),),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textFields.isNotEmpty?   Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.themeLightColor, // Background color
                                borderRadius: BorderRadius.circular(15.0), // Rounded corners
                                border: Border.all(
                                  color: Colors.grey.shade300, // Light gray border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.themeColor, // Background color
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0)), // Rounded corners
                                      border: Border.all(
                                        color: AppColors.themeColor, // Light gray border color
                                        width: 2.0, // Border width
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Others Category",
                                            maxLines: 1,overflow: TextOverflow.ellipsis,
                                            style: AppStyle.font18BoldWhite.override(fontSize: 16,color: Colors.white),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            addTextField("");
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset("assets/images/plus.png",height: 30,width: 30,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: _textFields.length,
                                      itemBuilder: (context,index){
                                        var widgetData = _textFields[index];
                                        return widgetData;
                                      })
                                ],
                              ),
                            ):Container(),
                            SizedBox(height: 10,),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:  _con.serviceCategoryModel.data!.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 columns
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 0.9, // Width/Height ratio
                              ),
                              itemBuilder: (context, index) {
                                var items = _con.serviceCategoryModel.data![index];
                                return InkWell(
                                  onTap: (){
                                    selectCategoryList.clear();
                                    _selectedCategoryIndices.clear();
                                    _con.selectedCategory = null;
                                    _con.serviceCategoryModel.data!.forEach((element) {
                                      if (element.id == items.id) {
                                        // _countryCodeController.text = element.cityname ;

                                        setState(() {
                                          _con.selectedCategory = element;
                                          selectCategory = element.name!;
                                          if (items.id != null) {
                                            _selectedCategoryIndices.add(
                                                element);
                                          }
                                        });
                                        print(selectCategory);
                                        print(_con.selectedCategory!.toJson());
                                        print(_selectedCategoryIndices[0]
                                            .toJson());
                                        PageNavigation.gotoAddServicePage(
                                          context,
                                          selectCategoryList,
                                          _selectedCategoryIndices,
                                          noteController,
                                          _con.selectedCategory,
                                        );
                                      }

                                    });
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                                borderRadius: BorderRadius.circular(20.0),
                                                child: Image.network(items.image!,height: 60,width: 60,)),
                                            SizedBox(height: 10,),
                                            Text(items.name!,style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.black54),),
                                            SizedBox(height: 2,),
                                            DescriptionPreview(description: items.description ?? ''),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                            // Container(
                            //   width: double.infinity,
                            //   decoration: BoxDecoration(
                            //     color: AppColors.themeLightColor, // Background color
                            //     borderRadius: BorderRadius.circular(15.0), // Rounded corners
                            //     border: Border.all(
                            //       color: Colors.grey.shade300, // Light gray border color
                            //       width: 2.0, // Border width
                            //     ),
                            //   ),
                            //   child:Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Container(
                            //         width: double.infinity,
                            //         decoration: BoxDecoration(
                            //           color: AppColors.themeColor, // Background color
                            //           borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0)), // Rounded corners
                            //           border: Border.all(
                            //             color: AppColors.themeColor, // Light gray border color
                            //             width: 2.0, // Border width
                            //           ),
                            //         ),
                            //         child: Column(
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text(
                            //                 "Select Below Category",
                            //                 maxLines: 1,overflow: TextOverflow.ellipsis,
                            //                 style: AppStyle.font18BoldWhite.override(fontSize: 16,color: Colors.white),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       // Padding(
                            //       //   padding: const EdgeInsets.all(8.0),
                            //       //   child: DropdownButtonFormField<ServiceCategory>(
                            //       //     hint: Text('Select a category'),
                            //       //     value: _con.selectedCategory, // Ensure this is either null or matches one of the dropdown items
                            //       //     onChanged: (ServiceCategory? newValue) {
                            //       //       setState(() {
                            //       //         _con.selectedCategory = newValue;
                            //       //         if (newValue != null) {
                            //       //           _selectedCategoryIndices.add(newValue);
                            //       //         }
                            //       //       });
                            //       //       PageNavigation.gotoAddServicePage(
                            //       //         context,
                            //       //         selectCategoryList,
                            //       //         _selectedCategoryIndices,
                            //       //         noteController,
                            //       //         _con.selectedCategory,
                            //       //       );
                            //       //     },
                            //       //     items: _con.serviceCategoryModel.data!.map<DropdownMenuItem<ServiceCategory>>(
                            //       //           (ServiceCategory category) {
                            //       //         return DropdownMenuItem<ServiceCategory>(
                            //       //           value: category,
                            //       //           child: Row(
                            //       //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       //             children: [
                            //       //               Text(category.name ?? ''),
                            //       //               SizedBox(width: 10),
                            //       //               Image.network(category.image!),
                            //       //             ],
                            //       //           ),
                            //       //         );
                            //       //       },
                            //       //     ).toList(),
                            //       //     decoration: InputDecoration(
                            //       //       filled: true,
                            //       //       fillColor: Colors.white,
                            //       //       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            //       //       border: OutlineInputBorder(
                            //       //         borderRadius: BorderRadius.circular(8),
                            //       //         borderSide: BorderSide(
                            //       //           color: Colors.grey,
                            //       //           width: 1.0,
                            //       //         ),
                            //       //       ),
                            //       //     ),
                            //       //   ),
                            //       // ),
                            //
                            //     ],
                            //   ),
                            // ),

                          ],
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    //print(_selectedCategoryIndices.toString());
                    //PageNavigation.gotoAddServicePage(context,_selectedCategoryIndices);
                    if(_selectedCategoryIndices.isEmpty && noteController.text.isEmpty){
                      ValidationUtils.showAppToast("Select Service Category or Given the service inputs");
                    }else {
                      selectCategoryList.clear();
                      _selectedCategoryIndices.clear();
                      _con.selectedCategory = null;
                      selectCategoryList.clear();
                      _controllers.forEach((element) {
                        selectCategoryList.add(element.text);
                      });
                      PageNavigation.gotoAddServicePage(
                          context, selectCategoryList,
                          _selectedCategoryIndices,noteController,_con.selectedCategory);
                    }
                  },
                  child: Container(
                    width: 300,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.themeColor, // Gray fill color
                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    ),
                    child: Center(
                      child:   Text("Continue",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ):Container(),
    );
  }

}
