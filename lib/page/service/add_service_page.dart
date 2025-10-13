

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/controller/service_controller.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/model/service/add_service_request.dart';
import 'package:userapp/model/service/service_category_model.dart';
import 'package:userapp/navigation/page_navigation.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../widget/description_preview.dart';

class AddServicePage extends StatefulWidget {
 // List<ServiceCategory> selectedCategoryIndices;
  List<String> selectCategoryList;
  List<ServiceCategory> selectedCategoryIndices;
  TextEditingController noteController;
  ServiceCategory? selectedCategory;
  AddServicePage(this.selectCategoryList,this.selectedCategoryIndices,  this.noteController, this.selectedCategory, {super.key});

  @override
  _AddServicePageState createState() => _AddServicePageState();
}

class _AddServicePageState extends StateMVC<AddServicePage> {

  late ServiceController _con;

  _AddServicePageState() : super(ServiceController()) {
    _con = controller as ServiceController;
  }
  var request = AddServiceRequest();

  var fromLocationController = TextEditingController();
  var toLocationController = TextEditingController();

  TextEditingController _dateTimeController = TextEditingController();
  DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  var deliveryLocation = "Delivery Location";
  var fromZoneId = "";
  var toZoneId = "";

  void _selectDateTime(BuildContext context) async {
    DateTime now = DateTime.now();

    // Show Date Picker with past dates disabled
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now, // Disable past dates
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      // Set initial time logic based on the selected date
      TimeOfDay initialTime = (selectedDate.year == now.year &&
          selectedDate.month == now.month &&
          selectedDate.day == now.day)
          ? TimeOfDay(hour: now.hour, minute: now.minute) // Restrict to current time if today
          : TimeOfDay(hour: 9, minute: 0); // Default starting time for future dates

      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );

      if (selectedTime != null) {
        // Prevent selecting past times only if the date is today
        if (selectedDate.year == now.year &&
            selectedDate.month == now.month &&
            selectedDate.day == now.day) {
          if (selectedTime.hour < now.hour ||
              (selectedTime.hour == now.hour && selectedTime.minute < now.minute)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please select a future time')),
            );
            return;
          }
        }

        DateTime finalDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // Ensure UI updates (if using StatefulWidget)
        _dateTimeController.text = _dateFormat.format(finalDateTime);
        _con.addServiceRequest.fromtime = _dateTimeController.text;

        print(_dateFormat.format(finalDateTime));
      }
    }
  }




  String serviceInput = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.noteController.text.isNotEmpty){
      serviceInput = widget.noteController.text;
    }else{
      print(widget.selectedCategory!.toJson());
      setState(() {
        serviceInput = widget.selectedCategory!.name!;
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _showConfirmationDialog(context);
    });
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm',style: AppStyle.font14RegularBlack87.override(fontSize: 14)),
          content: Text('Do you wish to import your current name, phone number, and address into the pickup location fields?',
          style: AppStyle.font14RegularBlack87.override(fontSize: 14),),
          actions: [
            TextButton(
              child: Text('Cancel',style: AppStyle.font14RegularBlack87.override(fontSize: 12),),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Confirm',style: AppStyle.font14RegularBlack87.override(fontSize: 12),),
              onPressed: () {
                // Perform the action and close the dialog
                _con.getProfile();
                Navigator.of(context).pop();
                // Additional action can be performed here
              },
            ),
          ],
        );
      },
    );
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
        title: Text("Other Services",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _con.serviceKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Given Service Input:',
                  style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: Colors.black87),
                ),
                SizedBox(height: 5,),
                widget.selectedCategoryIndices.isNotEmpty ? Container(
                  width: double.infinity,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                widget.selectedCategoryIndices[0].name!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyle.font14RegularBlack87.override(fontSize: 14),
                              ),
                              SizedBox(height: 2,),
                              DescriptionPreview(description:  widget.selectedCategoryIndices[0].description ?? ''),
                            ],
                          ),
                        ),
                        SizedBox(width: 20,),
                        Image.network( widget.selectedCategoryIndices[0].image!,height: 60,width: 60,),
                      ],
                    ),
                  ),
                ):Container(
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
                              widget.noteController.text,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/images/p_location.png"),
                        Text(
                          'Pickup Location',
                          style: AppStyle.font14MediumBlack87.override(fontSize: 16,color: AppColors.themeColor),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_drop_down,color: AppColors.themeColor,)
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  height: 52,
                  child: TextFormField(
                    controller: _con.fromNameController,
                    onSaved: (e){
                      _con.addServiceRequest.fromname = e;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200], // Gray fill color
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
                        hintText: 'Enter Name',
                        hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black)
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  height: 52,
                  child: TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    controller: _con.fromPhoneController,
                    onSaved: (e){
                      _con.addServiceRequest.fphoneno = e;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200], // Gray fill color
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
                        hintText: 'Enter Phone Number',
                        hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black)
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    _selectDateTime(context);
                  },
                  child: Container(
                    height: 52,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dateTimeController,
                        onSaved: (e){
                          _con.addServiceRequest.fromtime = e;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200], // Gray fill color
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
                            hintText: 'Pickup Date & Time',
                            hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black)
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),

            Container(
              height: 52,
              child: GestureDetector(
                onTap: () {
                 PageNavigation.gotoMapServiceLocation(context,"from","service").then((value){
                  setState(() {
                   // print("xxxxxxxx"+value);
                    request = value;
                    _con.fromLocation = request.fromlocation!;
                    fromLocationController.text = request.fromlocation!;
                    _con.addServiceRequest.fLatitude = request.fLatitude;
                    _con.addServiceRequest.fLongitude = request.fLongitude;
                    _con.addServiceRequest.zoneId = request.zoneId;
                  });
                 });
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Fill color
                    border: Border.all(
                      color: Colors.grey, // Border color
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0), // Border radius
                  ),
                  child: Text(
                    _con.fromLocation,
                    maxLines: 1,overflow: TextOverflow.ellipsis,
                    style: AppStyle.font14MediumBlack87.override(color: Colors.black),
                  ),
                )
              ),
            ),

                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/images/p_location.png"),
                            Text(
                              'Delivery Location',
                              style: AppStyle.font14MediumBlack87.override(fontSize: 16,color: AppColors.themeColor),
                            ),
                          ],
                        ),
                        SizedBox(width: 10,),
                        InkWell(
                          onTap: (){
                            _con.getToProfile();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // Fill color
                              border: Border.all(
                                color: AppColors.themeColor, // Border color
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0), // Border radius
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Auto fill',
                                style: AppStyle.font14MediumBlack87.override(fontSize: 14,color: AppColors.themeColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_drop_down,color: AppColors.themeColor,)
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  height: 52,
                  child: TextFormField(
                    controller: _con.toNameController,
                    onSaved: (e){
                      _con.addServiceRequest.toname = e;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200], // Gray fill color
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
                        hintText: 'Enter Name',
                        hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black)
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  height: 52,
                  child: TextFormField(
                    onSaved: (e){
                      _con.addServiceRequest.tophoneno = e;
                    },
                    controller: _con.toPhoneController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200], // Gray fill color
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
                        hintText: 'Enter Phone Number',
                        hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black)
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  height: 52,
                  child: GestureDetector(
                    onTap: () {
                      PageNavigation.gotoMapServiceLocation(context,"to","service").then((value){
                        setState(() {
                          request = value;
                          deliveryLocation  = request.fromlocation!;
                          toLocationController.text = request.fromlocation!;
                          _con.addServiceRequest.tLatitude = request.fLatitude;
                          _con.addServiceRequest.tLongitude = request.fLongitude;
                         // _con.addServiceRequest.zoneId = request.zoneId;
                        });
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Fill color
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0), // Border radius
                      ),
                      child: Text(
                        deliveryLocation,
                        maxLines: 1,overflow: TextOverflow.ellipsis,
                        style: AppStyle.font14MediumBlack87.override(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  height: 100,
                  child: TextFormField(
                    onSaved: (e){
                      _con.addServiceRequest.description = e;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200], // Gray fill color
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
                        hintText: 'Landmark / Any comments',
                        hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black)
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    _con.addServiceRequest.fromlocation = _con.fromLocation;
                    _con.addServiceRequest.tolocation = toLocationController.text;
                      _con.serviceKey.currentState!.save();
                      _con.addService(context,widget.selectCategoryList,widget.selectedCategoryIndices,serviceInput,widget.selectedCategory);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.themeColor, // Gray fill color
                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    ),
                    child: Center(
                      child:   Text("Submit",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
